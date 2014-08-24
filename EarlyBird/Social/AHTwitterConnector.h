//
//  AHTwitterConnector.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@import Accounts;

// AHTwitterConnectorDelegate is a wrapper for NSURLConnectionDataDelegate.
@protocol AHTwitterConnectorDelegate <NSURLConnectionDataDelegate>
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
@end

@interface AHTwitterConnector : NSObject
@property (nonatomic, weak) id<AHTwitterConnectorDelegate>   delegate;

- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate;

// Open a public stream connection to Twitter's API with the given account, filtering results
// with the specified keyword.
// This method returns YES if the connection was successfully opened, NO otherwise.
- (BOOL)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword;

// Cancel the current connection if any.
- (void)closeConnection;
@end
