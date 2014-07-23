//
//  UIViewController+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Easy)

- (id)initWithStandardNib;
- (id)initWithNoneNib;

/*
 When view did appear firstly fire
 */
- (void)performOnceHandler:(void (^)(void))handler;
- (void)performOnceHandler:(void (^)(void))handler hasFiredHandler:(void (^)(void))hasFiredHandler;

- (void)removeFromNavigationControllerAnimated:(BOOL)animated;

- (void)configureEdgesForExtendedLayout;
- (void)configureBackgroundColor;
- (void)configureBackgroundForView:(UIView *)view image:(UIImage *)image;

- (void)configureBackButton;
- (void)configureBackButtonWithActionHandler:(void (^)(void))handler;
- (void)configureLeftButtonWithActionHandler:(void (^)(void))handler;
- (void)configureLeftButtonWithNormalImage:(UIImage *)noramlImage actionHandler:(void (^)(void))handler;
- (void)configureLeftButtonWithNormalImage:(UIImage *)noramlImage highlightedImage:(UIImage *)highlightedImage actionHandler:(void (^)(void))handler;

- (void)configureRightButtonWithNormalImage:(UIImage *)noramlImage actionHandler:(void (^)(void))handler;
- (void)configureRightButtonWithNormalImage:(UIImage *)noramlImage highlightedImage:(UIImage *)highlightedImage actionHandler:(void (^)(void))handler;

- (void)dialPhoneNumber:(NSString *)number;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)perferedY;
- (CGFloat)perferedHeight;

@end