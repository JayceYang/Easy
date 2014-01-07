//
//  UINavigationItem+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-11-18.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Easy)

- (void)setPreferedTitleView:(UIView *)view;
- (void)setPreferedTitleView:(UIView *)view autoresizingMask:(UIViewAutoresizing)mask;

@end
