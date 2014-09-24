//
//  AHModelTests.m
//  EarlyBird
//
//  Created by Lexus on 24/09/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "AHRealTweet.h"
#import "AHRealTwitterUser.h"

@interface AHModelTests : XCTestCase

@end

@implementation AHModelTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testTweetUser {
    NSObject<AHTwitterUser> *user = [[AHRealTwitterUser alloc]init];
    user.userID = @"6253282";
    user.name = @"John Doe";
    user.screenName = @"jdoe";
    user.profileImageUrl = @"http://d1avok0lzls2w.cloudfront.net/img_users/63.jpg?1397137774";
    
    NSObject<AHTwitterUser> *sameUser = [[AHRealTwitterUser alloc]init];
    sameUser.userID = @"6253282";
    sameUser.name = @"John Doe";
    sameUser.screenName = @"jdoe";
    sameUser.profileImageUrl = @"http://d1avok0lzls2w.cloudfront.net/img_users/63.jpg?1397137774";
    
    NSObject<AHTwitterUser> *otherUser = [[AHRealTwitterUser alloc]init];
    otherUser.userID = @"6253284";
    otherUser.name = @"Jane Smith";
    otherUser.screenName = @"jsmith";
    otherUser.profileImageUrl = @"http://d1avok0lzls2w.cloudfront.net/img_users/63.jpg?1397137774";
    
    XCTAssertTrue([user isEqual:user]);
    XCTAssertTrue([user isEqual:sameUser]);
    XCTAssertTrue([user hash] == [sameUser hash]);
    XCTAssertFalse([user isEqual:otherUser]);
    XCTAssertFalse([user hash] == [otherUser hash]);
}

- (void)testTweet {
    NSObject<AHTwitterUser> *userRef = [[AHRealTwitterUser alloc]init];
    userRef.userID = @"6253282";
    userRef.name = @"John Doe";
    userRef.screenName = @"jdoe";
    userRef.profileImageUrl = @"http://d1avok0lzls2w.cloudfront.net/img_users/63.jpg?1397137774";
    
    NSObject<AHTweet> *tweet = [[AHRealTweet alloc]init];
    tweet.tweetID = @"12738165059";
    tweet.author = userRef;
    tweet.date = [NSDate dateWithTimeIntervalSince1970:1287094815];
    tweet.text = @"@themattharris hey how are things?";
    tweet.retweets = 0;
    
    NSObject<AHTweet> *sameTweet = [[AHRealTweet alloc]init];
    sameTweet.tweetID = @"12738165059";
    sameTweet.author = userRef;
    sameTweet.date = [NSDate dateWithTimeIntervalSince1970:1287094815];
    sameTweet.text = @"@themattharris hey how are things?";
    sameTweet.retweets = 0;
    
    NSObject<AHTweet> *otherTweet = [[AHRealTweet alloc]init];
    otherTweet.tweetID = @"12738165060";
    otherTweet.author = userRef;
    otherTweet.date = [NSDate dateWithTimeIntervalSince1970:1287094816];
    otherTweet.text = @"@themattharris hey how are things?";
    otherTweet.retweets = 0;
    
    XCTAssertTrue([tweet isEqual:sameTweet]);
    XCTAssertTrue([tweet hash] == [sameTweet hash]);
    XCTAssertFalse([tweet isEqual:otherTweet]);
    XCTAssertFalse([tweet hash] == [otherTweet hash]);
}

@end
