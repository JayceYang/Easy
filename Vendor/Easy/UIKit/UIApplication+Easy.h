//
//  UIApplication+Easy.h
//  Sales
//
//  Created by Jayce Yang on 14/10/23.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIApplication (Easy)

+ (UIWindow *)sharedWindow;
+ (void)presentHUD;
+ (void)dismissHUD;

@end
