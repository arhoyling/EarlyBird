//
//  AHTwitterConnectorTests.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "OCMock.h"
#import "AHTwitterConnector.h"

@interface AHTwitterConnectorTests : XCTestCase

@end

@implementation AHTwitterConnectorTests

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

- (void)testMultiDataMessage {
    id mockDelegate = OCMProtocolMock(@protocol(AHTwitterConnectorDelegate));
    AHTwitterConnector *connector = [[AHTwitterConnector alloc]initWithDelegate:nil];
    connector.delegate = mockDelegate;
    
    NSString *stringData1 = NSLocalizedStringFromTableInBundle(@"TweetJsonPart1",
                                                               @"TestData",
                                                               [NSBundle bundleForClass:[self class]],
                                                               nil);
    NSData *data1 = [stringData1 dataUsingEncoding:NSUTF8StringEncoding];
    NSString *stringData2 = NSLocalizedStringFromTableInBundle(@"TweetJsonPart2",
                                                               @"TestData",
                                                               [NSBundle bundleForClass:[self class]],
                                                               nil);
    NSData *data2 = [stringData2 dataUsingEncoding:NSUTF8StringEncoding];
    
#warning TODO check data size
    [connector connection:[OCMArg any] didReceiveData:data1];
    [connector connection:[OCMArg any] didReceiveData:data2];
    OCMVerify([mockDelegate didReceiveData:[OCMArg any]]);
}

@end
