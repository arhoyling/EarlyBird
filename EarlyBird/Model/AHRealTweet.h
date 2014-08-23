//
//  AHRealTweet.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTweet.h"
#import "AHTwitterUser.h"

// Concrete implementation of the AHTweet interface.
@interface AHRealTweet : NSObject <AHTweet>
@property (nonatomic) NSString                  *tweetID;
@property (nonatomic) NSObject<AHTwitterUser>   *author;
@property (nonatomic) NSDate                    *date;
@property (nonatomic) NSString                  *text;
@property (nonatomic) NSInteger                  retweets;
@end
