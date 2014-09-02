//
//  AHStreamWidgetController.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHWidgetController.h"
#import "AHTweet.h"

// Controller that manages the display of incoming tweets in a stream widget (table view).
@interface AHStreamWidgetController : AHWidgetController <UITableViewDataSource>
// Clear all content
- (void)clear;

// Add new tweet to the stream widget.
- (void)addTweet:(id<AHTweet>)tweet;
@end
