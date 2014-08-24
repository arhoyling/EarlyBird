//
//  AHViewController.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHViewController.h"
#import "AHStreamWidgetController.h"
#import "AHTweetQueryView.h"

@interface AHViewController ()
@property (nonatomic) AHTwitterManager          *manager;
@property (nonatomic) AHStreamWidgetController  *streamWidget;
@property (nonatomic) AHTweetQueryView          *queryView;
@end

NSString * const kHashChar = @"#";

@implementation AHViewController
- (id)init {
    self = [super init];
    
    if (self) {
        _manager = [[AHTwitterManager alloc]initWithDelegate:self];
        AHTwitterConnector *connector = [[AHTwitterConnector alloc]initWithDelegate:_manager];
        _manager.connector = connector;
    }
    
    return self;
}

- (void)loadView {
    // Set up the base view
    CGRect mainFrame = [[UIScreen mainScreen] applicationFrame];
    self.view = [[UIView alloc] initWithFrame:mainFrame];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
    
    // Initialize query section
    _queryView = [[AHTweetQueryView alloc]init];
    [_queryView.watchButton addTarget:self action:@selector(watchQuery:) forControlEvents:UIControlEventTouchUpInside];
    [_queryView.queryField setDelegate:self];
    [_queryView.watchButton setEnabled:NO];
    [_queryView.queryField setEnabled:NO];
    [self.view addSubview:_queryView];
    
    _streamWidget = [[AHStreamWidgetController alloc]init];
    _streamWidget.contentView.frame = CGRectMake(mainFrame.origin.x,
                                                 mainFrame.origin.y + _queryView.bounds.size.height,
                                                 mainFrame.size.width,
                                                 mainFrame.size.height - _queryView.bounds.size.height);
    [self.view addSubview:_streamWidget.contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_streamWidget clear];
}

#pragma mark - Query
- (IBAction)watchQuery:(id)sender {
    [_queryView.queryField endEditing:YES];
    if ([_queryView.queryField.text length] == 0)
        [_manager stopWatchingPublicStream];
    else
        [self startWatchingWithKeyword:_queryView.queryField.text];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField endEditing:YES];
    if ([_queryView.queryField.text length] == 0)
        [_manager stopWatchingPublicStream];
    else
        [self startWatchingWithKeyword:_queryView.queryField.text];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if ([string isEqualToString:@" "])
        return NO;
    
    return YES;
}

#pragma mark - AHTwitterManagerDelegate
- (void)accessGranted {
    [_queryView.watchButton setEnabled:YES];
    [_queryView.queryField setEnabled:YES];
}

// This method is called when the manager fails to find or connect to a valid twitter account.
- (void)accessDidFailWithError:(NSError *)error {
    DLog(@"Access to account failed. Error: %@", error);
    
    [_queryView.watchButton setEnabled:NO];
    [_queryView.queryField setEnabled:NO];
    
    UIAlertView *alert = [UIAlertView alloc];
    alert = [alert initWithTitle:NSLocalizedString(@"Account.AccessFailed.Title", nil)
                         message:NSLocalizedString(@"Account.AccessFailed.Message", nil)
                        delegate:self
               cancelButtonTitle:NSLocalizedString(@"Account.AccessFailed.Cancel", nil)
               otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveTweet:(NSObject<AHTweet> *)tweet {
    NSLog(@"Tweet: %@", tweet.text);
    if (tweet)
        [_streamWidget addTweet:tweet];
}

- (void)couldNotWatchStream {
    UIAlertView *alert = [UIAlertView alloc];
    alert = [alert initWithTitle:NSLocalizedString(@"Stream.ConnectionFailed.Title", nil)
                         message:NSLocalizedString(@"Stream.ConnectionFailed.Message", nil)
                        delegate:nil
               cancelButtonTitle:NSLocalizedString(@"Stream.ConnectionFailed.Cancel", nil)
               otherButtonTitles:nil];
    [alert show];
}
   
#pragma mark UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [_manager checkAccountAccess];
}

#pragma mark - Utilities
- (void)startWatchingWithKeyword:(NSString *)keyword {
    [_manager stopWatchingPublicStream];
    
    if ([keyword length] > 0)
        [_manager watchPublicStreamWithHashtag:[self hashtagFromString:keyword]];
}

- (NSString *)hashtagFromString:(NSString *)string {
    if (string == nil || [string hasPrefix:kHashChar])
        return string;
    
    return [kHashChar stringByAppendingString:string];
}
@end
