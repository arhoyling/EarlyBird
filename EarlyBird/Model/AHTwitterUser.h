//
//  AHTwitterUser.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <Foundation/Foundation.h>

// Interface for objects describing a twitter user.
@protocol AHTwitterUser <NSObject>
@property (nonatomic) NSString *userID;             // id_str
@property (nonatomic) NSString *name;               // name
@property (nonatomic) NSString *screenName;         // screen_name
@property (nonatomic) NSString *profileImageUrl;    // profile_image_url
@end
