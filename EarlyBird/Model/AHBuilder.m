//
//  AHBuilder.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

@import ObjectiveC.runtime;
#import "AHBuilder.h"

@implementation AHBuilder
+ (id)populateObject:(id)object fromJSON:(NSData *)json withDispatchTable:(NSDictionary *)table {
    NSError* error;
    NSDictionary *parsedJson = [NSJSONSerialization JSONObjectWithData:json
                                                               options:NSJSONReadingMutableContainers
                                                                 error:&error];
    
    if (error) {
        DLog(@"Failed to parse Json while creating %@ object. Error: %@", NSStringFromClass([object class]), [error description]);
        return nil;
    }
    
    return [self populateObject:object fromDictionary:parsedJson withDispatchTable:table];
}

+ (id)populateObject:(id)object fromDictionary:(NSDictionary *)dic withDispatchTable:(NSDictionary *)table {
    // For every key in the dictionary
    for (NSString *key in dic) {
        // Check if there is a corresponding key in the disptach table
        // Check that the corresponding value in the dispatch table is a valid selector.
        if (table[key] && class_getProperty([object class], [table[key] UTF8String])) {
            SEL selector = NSSelectorFromString([table[key] stringByAppendingString:@":"]);
            
            // Update new tweet object with the current value.
            [object setValue:[[self class] performSelector:selector withObject:dic[key]]
                      forKey:table[key]];
        }
    }
    
    return object;
}
@end
