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

@interface AHTwitterConnector () {
    NSData          *_newLine;
    NSMutableData   *_unprocessedData;
    NSRange          _nextRange;
}

@property (nonatomic) NSOperationQueue  *queue;
@property (nonatomic) NSURLConnection   *connection;
@end

NSString * const kTrackKey   = @"track";
NSString * const kDelimitedKey = @"delimited";
NSString * const kTwitterEndPoint = @"https://stream.twitter.com/1.1/statuses/filter.json";
NSString * const kDelimitedValue = @"length";
NSString * const kNewLine = @"\r\n";

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
        _unprocessedData = [NSMutableData data];
        _newLine = [kNewLine dataUsingEncoding:NSUTF8StringEncoding];
        _nextRange = NSRangeZero;
    }
    
    return self;
}

- (BOOL)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword {
    // Twitter stream api only allows one connection at a time per user.
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
    
    // Attach the account object to this request
    [request setAccount:account];
    // Get a signed version of the request to be consumed by an NSURLConnection
    NSURLRequest *urlRequest = [request preparedURLRequest];
        
    // Open the streaming connection with Twitter
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:self];
        
        // Ensure that the delegate callback will be called on a background queue.
        [_connection setDelegateQueue:_queue];
        [_connection start];
    });
    
    return YES;
}

- (void)closeConnection {
    if (_connection)
        [_connection cancel];
}

#pragma marl NSURLConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    [_unprocessedData appendData:data];
    
    // If we do not have the next message's range, look for it.
    if (NSEqualRanges(_nextRange, NSRangeZero)) {
        NSRange range = [_unprocessedData rangeOfData:_newLine
                                              options:0
                                                range:NSMakeRange(0, [_unprocessedData length])];
        
        // Check if we found a new line.
        if (!NSEqualRanges(range, NSRangeZero)) {
            // Retrieve message location
            _nextRange.location = RangeReach(range);
            
            // Retrieve message length
            _nextRange.length = [[[NSString alloc]initWithData:[data subdataWithRange:NSMakeRange(0, range.location)]
                                                       encoding:NSUTF8StringEncoding]integerValue];
        }
    }
    
    // We have enough data to process the next message
    if (RangeReach(_nextRange) <= [_unprocessedData length]) {
        // Send data to be processed
        [_delegate didReceiveData:[_unprocessedData subdataWithRange:_nextRange]];
        
        // Update data queue
        _unprocessedData = [[_unprocessedData subdataWithRange:NSMakeRange(RangeReach(_nextRange),
                                                                           [_unprocessedData length] - RangeReach(_nextRange))]
                            mutableCopy];
        _nextRange = NSRangeZero;
    }
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response {
    NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *)response;
    
    if (httpResponse.statusCode == 420 || httpResponse.statusCode == 429) {
        DLog(@"User exceeded limit");
        [_delegate didFailWithError:nil];
    }
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error {
    [_delegate didFailWithError:error];
}
@end
