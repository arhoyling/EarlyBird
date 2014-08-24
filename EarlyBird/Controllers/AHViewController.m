//
//  AHViewController.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHViewController.h"
#import "AHStreamWidgetController.h"

@interface AHViewController ()
@property (nonatomic) AHTwitterManager          *manager;
@property (nonatomic) AHStreamWidgetController  *streamWidget;
@end

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
    
    _streamWidget = [[AHStreamWidgetController alloc]init];
    _streamWidget.contentView.frame = mainFrame;
    [self.view addSubview:_streamWidget.contentView];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
    [_streamWidget clear];
}

#pragma mark - AHTWitterManagerDelegate
- (void)accessGranted {
#warning TODO Enable text field
}

// This method is called when the manager fails to find or connect to a valid twitter account.
- (void)accessDidFailWithError:(NSError *)error {
    UIAlertView *alert = [UIAlertView alloc];
    alert = [alert initWithTitle:NSLocalizedString(@"Account.AccessFailed.Title", nil)
                         message:NSLocalizedString(@"Account.AccessFailed.Message", nil)
                        delegate:self
               cancelButtonTitle:NSLocalizedString(@"Account.AccessFailed.Cancel", nil)
               otherButtonTitles:nil];
    [alert show];
}

- (void)didReceiveTweet:(NSObject<AHTweet> *)tweet {
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

@end
