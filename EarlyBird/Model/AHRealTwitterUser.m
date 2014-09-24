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

- (NSUInteger)hash {
    NSUInteger result = 17;
    result = 31 * result + [userID hash];
    result = 31 * result + [name hash];
    result = 31 * result + [screenName hash];
    result = 31 * result + [profileImageUrl hash];
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@> %@ (%@)", self.userID, self.name, self.screenName, nil];
}

@end
