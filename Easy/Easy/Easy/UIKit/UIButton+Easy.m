//
//  UIButton+Easy.m
//  DJIExhibition
//
//  Created by Jayce Yang on 14-5-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "UIButton+Easy.h"

@implementation UIButton (Easy)

- (void)usingFontWithName:(NSString *)name
{
    self.titleLabel.font = [UIFont fontWithName:name size:self.titleLabel.font.pointSize];
}

@end
