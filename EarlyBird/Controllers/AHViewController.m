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
@property (nonatomic) AHTwitterManager          *manager;       // Manager of twitter specific operations
@property (nonatomic) AHStreamWidgetController  *streamWidget;  // Controller taking care of tweeter display
@property (nonatomic) AHTweetQueryView          *queryView;     // Interface to let user input hashtags.

@property (nonatomic) UIActivityIndicatorView   *indicator;
@end

NSString * const kHashChar = @"#";

#pragma mark -
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
    
    _indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _indicator.color = [UIColor grayColor];
    _indicator.hidden = YES;
    _indicator.hidesWhenStopped = YES;
    _indicator.center = _streamWidget.contentView.center;
    
    [self.view addSubview:_indicator];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self
                                                                                 action:@selector(resignOnTap:)];
    
    [self.view addGestureRecognizer:tapGesture];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_streamWidget clear];
}

#pragma mark -
- (IBAction)watchQuery:(id)sender {
    [_queryView.queryField endEditing:YES];
    if ([_queryView.queryField.text length] == 0)
        [_manager stopWatchingPublicStream];
    else
        [self startWatchingWithKeyword:_queryView.queryField.text];
}

#pragma mark UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    if ([_queryView.queryField.text length] == 0)
        [_manager stopWatchingPublicStream];
    else
        [self startWatchingWithKeyword:_queryView.queryField.text];
    
    return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    // Do not allow white space
    if ([string isEqualToString:@" "])
        return NO;
    
    return YES;
}

#pragma mark AHTwitterManagerDelegate
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
    if (tweet) {
        [_indicator stopAnimating];
        [_streamWidget addTweet:tweet];
    }
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
    [_streamWidget clear];
    
    if ([keyword length] > 0) {
        [_indicator startAnimating];
        [_manager watchPublicStreamWithHashtag:[self hashtagFromString:keyword]];
    }
}

// Add a hash at the beginning of the keyword if it is not there already.
- (NSString *)hashtagFromString:(NSString *)string {
    if (string == nil || [string hasPrefix:kHashChar])
        return string;
    
    return [kHashChar stringByAppendingString:string];
}

// Hide keyboard when tapping outside of the query field.
- (void)resignOnTap:(id)sender {
    [_queryView.queryField resignFirstResponder];
}
@end
