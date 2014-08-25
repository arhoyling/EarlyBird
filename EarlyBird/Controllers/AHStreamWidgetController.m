//
//  AHStreamWidgetController.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHStreamWidgetController.h"
#import "../Views/AHTweetCell.h"

// This is used as a place holder for a UIImage.
@interface ImageWrapper : NSObject
@property (nonatomic) UIImage *image;
@end

@implementation ImageWrapper
@end

#pragma mark -
#pragma mark -
@interface AHStreamWidgetController () {
    NSIndexPath *_cachedIndex;}

@property (nonatomic) UITableView       *tableView;
@property (nonatomic) NSMutableArray    *tweets;
@property (nonatomic) NSMutableArray    *profileImages;
@end

NSString * const kTweetCellID = @"TweetCell";

#pragma mark -
@implementation AHStreamWidgetController
- (id)init {
    self = [super init];
    
    if (self) {
        _tweets = [[NSMutableArray alloc]init];
        _profileImages = [[NSMutableArray alloc]init];
        _cachedIndex = [NSIndexPath indexPathForRow:0 inSection:0];
    }
    
    return self;
}

- (void)loadView {
    _tableView = [[UITableView alloc]initWithFrame:CGRectZero
                                             style:UITableViewStylePlain];
    _tableView.dataSource = self;
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    _tableView.rowHeight = 97;
    
    self.contentView = _tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_tableView registerClass:[AHTweetCell class] forCellReuseIdentifier:kTweetCellID];
}

- (void)addTweet:(id<AHTweet>)tweet {
    ImageWrapper *wrapper = [[ImageWrapper alloc]init];
    [_profileImages insertObject:wrapper atIndex:_cachedIndex.row];
    // Create profile image
    [self initializeWrapperAsynchronously:wrapper withDataAtPath:tweet.author.profileImageUrl];
    
    [_tweets insertObject:tweet atIndex:_cachedIndex.row];
    
    [_tableView insertRowsAtIndexPaths:@[_cachedIndex] withRowAnimation:UITableViewRowAnimationTop];
}

- (void)clear {
    _tweets = [[NSMutableArray alloc]init];
    _profileImages = [[NSMutableArray alloc]init];
    [_tableView reloadData];
}

#pragma mark - UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // Try to retrieve from the table view a now-unused cell with the given identifier.
	AHTweetCell *cell = [_tableView dequeueReusableCellWithIdentifier:kTweetCellID];
    
    if (cell == nil) {
        cell = [[AHTweetCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kTweetCellID];
    }
    
    NSObject<AHTweet> *tweet = _tweets[indexPath.item];
    [cell setName:tweet.author.name];
    [cell setDate:tweet.date];
    [cell setText:tweet.text];
    
    ImageWrapper *wrapper = _profileImages[indexPath.item];
    if (wrapper.image) {
        [cell setProfile:wrapper.image];
    }
    
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [_tweets count];
}

#pragma mark Utilities
// Initialize image wrapped in wrapper using content at the given path.
// This operation is performed asynchronously on a global queue with default priority.
// Once the image is created, this method tries to update the corresponding cell on the main thread.
- (void)initializeWrapperAsynchronously:(ImageWrapper *)wrapper withDataAtPath:(NSString *)path {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^(void) {
        NSURL *url = [NSURL URLWithString:[path stringByReplacingOccurrencesOfString:@"_normal" withString:@"_bigger"]];
        NSData *data = [NSData dataWithContentsOfURL:url];
        
        if(data){
            wrapper.image = [UIImage imageWithData:data];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                NSIndexPath *indexPath = [NSIndexPath indexPathForRow:[_profileImages indexOfObject:wrapper]
                                                            inSection:0];
                [self updateVisibleCellAtIndexPath:indexPath];
            });
        }
    });
}

// Update the cell at the given NSIndexPath if it is visible and there exists an image for it.
// If everything goes well, the cell is redrawn.
- (void)updateVisibleCellAtIndexPath:(NSIndexPath *)indexPath {
    NSArray* indexPaths = [_tableView indexPathsForVisibleRows];
    if ([indexPaths containsObject:indexPath]) {
        AHTweetCell *cell = (AHTweetCell *)[_tableView cellForRowAtIndexPath:indexPath];
        ImageWrapper *wrapper = _profileImages[indexPath.item];
        
        if (wrapper.image) {
            [cell setProfile:wrapper.image];
            [cell setNeedsLayout];
        }
    }
}

@end
