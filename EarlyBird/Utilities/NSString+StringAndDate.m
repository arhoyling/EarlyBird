//
//  NSString+String.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
#import <time.h>
#import "NSString+StringAndDate.h"

#define BUFFER_SIZE 32
@implementation NSString (StringAndDate)
+ (NSString *)stringWithDate:(NSDate *)date usingFormat:(NSString *)format {
    if ([format length] > BUFFER_SIZE) {
        DLog(@"Could not convert date to string using format %@. Format is too long.", format);
        return nil;
    }
    
    struct tm   tm_time;
    char        buffer[BUFFER_SIZE];
    time_t      seconds = (time_t)[date timeIntervalSince1970];
    
    gmtime_r(&seconds, &tm_time);
    strftime(buffer, sizeof(buffer), [format UTF8String], &tm_time);
    
    return [NSString stringWithCString:buffer encoding:NSUTF8StringEncoding];
}

- (NSDate *)dateUsingFormat:(NSString *)format {
    struct tm sometime;
    strptime([self UTF8String], [format UTF8String], &sometime);
    
    return [NSDate dateWithTimeIntervalSince1970:mktime(&sometime)];
}
@end
