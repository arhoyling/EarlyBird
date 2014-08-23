//
//  AHTwitterManager.m
//  EarlyBird
//
//  Created by Alex on 23/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTwitterManager.h"
#import "AHTweetBuilder.h"

@implementation AHTwitterManager
- (id)initWithConnector:(AHTwitterConnector *)connector delegate:(id<AHTwitterManagerDelegate>)delegate{
    self = [super init];
    
    if (self) {
        _connector = connector;
        _delegate = delegate;
        
        [self checkAccountAccess];
    }
    
    return self;
}

- (void)fetchTweetsWithHashtag:(NSString *)hashtag {
    [_connector closeConnection];
    [_connector openPublicStreamConnectionWithKeyword:hashtag];
}

#pragma mark - AHTwitterConnectorDelegate
- (void)didReceiveData:(NSData *)json {
    NSObject<AHTweet> *tweet = [AHTweetBuilder tweetFromJSON:json];

    // Warn delegate on the main thread.
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        [_delegate didReceiveTweet:tweet];
    });
}

#pragma mark - Utilities
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
                 DLog(@"Access to account failed. Error: %@", error);
                 [_delegate accessDidFailWithError:error];
                 return;
             }
             
             // Initialize connector and notify delegate
             [_connector setAccount:[accounts firstObject]];
             [_delegate accessGranted];
         });
     }];
}
@end
