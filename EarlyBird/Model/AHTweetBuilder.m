//
//  AHTweetBuilder.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTweetBuilder.h"
#import "AHRealTweet.h"
#import "AHTwitterUser.h"
#import "AHTwitterUserBuilder.h"
#import "NSString+StringAndDate.h"

// Format of tweets date
NSString * const kTweetDateFormat = @"%a %b %d %H:%M:%S %z %Y";

@implementation AHTweetBuilder
static NSDictionary * dispatchTable;
static dispatch_once_t onceToken;

+ (NSObject<AHTweet>*)tweetFromJSON:(NSData *)tweetJson {
    dispatch_once(&onceToken, ^{ [self generateDispatchTable]; });
    
    return [self populateObject:[[AHRealTweet alloc]init] fromJSON:tweetJson withDispatchTable:dispatchTable];
}

// The dispatch table is used to match json keys with properties in the tweet object. Population is done using the
// methods below; that allows us to perform some additional work (like conversions) if need be.
+ (void)generateDispatchTable {
    dispatchTable = @{@"id_str"       : @"tweetID",
                      @"user"         : @"author",
                      @"created_at"   : @"date",
                      @"text"         : @"text",
                      @"retweet_count": @"retweets"};
}

#pragma - Adapters
// Convert Json id_str into a tweetID.
+ (NSString *)tweetID:(NSString *)id_str {
    return id_str;
}

+ (id<AHTwitterUser>)author:(NSDictionary *)userDic {
    return [AHTwitterUserBuilder twitterUserFromDictionary:userDic];
}

// Convert Json created_at time to our own AHTweet date (NSDate).
+ (NSDate *)date:(NSString *)created_at {
    return [created_at dateUsingFormat:kTweetDateFormat];
}

// Convert Json text into our own AHTWeet text (no change).
+ (NSString *)text:(NSString *)text {
    return text;
}

// Convert Json retweet_count into our own AHTweet retweets.
+ (NSInteger *)retweets:(NSInteger *)retweet_count {
    return retweet_count;
}

@end
