//
//  UILabel+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-10-10.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "UILabel+Easy.h"

@implementation UILabel (Easy)

- (void)usingSystemFont
{
    self.font = [UIFont systemFontOfSize:self.font.pointSize];
}

- (void)usingBoldSystemFont
{
    self.font = [UIFont boldSystemFontOfSize:self.font.pointSize];
}

- (void)usingFontWithName:(NSString *)name
{
    self.font = [UIFont fontWithName:name size:self.font.pointSize];
}

@end
