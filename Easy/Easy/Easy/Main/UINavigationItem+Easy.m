//
//  UINavigationItem+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-11-18.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "UINavigationItem+Easy.h"

#import "NSObject+Easy.h"

@implementation UINavigationItem (Easy)

- (void)setPreferedTitleView:(UIView *)view
{
    [self setPreferedTitleView:view autoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setPreferedTitleView:(UIView *)view autoresizingMask:(UIViewAutoresizing)mask
{
    UINavigationBar *navigationBar = self.currentNavigationController.navigationBar;
    CGFloat width = CGRectGetWidth(navigationBar.bounds);
    CGFloat height = CGRectGetHeight(navigationBar.bounds);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    titleView.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = mask;
    view.center = CGPointMake(width / 2, height / 2);
    [titleView addSubview:view];
    self.titleView = titleView;
}

@end
