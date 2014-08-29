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
@property (nonatomic) AHTwitterConnector                *connector;
@property (nonatomic) id                                 delegate;
@property (nonatomic) ACAccount                         *account;
@end

@implementation AHTwitterConnectorTests
- (void)setUp {
    [super setUp];
    
    _delegate = OCMProtocolMock(@protocol(AHTwitterConnectorDelegate));
    _connector = [[AHTwitterConnector alloc]initWithDelegate:_delegate];
    _account = OCMClassMock([ACAccount class]);
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

// Test that the connector warns the delegate if the connection request was not valid.
- (void)testValidConnectionRequest {
    [_connector openStreamConnectionWithAccount:_account keyword:@""];
    OCMVerify([_delegate didFailWithError:[OCMArg any]]);
}

- (void)testChunkedMessages {
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
    
    NSString *stringFull = NSLocalizedStringFromTableInBundle(@"TweetJsonFull",
                                                              @"TestData",
                                                              [NSBundle bundleForClass:[self class]],
                                                              nil);
    NSData *full = [stringFull dataUsingEncoding:NSUTF8StringEncoding];
    
    // Check that didReceiveData method is called on the delegate after we receive the full message and that
    // the message is valid.
    [_connector openStreamConnectionWithAccount:[OCMArg any] keyword:nil];
    [_connector connection:[OCMArg any] didReceiveData:data1];
    [_connector connection:[OCMArg any] didReceiveData:data2];
    OCMVerify([_delegate didReceiveData:[OCMArg isEqual:full]]);
    
    // Check that didReceiveData method is not called on the delegate after we receive only part of the message.
    [[_delegate reject] didReceiveData:[OCMArg any]];
    //[_connector connection:[OCMArg any] didReceiveData:data1];
    [_delegate verify];
    
    // Check that the connector is properly reset when we close the connection.
    // Data from a previous connection should not corrupt data from the current connection.
    [_connector openStreamConnectionWithAccount:[OCMArg any] keyword:nil];
    [_connector connection:[OCMArg any] didReceiveData:data1];
    [_connector closeConnection];
    [_connector openStreamConnectionWithAccount:[OCMArg any] keyword:nil];
    [_connector connection:[OCMArg any] didReceiveData:data2];
    [_delegate verify];
}

void sleepFor(NSTimeInterval interval) {
    NSTimeInterval start = [[NSProcessInfo processInfo] systemUptime];
    while([[NSProcessInfo processInfo] systemUptime] - start <= interval)
        [[NSRunLoop currentRunLoop] runMode: NSDefaultRunLoopMode beforeDate: [NSDate date]];
}

// Asynchronous test of the timeout mechanism of the connector.
- (void)testTimeoutReset {
    int timeout = 5;
    [_connector setTimeout:timeout];
    
    [_connector openStreamConnectionWithAccount:[OCMArg any] keyword:nil];
    [_connector connection:[OCMArg any] didReceiveData:nil];
    
    sleepFor(timeout+1);

    OCMVerify([_delegate willResetAfterTimeInterval:0.0]);
    [_connector closeConnection];
    
    // Test that no timeout is triggered if some data is retrieved within 90 seconds.
    [[_delegate reject] willResetAfterTimeInterval:0.0];
    [_connector openStreamConnectionWithAccount:[OCMArg any] keyword:nil];
    [_connector connection:[OCMArg any] didReceiveData:nil];
    sleepFor(timeout/2.0);
    [_connector connection:[OCMArg any] didReceiveData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    sleepFor((timeout /2.0) + 1);
    [_delegate verify];
}

@end
