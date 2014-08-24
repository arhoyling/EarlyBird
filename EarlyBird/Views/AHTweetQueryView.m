//
//  AHTweetQueryView.m
//  EarlyBird
//
//  Created by Alex on 24/08/2014.
//  Copyright (c) 2014 Alex R. Hoyling. All rights reserved.
//

#import "AHTweetQueryView.h"

@implementation AHTweetQueryView

-(id)init{
   return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class])
                                                          owner:self
                                                        options:nil] firstObject];
}

@end
