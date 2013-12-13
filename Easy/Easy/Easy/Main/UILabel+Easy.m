//
//  UILabel+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-10-10.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
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

@end
