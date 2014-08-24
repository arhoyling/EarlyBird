//
//  AHStreamWidgetController.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHWidgetController.h"
#import "AHTweet.h"

@interface AHStreamWidgetController : AHWidgetController <UITableViewDataSource>
// Clear all content;
- (void)clear;

// Add new tweet
- (void)addTweet:(id<AHTweet>)tweet;
@end
