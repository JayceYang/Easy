//
//  UITextField+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "UITextField+Easy.h"

@implementation UITextField (Easy)

- (void)makePadding:(CGFloat)padding
{
    [self makeLeftPadding:padding];
    [self makeRightPadding:padding];
}

- (UIView *)makeLeftPadding:(CGFloat)padding
{
    UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, CGRectGetHeight(self.bounds))];
    leftView.backgroundColor = [UIColor clearColor];
    self.leftView = leftView;
    self.leftViewMode = UITextFieldViewModeAlways;
    
    return leftView;
}

- (UIView *)makeRightPadding:(CGFloat)padding
{
    UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, padding, CGRectGetHeight(self.bounds))];
    rightView.backgroundColor = [UIColor clearColor];
    self.rightView = rightView;
    self.rightViewMode = UITextFieldViewModeAlways;
    
    return rightView;
}

@end
