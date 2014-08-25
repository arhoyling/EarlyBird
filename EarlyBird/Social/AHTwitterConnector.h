//
//  AHTwitterConnector.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@import Accounts;

// AHTwitterConnectorDelegate is a wrapper for NSURLConnectionDataDelegate.
@protocol AHTwitterConnectorDelegate
- (void)didReceiveData:(NSData *)data;
- (void)didFailWithError:(NSError *)error;
@end

@interface AHTwitterConnector : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, weak) id<AHTwitterConnectorDelegate>   delegate;

- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate;

// Open a public stream connection to Twitter's API with the given account, filtering results
// with the specified keyword.
- (void)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword;

// Cancel the current connection if any.
- (void)closeConnection;
@end
