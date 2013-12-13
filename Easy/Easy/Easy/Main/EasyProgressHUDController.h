//
//  EasyProgressHUDController.h
//  Easy
//
//  Created by Jayce Yang on 13-9-27.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface EasyProgressHUDController : NSObject

+ (void)showInView:(UIView *)view;
+ (void)showInView:(UIView *)view status:(NSString *)status;
+ (void)dismissFromView:(UIView *)view;

+ (void)updateStatus:(NSString *)status forView:(UIView *)view;

@end
