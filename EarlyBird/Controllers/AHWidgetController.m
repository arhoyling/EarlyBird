//
//  AHWidgetController.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHWidgetController.h"

@implementation AHWidgetController
#pragma mark - Accessors
- (UIView *)contentView {
    if (_contentView == nil) {
        _contentView = [[UIView alloc]init];
        
        [self loadView];
        [self viewDidLoad];
    }
    
    return _contentView;
}

- (void)loadView { }

- (void)viewDidLoad {
    _loaded = YES;
}

@end