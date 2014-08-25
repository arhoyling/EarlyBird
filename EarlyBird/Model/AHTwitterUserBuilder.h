//
//  AHTwitterUserBuilder.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import "AHTwitterUser.h"
#import "AHBuilder.h"

// Builder generating twitter users from Json data or a dictionary.
@interface AHTwitterUserBuilder : AHBuilder

// Create a user from an dictionary
+ (NSObject<AHTwitterUser>*)twitterUserFromJson:(NSData *)json;
+ (NSObject<AHTwitterUser>*)twitterUserFromDictionary:(NSDictionary *)dic;
@end
