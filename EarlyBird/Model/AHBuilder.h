//
//  AHBuilder.h
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <Foundation/Foundation.h>

// General builder that provides method to populate objects from json data, or from a dictionary.
@interface AHBuilder : NSObject
+ (id)populateObject:(id)object fromJSON:(NSData *)json withDispatchTable:(NSDictionary *)table;
+ (id)populateObject:(id)object fromDictionary:(NSDictionary *)dic withDispatchTable:(NSDictionary *)table;
@end
