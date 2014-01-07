//
//  UIViewController+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+Easy.h"

#import "NSObject+Easy.h"
#import "UIView+Easy.h"
#import "UIImage+Easy.h"
#import "UINavigationController+Easy.h"
#import "NSArray+Easy.h"
#import "UIAlertView+Easy.h"
#import "Enum.h"
#import "Constants.h"
#import "Macro.h"

static char HasPerformedOnceHandlerKey;

@interface UIViewController ()

@property (nonatomic) BOOL hasPerformedOnceHandler;

@end

@implementation UIViewController (Easy)

- (BOOL)hasPerformedOnceHandler
{
    NSNumber *value = objc_getAssociatedObject(self, &HasPerformedOnceHandlerKey);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (void)setHasPerformedOnceHandler:(BOOL)hasPerformedOnceHandler
{
    [self willChangeValueForKey:@"hasPerformedOnceHandler"];
    objc_setAssociatedObject(self, &HasPerformedOnceHandlerKey, [NSNumber numberWithBool:hasPerformedOnceHandler], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"hasPerformedOnceHandler"];
}

- (id)initWithStandardNib
{
    return [self initWithNibName:NSStringFromClass([self class]) bundle:nil];
}

- (id)initWithNoneNib
{
    return [self initWithNibName:nil bundle:nil];
}

- (void)performOnceHandler:(void (^)(void))handler
{
    [self performOnceHandler:handler hasFiredHandler:nil];
}

- (void)performOnceHandler:(void (^)(void))handler hasFiredHandler:(void (^)(void))hasFiredHandler
{
    if (handler) {
        if (self.hasPerformedOnceHandler == NO) {
            self.hasPerformedOnceHandler = YES;
            handler();
        } else {
            //
            if (hasFiredHandler) {
                hasFiredHandler();
            }
        }
    }
}

#pragma mark - Background

- (void)configureEdgesForExtendedLayout
{
#ifdef __IPHONE_7_0
    if (systemVersionGreaterThanOrEqualTo(7)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
}

- (void)configureBackgroundForView:(UIView *)view image:(UIImage *)image
{
    UIImageView *imageView = nil;
    if ([view isKindOfClass:[UIImageView class]]) {
        imageView = (UIImageView *)view;
    } else if ([view isKindOfClass:[UITableView class]]) {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [UIColor clearColor];
        [(UITableView *)view setBackgroundView:imageView];
    } else {
        imageView = [[UIImageView alloc] initWithImage:image];
        imageView.backgroundColor = [UIColor clearColor];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        imageView.frame = view.bounds;
        [view addSubview:imageView];
        [view sendSubviewToBack:imageView];
    }
}

#pragma mark - Dial

#ifndef kNoStayOnPhoneDialerWhenFinishingCall
#define kNoStayOnPhoneDialerWhenFinishingCall
#endif

- (void)dialPhoneNumber:(NSString *)number
{
    if ([number isKindOfClass:[NSString class]] && number.length > 0) {
        NSString *phoneNumber = [NSString stringWithFormat:@"tel:%@",[number stringByReplacingOccurrencesOfString:@" " withString:[NSString string]]];
        NSURL *URL = [NSURL URLWithString:phoneNumber];
        if ([[UIApplication sharedApplication] canOpenURL:URL]) {
#ifdef kNoStayOnPhoneDialerWhenFinishingCall
            UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
            [webView loadRequest:[NSURLRequest requestWithURL:URL]];
            [self.view addSubview:webView];
#else
            NSString *message = [NSString stringWithFormat:@"%@ %@", NSLocalizedString(@"Call", nil), number];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"" message:message delegate:nil cancelButtonTitle:NSLocalizedString(@"Cancel", nil) otherButtonTitles:NSLocalizedString(@"Confirm", nil), nil];
            //        __weak typeof(self) target = self;
            [alert showWithHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != alert.cancelButtonIndex) {
                    [[UIApplication sharedApplication] openURL:URL];
                }
            }];
#endif
        }
    }
}

- (void)removeFromNavigationControllerAnimated:(BOOL)animated
{
    UINavigationController *navigationController = [[UIApplication sharedApplication] currentNavigationController];
    if ([navigationController isKindOfClass:[UINavigationController class]]) {
        NSMutableArray *allViewControllers = [NSMutableArray arrayWithArray:navigationController.viewControllers];
        for (UIViewController *viewController in allViewControllers) {
            if (viewController == self) {
                [allViewControllers removeObject:self];
                break;
            }
        }
        [navigationController setViewControllers:allViewControllers animated:animated];
    } else {
        DLog();
    }
}

- (CGFloat)width
{
    return CGRectGetWidth(self.view.bounds);
}

- (CGFloat)height
{
    return CGRectGetHeight(self.view.bounds);
}

- (CGFloat)perferedY
{
    CGFloat result = 0.f;
    if (systemVersionGreaterThanOrEqualTo(7)) {
        CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
        CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
        result = statusBarHeight + navigationBarHeight;
    }
    return result;
}

- (CGFloat)perferedHeight
{
    return (self.height - self.perferedY);
}

@end