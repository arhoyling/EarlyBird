//
//  AHStreamWidgetController.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHStreamWidgetController.h"
#import "../Views/AHTweetCell.h"

@interface AHStreamWidgetController ()
@property (nonatomic) UITableView    *tableView;
@property (nonatomic) NSMutableArray *tweets;
@end

NSString * const kTweetCellID = @"TweetCell";

@implementation AHStreamWidgetController
- (id)init {
    self = [super init];
    
    if (self) {
        _tweets = [[NSMutableArray alloc]init];
    }
    
    return self;
}

- (void)loadView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                             style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    
    self.contentView = _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerClass:[AHTweetCell class] forCellReuseIdentifier:kTweetCellID];
}


- (void)clear {
    [_tableView reloadData];
}

// Add new tweet
- (void)addTweet:(id<AHTweet>)tweet {
    [_tweets addObject:tweet];
    [_tableView reloadData];
}

#pragma mark UITableViewDataSource -
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Try to retrieve from the table view a now-unused cell with the given identifier.
	AHTweetCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    
    NSObject<AHTweet> *tweet = _tweets[indexPath.item];
    [cell setName:tweet.author.name];
    [cell setProfile:tweet.author.profileImageUrl];
    [cell setDate:tweet.date];
    [cell setText:tweet.text];
    [cell setRetweets:tweet.retweets];
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
}

@end
