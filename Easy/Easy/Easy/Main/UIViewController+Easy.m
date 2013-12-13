//
//  UIViewController+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
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
#import "EasyProgressHUDController.h"

static char HasPerformedOnceHandlerKey;

@interface UIViewController ()

@property (copy, nonatomic) void (^preferredLanguageUpdatingCompletionHandler)(void);
@property (copy, nonatomic) void (^welcomeVideoRemovingCompletionHandler)(void);
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

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    return (toInterfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Navigation

- (void)back:(UIButton *)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)configureNavigationWithBackgroundImage:(UIImage *)image
{
//    PageType type = self.pageType;    
//    DLog(@"%@", NSStringFromCGSize(image.size));
    
    if (image) {
        CGSize size = self.navigationController.navigationBar.bounds.size;
        image = [image imageToFitSize:size];
        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        if ((NSInteger)image.size.height > (NSInteger)size.height) {
////            image = [image imageToFitSize:size];
//            //            DLog(@"%.0lf\t%.0lf", image.size.width, image.size.height);
//            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        } else {
//            [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//        }
        
    } else {
        //        DLog(@"top bar image is null");
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

#pragma mark - Loading

- (void)showLoading
{
    [self showLoadingWithStatus:NSLocalizedString(@"Loading", nil)];
}

- (void)showLoadingWithoutStatus
{
    [self showLoadingWithStatus:nil];
}

- (void)showLoadingWithStatus:(NSString *)status
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [EasyProgressHUDController showInView:self.view status:status];
    } else {
        [EasyProgressHUDController showInView:self.navigationController.view status:status];
    }
}

- (void)showLoadingForView:(UIView *)view
{
    [EasyProgressHUDController showInView:view status:NSLocalizedString(@"Loading", nil)];
}

- (void)showLoadingWithoutStatusForView:(UIView *)view
{
    [EasyProgressHUDController showInView:view status:nil];
}

- (void)showLoadingWithStatus:(NSString *)status forView:(UIView *)view
{
    [EasyProgressHUDController showInView:view status:status];
}

- (void)updateStatus:(NSString *)status
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [EasyProgressHUDController updateStatus:status forView:self.view];
    } else {
        [EasyProgressHUDController updateStatus:status forView:self.navigationController.view];
    }
}

- (void)dismissLoading
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [EasyProgressHUDController dismissFromView:self.view];
    } else {
        [EasyProgressHUDController dismissFromView:self.navigationController.view];
    }
}

- (void)showNoneStatusLoadingWithProgressHandler:(void (^)())progressHandler finishHandler:(void (^)())finishHandler
{
    [self showLoadingWithProgressHandler:progressHandler finishHandler:finishHandler text:nil];
}

- (void)showLoadingWithProgressHandler:(void (^)())progressHandler finishHandler:(void (^)())finishHandler
{
    [self showLoadingWithProgressHandler:progressHandler finishHandler:finishHandler text:NSLocalizedString(@"Loading", nil)];
}

- (void)showLoadingWithProgressHandler:(void (^)())progressHandler finishHandler:(void (^)())finishHandler text:(NSString *)text
{
    if ([self isKindOfClass:[UINavigationController class]]) {
        [EasyProgressHUDController showInView:self.view];
    } else {
        [EasyProgressHUDController showInView:self.navigationController.view];
    }
    
    if (progressHandler) {
        progressHandler();
    }
    
    if (finishHandler) {
        finishHandler();
    }
    
    if ([self isKindOfClass:[UINavigationController class]]) {
        [EasyProgressHUDController dismissFromView:self.view];
    } else {
        [EasyProgressHUDController dismissFromView:self.navigationController.view];
    }
}

#pragma mark - Dial

#ifndef kNoStayOnPhoneDialerWhenFinishingCall
//#define kNoStayOnPhoneDialerWhenFinishingCall
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

#pragma mark - Private

- (void)configureBackButtonWithImage:(UIImage *)image
{
    if (self.navigationController.viewControllers.count > 1) {
        // Enabling iOS 7 screen-edge-pan-gesture for pop action
        if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
            self.navigationController.interactivePopGestureRecognizer.delegate = nil;
        }
        
        UIView *customView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 60, 30)];
        customView.backgroundColor = [UIColor clearColor];
        [customView addTapGestureRecognizerWithTarget:self action:@selector(back:)];
        
        CGFloat width = (image.size.width > CGRectGetWidth(customView.bounds) ? CGRectGetWidth(customView.bounds) : image.size.width);
        CGFloat height = (image.size.height > CGRectGetHeight(customView.bounds) ? CGRectGetHeight(customView.bounds) : image.size.height);
        CGFloat x = 0;
        CGFloat y = (CGRectGetHeight(customView.bounds) - height) / 2.f;
        UIButton *button = [customView buttonWithFrame:CGRectMake(x, y, width, height) target:self action:@selector(back:) image:image];
        button.imageView.contentMode = UIViewContentModeScaleAspectFit;
        button.backgroundColor = [UIColor clearColor];
        [customView addSubview:button];
        self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:customView];
    } else {
        [self.navigationItem setHidesBackButton:YES animated:YES];
        self.navigationItem.leftBarButtonItem = nil;
    }
    
}

@end