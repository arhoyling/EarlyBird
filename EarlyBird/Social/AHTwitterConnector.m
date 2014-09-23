//
//  AHTwitterConnector.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import <Social/SLRequest.h>
#import <Twitter/Twitter.h>
#import "AHTwitterConnector.h"
#import "AHTwitterErrors.h"

@interface AHTwitterConnector () {
    NSMutableData   *_dataQueue;
    NSRange          _nextRange;
    NSData          *_newLine;

// Connection management
    NSString        *_cachedKeyword;
    ACAccount       *_cachedAccount;
    NSTimer         *_tTimeOut;
    NSTimer         *_tReconnect;
    NSTimeInterval   _reconnInterval;
}

@property (nonatomic) NSOperationQueue  *queue;
@property (nonatomic) NSURLConnection   *connection;
@end

// Time interval before time out.
enum {
    kTimeOutInterval = 90
};

static const NSTimeInterval kGrowthStep = 0.25;

NSString * const kTrackKey          = @"track";
NSString * const kDelimitedKey      = @"delimited";
NSString * const kTwitterEndPoint   = @"https://stream.twitter.com/1.1/statuses/filter.json";
NSString * const kDelimitedValue    = @"length";
NSString * const kNewLine           = @"\r\n";

#define NSRangeZero NSMakeRange(NSNotFound, 0)
NS_INLINE NSInteger RangeReach(NSRange range) {
    return range.location + range.length;
}

#pragma mark -
@implementation AHTwitterConnector
- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate; {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _queue = [[NSOperationQueue alloc] init];
        //_dataQueue = [NSMutableData data]; // This is not necessary with the current flow.
        _newLine = [kNewLine dataUsingEncoding:NSUTF8StringEncoding];
        _nextRange = NSRangeZero;
        _reconnInterval = 0.0;
        _timeout = kTimeOutInterval;
    }
    
    return self;
}

- (void)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword {
    // Twitter stream api only allows one connection at a time per user,
    // but let's make sure we close everything on our side.
    [self closeConnection];
    
    // We want to avoid unfiltered streaming as the number of tweets per second
    // is huge.
    if (!keyword || [keyword length] == 0) {
        [self failWithTwitterErrorCode:TRTwitterErrorNoKeyword];
        return;
    }
        
    // The delimited key allows us to retrieve the size of the messages we receive. This size is important
    // as messages can arrive in chuncks.
    NSDictionary *params = @{ kTrackKey : keyword,
                              kDelimitedKey : kDelimitedValue};
    
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:kTwitterEndPoint];
    
    //  Build the request with our parameter
    SLRequest *request  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                             requestMethod:SLRequestMethodPOST
                                                       URL:url
                                                parameters:params];
    
    @try {
        // Attach the account object to this request. If the account is not valid, this
        // assignment will throw an exception.
        [request setAccount:account];
    } @catch (NSException *exception) {
        [self failWithTwitterErrorCode:TRTwitterErrorInvalidAccount];
        return;
    }
    
    // Get a signed version of the request to be consumed by an NSURLConnection
    NSURLRequest *urlRequest = [request preparedURLRequest];
    
    // Prepare for time out
    _cachedAccount = account;
    _cachedKeyword = keyword;
    
    // Open the streaming connection with Twitter
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
        // Ensure that the delegate callback will be called on a background queue.
        [_connection setDelegateQueue:_queue];
        [_connection start];
        [self startTimeOutTimer];
    });
}

- (void)closeConnection {
    [self cancelTimers];
        
    // Make sure to reset data queue.
    _dataQueue = [NSMutableData data];
    
    if (_connection)
        [_connection cancel];
}

#pragma mark NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    _reconnInterval = 0.0;
    [self startTimeOutTimer];
    
    // Maintain the connection but do nothing.
    if ([data isEqual:_newLine])
        return;
    
    [_dataQueue appendData:data];
    
    // If we do not have the next message's range, look for it.
    if (NSEqualRanges(_nextRange, NSRangeZero)) {
        NSRange range = [_dataQueue rangeOfData:_newLine
                                              options:0
                                                range:NSMakeRange(0, [_dataQueue length])];
        
        // Check if we found a new line
        if (!NSEqualRanges(range, NSRangeZero)) {
            _nextRange.location = RangeReach(range);
            _nextRange.length = [[[NSString alloc]initWithData:[_dataQueue subdataWithRange:NSMakeRange(0, range.location)]
                                                      encoding:NSUTF8StringEncoding]integerValue];
        }
    }
    
    // If we have enough data to process the next message
    if (!NSEqualRanges(_nextRange, NSRangeZero) && RangeReach(_nextRange) <= [_dataQueue length]) {
        // Send the complete message to the delegate.
        [_delegate didReceiveData:[_dataQueue subdataWithRange:_nextRange]];
        
        // Remove the message we just forwarded from the data queue.
        _dataQueue = [[_dataQueue subdataWithRange:NSMakeRange(RangeReach(_nextRange),
                                                                           [_dataQueue length] - RangeReach(_nextRange))]
                            mutableCopy];
        _nextRange = NSRangeZero;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if (httpResponse.statusCode == 420 || httpResponse.statusCode == 429) {
        DLog(@"User exceeded limit");
        [self closeConnection];
        [self failWithTwitterErrorCode:TRTwitterErrorUserLimitReached];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [self closeConnection];
    [_delegate didFailWithError:error];
}

#pragma mark - 
- (void)failWithTwitterErrorCode:(NSInteger)code {
    NSError *error;
    
    error = [NSError errorWithDomain:TRTwitterErrorDomain
                                code:code
                            userInfo:nil];
    
    [_delegate didFailWithError:error];
}

#pragma mark Timer utilities
// Invalidate and nullify all timers
- (void)cancelTimers {
    if (_tTimeOut)
        [_tTimeOut invalidate];
    
    if (_tReconnect)
        [_tReconnect invalidate];
    
    _tTimeOut = nil;
    _tReconnect = nil;
}

// Cancel timers and start connection timeout timer.
- (void)startTimeOutTimer {
    [self cancelTimers];
    _tTimeOut = [NSTimer scheduledTimerWithTimeInterval:_timeout
                                                target:self selector:@selector(resetConnection)
                                              userInfo:nil
                                               repeats:NO];
}

// Prepare for reconnection. Reconnection will happen after the dynamic time interval _reconnInterval.
- (void)resetConnection {
    [self closeConnection];
    
    // Warn the delegate that the connection timed out and we are about to reconnect.
    if ([(NSObject *)_delegate respondsToSelector:@selector(willResetAfterTimeInterval:)]) {
        [_delegate willResetAfterTimeInterval:_reconnInterval];
    }
    
    _tReconnect = [NSTimer scheduledTimerWithTimeInterval:_reconnInterval
                                                   target:self
                                                 selector:@selector(reconnect)
                                                 userInfo:nil
                                                  repeats:NO];
}

- (void)reconnect {
    // This interval grows linearly by 250 ms as recommended by twitter's documentation.
    _reconnInterval += kGrowthStep;
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [self openStreamConnectionWithAccount:_cachedAccount keyword:_cachedKeyword];
    });
}
@end
