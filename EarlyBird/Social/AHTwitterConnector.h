//
//  AHTwitterConnector.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@import Accounts;

@protocol AHTwitterConnectorDelegate
- (void)didReceiveData:(NSData *)json;
@end

@interface AHTwitterConnector : NSObject <NSURLConnectionDataDelegate>
@property (nonatomic, weak) id<AHTwitterConnectorDelegate>  delegate;
@property (nonatomic) ACAccount                            *account;

- (id)initWithDelegate:(id<AHTwitterConnectorDelegate>)delegate;

// Open a twitter public stream connection with the given keyword. Twitter stream api only allows one connection at a
// time per user.
// Any received data will be notified to the delegate.
- (void)openPublicStreamConnectionWithKeyword:(NSString *)keyword;

// Close connection.
- (void)closeConnection;
@end
