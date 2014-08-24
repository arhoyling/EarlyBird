//
//  AHTweetCell.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTweetCell.h"
#import "NSString+StringAndDate.h"

NSString * const kDateStringFormat = @"%a %b %d %H:%M:%S";

@implementation AHTweetCell
@synthesize textLabel = _textLabel;

- (void)awakeFromNib {
    // Initialization code
    [_textLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma Setters -
- (void)setProfile:(NSString*)profile {
#warning TODO fetch profile picture asynchronously
}

- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

- (void)setDate:(NSDate *)date {
    _dateLabel.text = [NSString stringWithDate:date usingFormat:kDateStringFormat];
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
}

- (void)setRetweets:(NSInteger)count {
    _retweetsLabel.text = [NSString stringWithFormat:@"%d Cell.Retweets", count];
}
@end
