//
//  AHRealTwitterUser.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHRealTwitterUser.h"

@implementation AHRealTwitterUser
@synthesize userID;
@synthesize name;
@synthesize screenName;
@synthesize profileImageUrl;

- (BOOL)isEqual:(NSObject<AHTwitterUser> *)other {
    return  [self class] == [other class]
        &&  [self.userID isEqualToString:other.userID]
        &&  [self.name isEqualToString:other.name]
        &&  [self.screenName isEqualToString:other.screenName]
        &&  [self.profileImageUrl isEqualToString:other.profileImageUrl];
}

#warning TODO add hash method that guarantees equality of hashes when two objects are equal.
@end
