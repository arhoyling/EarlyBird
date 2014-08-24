//
//  AHWidgetController.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//
@interface AHWidgetController : NSObject
@property (nonatomic) UIView *contentView;
@property (nonatomic, readonly, getter = isViewLoaded) BOOL loaded;

- (void)loadView;
- (void)viewDidLoad;
@end
