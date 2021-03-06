//
//  AHTweetBuilder.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTweet.h"
#import "AHBuilder.h"

// Builder that generates tweets from Json data.
@interface AHTweetBuilder : AHBuilder

// Parse a json description and create a tweet.
+ (NSObject<AHTweet>*)tweetFromJSON:(NSData *)tweetJson;
@end
