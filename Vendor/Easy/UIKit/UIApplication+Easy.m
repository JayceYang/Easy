//
//  UIApplication+Easy.m
//  Sales
//
//  Created by Jayce Yang on 14/10/23.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "UIApplication+Easy.h"

#import "UIViewController+Easy.h"

@implementation UIApplication (Easy)

+ (UIWindow *)sharedWindow {
    return [[[UIApplication sharedApplication] delegate] window];
}

+ (void)presentHUD {
    [[[UIApplication sharedWindow] rootViewController] presentHUD];
}

+ (void)dismissHUD {
    [[[UIApplication sharedWindow] rootViewController] dismissHUD];
}

@end
