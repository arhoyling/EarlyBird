//
//  AHTwitterConnector.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@import Accounts;

@protocol AHTwitterConnectorDelegate
- (void)didReceiveData:(NSData *)data;
- (void)didFailWithError:(NSError *)error;
@optional
- (void)willResetAfterTimeInterval:(NSTimeInterval)interval;
@end

// Connector managing network connection with Twitter stream api.
// It is responsible for reconstructing messages and resetting connection in case of TCP errors.
@interface AHTwitterConnector : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, weak) id<AHTwitterConnectorDelegate>  delegate;
@property (nonatomic) NSTimeInterval                        timeout;

- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate;

// Open a public stream connection to Twitter's API with the given account, filtering results
// with the specified keyword.
- (void)openStreamConnectionWithAccount:(ACAccount *)account keyword:(NSString *)keyword;

// Cancel the current connection if any.
- (void)closeConnection;
@end
