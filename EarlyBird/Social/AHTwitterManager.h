//
//  AHTwitterManager.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

@import Accounts;
#import "AHTwitterConnector.h"
#import "AHTweet.h"

// Delegate for the twitter manager. Reacts to connection events (success, or failure) and to new tweets.
@protocol AHTwitterManagerDelegate
// This method is called when the manager receives a new tweet.
- (void)didReceiveTweet:(NSObject<AHTweet> *)tweet;

// This method is called when the manager successfully connects to a twitter account on the device.
- (void)accessGranted;
// This method is called when the manager fails to find or connect to a valid twitter account.
- (void)accessDidFailWithError:(NSError *)error;
@end

// AHTwitterManager manages user requests and feeds back tweets accordingly.
@interface AHTwitterManager : NSObject <AHTwitterConnectorDelegate>
@property (nonatomic, weak) id<AHTwitterManagerDelegate>  delegate;
@property (nonatomic) AHTwitterConnector                 *connector;

// Initialize with a network connector.
- (id)initWithConnector:(AHTwitterConnector *)connector delegate:(id<AHTwitterManagerDelegate>)delegate;
- (void)fetchTweetsWithHashtag:(NSString *)hashtag;
@end
