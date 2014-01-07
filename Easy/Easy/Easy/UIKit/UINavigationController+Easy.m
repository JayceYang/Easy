//
//  UINavigationController+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/25/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "UINavigationController+Easy.h"
#import "Macro.h"

static char ViewControllerToPushSafeKey;
static char ViewControllerPushCompletionHandlerKey;
static char MenuViewControllerKey;
static char SplashImageViewKey;
static char PresentingModeKey;

@interface  NavigationControllerInfo: NSObject <UINavigationControllerDelegate>

+ (instancetype)sharedInfo;

@end

@implementation NavigationControllerInfo

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Public

+ (instancetype)sharedInfo
{
    static NavigationControllerInfo *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

#pragma mark - UINavigationControllerDelegate

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    navigationController.viewControllerToPush = nil;
    if (navigationController.viewControllerPushCompletionHandler) {
        navigationController.viewControllerPushCompletionHandler();
        navigationController.viewControllerPushCompletionHandler = nil;
    }
#ifdef DEBUG
    NSArray *viewControllers = [navigationController viewControllers];
    NSLog(@"viewControllers stack:\n");
    for (NSUInteger n = 0; n < viewControllers.count; n ++) {
        NSLog(@"%lu\t%@", (unsigned long)n, NSStringFromClass([[viewControllers objectAtIndex:n] class]));
    }
#endif
}

@end

@interface UINavigationController ()

//@property (copy, nonatomic) void (^viewControllerPushCompletionHandler)(void);
//@property (strong, nonatomic) UIViewController *viewControllerToPush;

@end

@implementation UINavigationController (Easy)

#pragma mark - UIViewControllerRotation

- (BOOL)shouldAutorotate
{
    if (self.presentingMode) {
        return self.presentedViewController.shouldAutorotate;
    } else {
        return self.topViewController.shouldAutorotate;
    }
//    return self.topViewController.shouldAutorotate;
}

- (NSUInteger)supportedInterfaceOrientations
{
    if (self.presentingMode) {
        return self.presentedViewController.supportedInterfaceOrientations;
    } else {
        return self.topViewController.supportedInterfaceOrientations;
    }
//    return self.topViewController.supportedInterfaceOrientations;
}

#pragma mark - Splash image view 

- (UIImageView *)splashImageView
{
    return objc_getAssociatedObject(self, &SplashImageViewKey);
}

- (void)setSplashImageView:(UIImageView *)splashImageView
{
    [self willChangeValueForKey:@"splashImageView"];
    objc_setAssociatedObject(self, &SplashImageViewKey, splashImageView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"splashImageView"];
}

- (UIViewController *)viewControllerToPush
{
    return objc_getAssociatedObject(self, &ViewControllerToPushSafeKey);
}

- (void)setViewControllerToPush:(UIViewController *)viewControllerToPush
{
    [self willChangeValueForKey:@"viewControllerToPush"];
    objc_setAssociatedObject(self, &ViewControllerToPushSafeKey, viewControllerToPush, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"viewControllerToPush"];
}

- (void (^)(void))viewControllerPushCompletionHandler
{
    return objc_getAssociatedObject(self, &ViewControllerPushCompletionHandlerKey);
}

- (void)setViewControllerPushCompletionHandler:(void (^)(void))viewControllerPushCompletionHandler
{
    [self willChangeValueForKey:@"viewControllerPushCompletionHandler"];
    objc_setAssociatedObject(self, &ViewControllerPushCompletionHandlerKey, viewControllerPushCompletionHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"viewControllerPushCompletionHandler"];
}

- (MenuViewController *)menuViewController
{
    return objc_getAssociatedObject(self, &MenuViewControllerKey);
}

- (void)setMenuViewController:(MenuViewController *)menuViewController
{
    [self willChangeValueForKey:@"menuViewController"];
    objc_setAssociatedObject(self, &MenuViewControllerKey, menuViewController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"menuViewController"];
}

- (BOOL)presentingMode
{
    NSNumber *value = objc_getAssociatedObject(self, &PresentingModeKey);
    if ([value isKindOfClass:[NSNumber class]]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (void)setPresentingMode:(BOOL)presentingMode
{
    [self willChangeValueForKey:@"presentingMode"];
    objc_setAssociatedObject(self, &PresentingModeKey, [NSNumber numberWithBool:presentingMode], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"presentingMode"];
}

+ (instancetype)navigationControllerWithRootViewControllerClass:(Class)rootViewControllerClass hasNib:(BOOL)hasNib
{
    UINavigationController *navigationController = nil;
    @try {
        UIViewController *rootViewController = nil;
        if (hasNib) {
            rootViewController = [[rootViewControllerClass alloc] initWithNibName:NSStringFromClass(rootViewControllerClass) bundle:nil];
        } else {
            rootViewController = [[rootViewControllerClass alloc] initWithNibName:nil bundle:nil];
        }
        navigationController = [[UINavigationController alloc] initWithRootViewController:rootViewController];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        return navigationController;
    }
}

- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllerToPush == nil) {
        self.viewControllerToPush = viewController;
//        DLog(@"%@", NSStringFromClass([viewController class]));
        [self pushViewController:viewController animated:animated];
    }
}

- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated completionHandler:(void (^)(void))completionHandler
{
    if (self.viewControllerToPush == nil) {
        self.viewControllerToPush = viewController;
        
        self.viewControllerPushCompletionHandler = completionHandler;
        [self pushViewController:viewController animated:animated];
    }
}

- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated popTopViewController:(BOOL)pop
{
    if (pop) {
        NSMutableArray *viewControllers = [NSMutableArray arrayWithArray:self.viewControllers];
        if (viewControllers.count > 0 && viewController) {
//            [self popViewControllerAnimated:NO];
//            [self pushViewController:viewController animated:animated];
            [viewControllers replaceObjectAtIndex:viewControllers.count - 1 withObject:viewController];
            [self setViewControllers:viewControllers animated:animated];
        }
    }
}

- (void)useNavigationControllerInfo
{
    self.delegate = [NavigationControllerInfo sharedInfo];
}

@end
