//
//  UINavigationController+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 6/25/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MenuViewController;

@interface UINavigationController (Easy)

@property (strong, nonatomic) UIViewController *viewControllerToPush;
@property (copy, nonatomic) void (^viewControllerPushCompletionHandler)(void);
@property (strong, nonatomic) MenuViewController *menuViewController;
@property (strong, nonatomic) UIImageView *splashImageView;
@property (nonatomic) BOOL presentingMode;

+ (instancetype)navigationControllerWithRootViewControllerClass:(Class)rootViewControllerClass hasNib:(BOOL)hasNib;

- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated;
- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler;
- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated popTopViewController:(BOOL)pop;

- (void)useNavigationControllerInfo;

@end
