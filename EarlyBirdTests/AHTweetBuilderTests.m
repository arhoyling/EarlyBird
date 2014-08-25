//
//  AHTweetBuilderTests.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AHTweetBuilder.h"
#import "AHRealTweet.h"
#import "AHRealTwitterUser.h"

@interface AHTweetBuilderTests : XCTestCase
@property (nonatomic) NSObject<AHTweet> *tweetRef;
@end

@implementation AHTweetBuilderTests
- (void)setUp {
    [super setUp];
    NSObject<AHTwitterUser> *userRef = [[AHRealTwitterUser alloc]init];
    userRef.userID = @"6253282";
    userRef.name = @"John Doe";
    userRef.screenName = @"jdoe";
    userRef.profileImageUrl = @"http://d1avok0lzls2w.cloudfront.net/img_users/63.jpg?1397137774";
    
    _tweetRef = [[AHRealTweet alloc]init];
    _tweetRef.tweetID = @"12738165059";
    _tweetRef.author = userRef;
    _tweetRef.date = [NSDate dateWithTimeIntervalSince1970:1287094815];
    _tweetRef.text = @"@themattharris hey how are things?";
    _tweetRef.retweets = 0;
}

- (void)tearDown {
    [super tearDown];
}

#pragma mark Tweet buildling test
- (void)testBuildTweetFromJson {
    NSString *stringData = NSLocalizedStringFromTableInBundle(@"TweetJsonFull",
                                                              @"TestData",
                                                              [NSBundle bundleForClass:[self class]],
                                                              nil);
    NSData * data = [stringData dataUsingEncoding:NSUTF8StringEncoding];
    
    NSLog(@"data size: %d", data.length);
    NSObject<AHTweet> *tweet = [AHTweetBuilder tweetFromJSON:data];
    XCTAssertTrue([tweet isEqual:_tweetRef]);
}

@end
