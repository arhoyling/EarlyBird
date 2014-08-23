//
//  AHTwitterConnector.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTwitterConnector.h"
#import <Social/SLRequest.h>

@interface AHTwitterConnector ()
@property (nonatomic) NSURLConnection   *connection;
@property (nonatomic) NSOperationQueue  *queue;
@end

NSString * const kTrackKey   = @"track";
NSString * const kTwitterEndPoint = @"https://stream.twitter.com/1.1/statuses/filter.json";

@implementation AHTwitterConnector
- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (void)openPublicStreamConnectionWithKeyword:(NSString *)keyword {
    if (_account == nil) {
        DLog(@"Failed to open connection. No valid account.");
        return;
    }
    
    NSDictionary *params = @{ kTrackKey : keyword};
    
    //  The endpoint that we wish to call
    NSURL *url = [NSURL URLWithString:kTwitterEndPoint];
    
    //  Build the request with our parameter
    SLRequest *request  = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                             requestMethod:SLRequestMethodPOST
                                                       URL:url
                                                parameters:params];
    
    // Attach the account object to this request
    [request setAccount:_account];
    
    // Open the streaming connection with Twitter
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _connection = [NSURLConnection connectionWithRequest:[request preparedURLRequest]
                                                    delegate:self];
        // Ensure that the delegate callback will be called on a background queue.
        [_connection setDelegateQueue:_queue];
        [_connection start];
    });
}

- (void)closeConnection {
    if (_connection) {
        [_connection cancel];
        _connection = nil;
    }
}

#pragma mark - NSUrlConnectionDataDelegate
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data {
    if (_delegate && data)
        [_delegate didReceiveData:data];
}
@end
