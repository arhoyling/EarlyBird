//
//  AHTweetCell.h
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AHTweetCell : UITableViewCell
@property (nonatomic) IBOutlet UIImageView  *profileView;
@property (nonatomic) IBOutlet UILabel      *nameLabel;
@property (nonatomic) IBOutlet UILabel      *dateLabel;
@property (nonatomic) IBOutlet UILabel      *textLabel;
@property (nonatomic) IBOutlet UILabel      *retweetsLabel;

- (void)setProfile:(NSString*)profile;
- (void)setName:(NSString *)name;
- (void)setDate:(NSDate *)date;
- (void)setText:(NSString *)text;
- (void)setRetweets:(NSInteger)count;
@end
