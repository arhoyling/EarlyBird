//
//  AHTwitterManager.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTweet.h"
#import "AHTwitterConnector.h"

// Delegate for the twitter manager. Reacts to connection events (success, or failure) and to new tweets.
@protocol AHTwitterManagerDelegate
// This method is called when the manager receives a new tweet.
- (void)didReceiveTweet:(NSObject<AHTweet> *)tweet;
// This method is called when the manager fails to watch the public stream.
- (void)couldNotWatchStream;

// This method is called when the manager successfully connects to a twitter account on the device.
- (void)accessGranted;
// This method is called when the manager fails to find or connect to a valid twitter account.
- (void)accessDidFailWithError:(NSError *)error;
@end

// AHTwitterManager manages user requests and feeds back tweets accordingly.
@interface AHTwitterManager : NSObject <AHTwitterConnectorDelegate>
@property (nonatomic) AHTwitterConnector                 *connector;
@property (nonatomic, weak) id<AHTwitterManagerDelegate>  delegate;
@property (nonatomic, readonly, getter = isWatching) BOOL watching;

// Initialize with a network connector.
- (id)initWithDelegate:(id<AHTwitterManagerDelegate>)delegate;

// Watch twitter's public stream in real-time using the given hashtag.
- (void)watchPublicStreamWithHashtag:(NSString *)hashtag;

// Stop watching twitter's public stream.
- (void)stopWatchingPublicStream;

// Check if there is any valid twitter account. If there is one, retrieve the credentials.
- (void)checkAccountAccess;
@end
