//
//  UIApplication+Easy.m
//  Sales
//
//  Created by Jayce Yang on 14/10/23.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "UIApplication+Easy.h"

@implementation UIApplication (Easy)

+ (UIWindow *)sharedWindow {
    return [[[UIApplication sharedApplication] delegate] window];
}

@end
