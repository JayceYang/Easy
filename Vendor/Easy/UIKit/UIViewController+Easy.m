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
#import "Macro.h"

static char HasPerformedOnceHandlerKey;
static char LeftButtonActionHandlerKey;
static char RightButtonActionHandlerKey;

@interface UIViewController ()

@property (copy, nonatomic) void (^leftButtonActionHandler)(void);
@property (copy, nonatomic) void (^rightButtonActionHandler)(void);

@property (nonatomic) BOOL hasPerformedOnceHandler;

@end

@implementation UIViewController (Easy)

- (void (^)(void))leftButtonActionHandler
{
    return objc_getAssociatedObject(self, &LeftButtonActionHandlerKey);
}

- (void)setLeftButtonActionHandler:(void (^)(void))leftButtonActionHandler
{
    [self willChangeValueForKey:@"leftButtonActionHandler"];
    objc_setAssociatedObject(self, &LeftButtonActionHandlerKey, leftButtonActionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"leftButtonActionHandler"];
}

- (void (^)(void))rightButtonActionHandler
{
    return objc_getAssociatedObject(self, &RightButtonActionHandlerKey);
}

- (void)setRightButtonActionHandler:(void (^)(void))rightButtonActionHandler
{
    [self willChangeValueForKey:@"rightButtonActionHandler"];
    objc_setAssociatedObject(self, &RightButtonActionHandlerKey, rightButtonActionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"rightButtonActionHandler"];
}

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

- (void)configureLeftButtonWithNormalImage:(UIImage *)noramlImage actionHandler:(void (^)(void))handler
{
    [self configureLeftButtonWithNormalImage:noramlImage highlightedImage:nil actionHandler:handler];
}

- (void)configureLeftButtonWithNormalImage:(UIImage *)noramlImage highlightedImage:(UIImage *)highlightedImage actionHandler:(void (^)(void))handler
{
    self.navigationItem.title = [NSString string];
    self.leftButtonActionHandler = handler;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, noramlImage.size.width, noramlImage.size.height);
    [button setImage:noramlImage forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(leftButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)leftButtonAction
{
    if (self.leftButtonActionHandler) {
        self.leftButtonActionHandler();
    }
}

- (void)configureRightButtonWithNormalImage:(UIImage *)noramlImage actionHandler:(void (^)(void))handler
{
    [self configureRightButtonWithNormalImage:noramlImage highlightedImage:nil actionHandler:handler];
}

- (void)configureRightButtonWithNormalImage:(UIImage *)noramlImage highlightedImage:(UIImage *)highlightedImage actionHandler:(void (^)(void))handler
{
    self.rightButtonActionHandler = handler;
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.frame = CGRectMake(0, 0, noramlImage.size.width, noramlImage.size.height);
    [button setImage:noramlImage forState:UIControlStateNormal];
    if (highlightedImage) {
        [button setImage:highlightedImage forState:UIControlStateHighlighted];
    }
    [button addTarget:self action:@selector(rightButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
}

- (void)rightButtonAction
{
    if (self.rightButtonActionHandler) {
        self.rightButtonActionHandler();
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
            NSString *message = [NSString stringWithFormat:@"%@ %@", LocalizedString(@"Call", nil), number];
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:message message:nil delegate:nil cancelButtonTitle:LocalizedString(@"Cancel", nil) otherButtonTitles:LocalizedString(@"Confirm", nil), nil];
            [alert showWithCompletionHandler:^(UIAlertView *alertView, NSInteger buttonIndex) {
                if (buttonIndex != alert.cancelButtonIndex) {
                    [[UIApplication sharedApplication] openURL:URL];
                }
            }];
#endif
        }
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
    CGFloat statusBarHeight = CGRectGetHeight([[UIApplication sharedApplication] statusBarFrame]);
    CGFloat navigationBarHeight = self.navigationController.navigationBarHidden ? 0 : self.navigationController.navigationBar.bounds.size.height;
    result = statusBarHeight + navigationBarHeight;
    return result;
}

- (CGFloat)perferedHeight
{
    return (self.height - self.perferedY);
}

@end