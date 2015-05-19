//
//  UIDevice+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-10-24.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIDevice (Easy)

+ (NSString *)currentModel;
+ (BOOL)runningOnSimulator;
- (NSString *)UUIDString;

@end
