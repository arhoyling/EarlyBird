//
//  AHTweetCell.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTweetCell.h"
#import "NSString+StringAndDate.h"

NSString * const kDateStringFormat = @"%H:%M:%S";

@implementation AHTweetCell
@synthesize textLabel = _textLabel;

// Load view from nib
- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                          owner:self
                                        options:nil] firstObject];
}

#pragma Setters -
- (void)setProfile:(UIImage*)profileImage {
    [_profileView setImage:profileImage];
}

- (void)setName:(NSString *)name {
    _nameLabel.text = name;
}

// Convert date to a short string
- (void)setDate:(NSDate *)date {
    _dateLabel.text = [NSString stringWithDate:date usingFormat:kDateStringFormat];
}

- (void)setText:(NSString *)text {
    _textLabel.text = text;
    [_textLabel sizeToFit];
}

@end