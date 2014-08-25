//
//  AHRealTwitterUser.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTwitterUser.h"

// Concrete twitter user
@interface AHRealTwitterUser : NSObject <AHTwitterUser>
@property (nonatomic) NSString *userID;
@property (nonatomic) NSString *name;
@property (nonatomic) NSString *screenName;
@property (nonatomic) NSString *profileImageUrl;
@end
