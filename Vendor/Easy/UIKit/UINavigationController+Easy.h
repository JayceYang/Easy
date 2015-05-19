//
//  UINavigationController+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/25/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UINavigationController (Easy)

- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated popTopViewController:(BOOL)pop;

- (void)useNavigationControllerInfo;

@end
