//
//  EarlyBirdTests.m
//  EarlyBirdTests
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "NSString+StringAndDate.h"

@interface EarlyBirdTests : XCTestCase

@end

@implementation EarlyBirdTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

NSString * const kDateFormat = @"%a %b %d %H:%M:%S %z %Y";
NSString * const kStringFormat = @"%a %b %d %H:%M:%S";

#pragma mark - Date formatting tests
- (void)testStringWithDate {
    NSString *stringRef = @"Thu Oct 14 22:20:15 +0000 2010";
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:1287094815];
    NSString *dateString = @"Thu Oct 14 22:20:15";
    
    XCTAssertTrue([[stringRef dateUsingFormat:kDateFormat] isEqual:date]);
    XCTAssertTrue([[NSString stringWithDate:date usingFormat:kStringFormat] isEqualToString:dateString]);
}
@end
