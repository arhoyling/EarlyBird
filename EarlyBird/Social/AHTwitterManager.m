//
//  AHTwitterManager.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@import Accounts;

#import "AHTwitterManager.h"
#import "AHTweetBuilder.h"

@interface AHTwitterManager ()
@property (nonatomic) ACAccount       *account;
@property (nonatomic, readwrite) BOOL  watching;
@end

enum { kResetDelay = 20 };

#pragma mark -
@implementation AHTwitterManager
- (id)initWithDelegate:(id<AHTwitterManagerDelegate>)delegate {
    self = [super init];
    
    if (self) {
        _delegate = delegate;
        _watching = NO;
        
        [self checkAccountAccess];
    }
    
    return self;
}

- (void)watchPublicStreamWithHashtag:(NSString *)hashtag {
    if (_connector) {
        [_connector openStreamConnectionWithAccount:_account keyword:hashtag];
        _watching = YES;
    }
}

- (void)stopWatchingPublicStream {
    if (_connector) {
        [_connector closeConnection];
        _watching = NO;
    }
}

#pragma mark - AHTwitterConnectorDelegate
- (void)didReceiveData:(NSData *)data {
    NSObject<AHTweet> *tweet = [AHTweetBuilder tweetFromJSON:data];
    
    // Warn delegate on the main thread.
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [_delegate didReceiveTweet:tweet];
    });
}

- (void)didFailWithError:(NSError *)error {
    [self stopWatchingPublicStream];
#warning TODO handle error types.
    DLog(@"Connection limit for this user. Error: %@", error);
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [_delegate couldNotWatchStream];
    });
}

// Check that there is a valid twitter account configured on the device.
- (void)checkAccountAccess {
    ACAccountStore *accountStore = [[ACAccountStore alloc] init];
    ACAccountType *twitterAccountType = [accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    [accountStore requestAccessToAccountsWithType:twitterAccountType
                                          options:nil
                                       completion:^(BOOL granted, NSError *error)
     {
         dispatch_async(dispatch_get_main_queue(), ^{
             NSArray *accounts = [accountStore accountsWithAccountType:twitterAccountType];
             
             // Forward error to delegate
             if (!granted || [accounts count] == 0) {
                 [_delegate accessDidFailWithError:error];
                 return;
             }
             
             // Initialize connector and notify delegate
             _account = [accounts firstObject];
             [_delegate accessGranted];
         });
     }];
}
@end
