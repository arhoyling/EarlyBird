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
    DLog(@"Start watching public stream for hashtag %@", hashtag);
    if (!_connector || ![_connector openStreamConnectionWithAccount:_account keyword:hashtag]) {
        _watching = NO;
        [_delegate couldNotWatchStream];
    } else {
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

- (void)didReachRateLimit {
    [_connector closeConnection];
    DLog(@"Connection reached rate limit for this user.");
    
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [_delegate couldNotWatchStream];
    });
}

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
