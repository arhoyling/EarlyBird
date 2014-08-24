//
//  AHTwitterConnector.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import <Social/SLRequest.h>
#import "AHTwitterConnector.h"

@interface AHTwitterConnector ()
@property (nonatomic) NSOperationQueue  *queue;
@property (nonatomic) NSURLConnection   *connection;
@end

NSString * const kTrackKey   = @"track";
NSString * const kTwitterEndPoint = @"https://stream.twitter.com/1.1/statuses/filter.json";

#pragma mark -
@implementation AHTwitterConnector
- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate; {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _queue = [[NSOperationQueue alloc] init];
    }
    
    return self;
}

- (BOOL)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword {
    // Twitter stream api only allows one connection at a time per user.
    NSDictionary *params = @{ kTrackKey : keyword};
    
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
    
    // Stop here if the request cannot be handled.
    if (![NSURLConnection canHandleRequest:urlRequest])
        return NO;
    
    // Open the streaming connection with Twitter
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        _connection = [NSURLConnection connectionWithRequest:urlRequest delegate:_delegate];
        
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
@end
