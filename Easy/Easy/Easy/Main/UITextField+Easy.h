//
//  UITextField+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITextField (Easy)

- (void)makePadding:(CGFloat)padding;
- (UIView *)makeLeftPadding:(CGFloat)padding;
- (UIView *)makeRightPadding:(CGFloat)padding;

@end
