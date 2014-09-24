//
//  AHRealTweet.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHRealTweet.h"

@implementation AHRealTweet
@synthesize tweetID;
@synthesize author;
@synthesize date;
@synthesize text;
@synthesize retweets;

- (BOOL)isEqual:(NSObject<AHTweet> *)other {
    return  [other class] == [self class]
        &&  [self.tweetID isEqualToString:other.tweetID]
        &&  [self.author isEqual:other.author]
        &&  [self.date isEqualToDate:other.date]
        &&  [self.text isEqualToString:other.text]
        &&   self.retweets == other.retweets;
}

- (NSUInteger)hash {
    NSUInteger result = 17;
    result = 31 * result + [tweetID hash];
    result = 31 * result + [author hash];
    result = 31 * result + [date hash];
    result = 31 * result + [text hash];
    result = 31 * result + retweets;
    return result;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"<%@> %@ - %@", self.tweetID, self.author.name, self.text, nil];
}
@end
