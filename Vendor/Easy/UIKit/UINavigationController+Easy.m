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

@interface UINavigationController ()

@property (copy, nonatomic) void (^viewControllerPushCompletionHandler)(void);
@property (strong, nonatomic) UIViewController *viewControllerToPush;

@end

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

@implementation UINavigationController (Easy)

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

- (void)noneNestedPushViewController:(UIViewController *)viewController animated:(BOOL)animated
{
    if (self.viewControllerToPush == nil) {
        self.viewControllerToPush = viewController;
//        NSLog(@"%@", NSStringFromClass([viewController class]));
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
