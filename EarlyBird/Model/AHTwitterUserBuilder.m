//
//  AHTwitterUserBuilder.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTwitterUserBuilder.h"
#import "AHRealTwitterUser.h"

@implementation AHTwitterUserBuilder
static NSDictionary * dispatchTable;
static dispatch_once_t onceToken;

// Create a user from an dictionary
+ (NSObject<AHTwitterUser>*)twitterUserFromJson:(NSData *)json {
    dispatch_once(&onceToken, ^{ [self generateDispatchTable]; });
                  
    return [self populateObject:[[AHRealTwitterUser alloc]init] fromJSON:json withDispatchTable:dispatchTable];
}

+ (NSObject<AHTwitterUser>*)twitterUserFromDictionary:(NSDictionary *)dic {
    dispatch_once(&onceToken, ^{ [self generateDispatchTable]; });

    return [self populateObject:[[AHRealTwitterUser alloc]init] fromDictionary:dic withDispatchTable:dispatchTable];
}

// The dispatch table is used to match json keys with properties in the tweet object. Population is done using the
// methods below; that allows us to perform some additional work (like conversions) if need be.
+ (void)generateDispatchTable {
    dispatchTable = @{@"id_str"             : @"userID",
                      @"name"               : @"name",
                      @"screen_name"        : @"screenName",
                      @"profile_image_url"  : @"profileImageUrl" };
}

#pragma mark - Adapters
+ (NSString *)userID:(NSString *)id_str { return id_str; }
+ (NSString *)name:(NSString *)name { return name; }
+ (NSString *)screenName:(NSString *)screen_name { return screen_name; }
+ (NSString *)profileImageUrl:(NSString *)profile_image_url { return profile_image_url; }

@end
