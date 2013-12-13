//
//  UINavigationItem+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-11-18.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationItem (Easy)

- (void)setPreferedTitleView:(UIView *)view;
- (void)setPreferedTitleView:(UIView *)view autoresizingMask:(UIViewAutoresizing)mask;

@end
