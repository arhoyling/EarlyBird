//
//  AHTweetBuilder.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import <time.h>
#import "AHTweetBuilder.h"
#import "AHRealTweet.h"
#import "AHTwitterUser.h"
#import "AHTwitterUserBuilder.h"

// Format of tweets date
NSString * const kDateFormat = @"%a %b %d %H:%M:%S %z %Y";

@implementation AHTweetBuilder
static NSDictionary * dispatchTable;
static dispatch_once_t onceToken;

+ (NSObject<AHTweet>*)tweetFromJSON:(NSData *)tweetJson {
    dispatch_once(&onceToken, ^{ [self generateDispatchTable]; });
    
    return [self populateObject:[[AHRealTweet alloc]init] fromJSON:tweetJson withDispatchTable:dispatchTable];
}
     
 + (void)generateDispatchTable {
     dispatchTable = @{@"id_str"       : @"tweetID",
                       @"user"         : @"author",
                       @"created_at"   : @"date",
                       @"text"         : @"text",
                       @"retweet_count": @"retweets"};
 }

#pragma Adapters
// Convert Json id_str into a tweetID.
+ (NSString *)tweetID:(NSString *)id_str {
    return id_str;
}

+ (id<AHTwitterUser>)author:(NSDictionary *)userDic {
    return [AHTwitterUserBuilder twitterUserFromDictionary:userDic];
}

// Convert Json created_at time to our own AHTweet date (NSDate).
+ (NSDate *)date:(NSString *)created_at {
    struct tm sometime;
    strptime([created_at UTF8String], [kDateFormat UTF8String], &sometime);
    
    return [NSDate dateWithTimeIntervalSince1970:mktime(&sometime)];
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
