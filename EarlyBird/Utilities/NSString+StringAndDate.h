//
//  NSDate_NSDate_PrettyString.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

// Utility category to convert strings and dates quickly.
@interface NSString (StringAndDate)
+ (NSString *)stringWithDate:(NSDate *)date usingFormat:(NSString *)format;
- (NSDate *)dateUsingFormat:(NSString *)format;
@end
