//
//  UIViewController+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
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

/* 
 Default is [self.navigationController popViewControllerAnimated:YES];
 Overwrite if needed.
 */
- (void)back:(UIButton *)sender;

- (void)configureNavigationWithBackgroundImage:(UIImage *)image;

- (void)configureEdgesForExtendedLayout;
- (void)configureBackgroundForView:(UIView *)view image:(UIImage *)image;

- (void)showLoading;
- (void)showLoadingWithoutStatus;
- (void)showLoadingWithStatus:(NSString *)status;
- (void)showLoadingForView:(UIView *)view;
- (void)showLoadingWithoutStatusForView:(UIView *)view;
- (void)showLoadingWithStatus:(NSString *)status forView:(UIView *)view;
- (void)updateStatus:(NSString *)status;
- (void)dismissLoading;

- (void)dialPhoneNumber:(NSString *)number;

- (CGFloat)width;
- (CGFloat)height;
- (CGFloat)perferedY;
- (CGFloat)perferedHeight;

@end