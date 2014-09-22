//
//  UIToolbar+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-8-29.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "UIToolbar+Easy.h"

static char ToolbarCancelHandler;
static char ToolbarDoneHandler;
static char ToolbarPreviousHandler;
static char ToolbarNextHandler;

@implementation UIToolbar (Easy)

- (void (^)(void))cancelHandler
{
    return objc_getAssociatedObject(self, &ToolbarCancelHandler);
}

- (void)setCancelHandler:(void (^)(void))cancelHandler
{
    [self willChangeValueForKey:@"cancelHandler"];
    objc_setAssociatedObject(self, &ToolbarCancelHandler, cancelHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"cancelHandler"];
}

- (void (^)(void))doneHandler
{
    return objc_getAssociatedObject(self, &ToolbarDoneHandler);
}

- (void)setDoneHandler:(void (^)(void))doneHandler
{
    [self willChangeValueForKey:@"doneHandler"];
    objc_setAssociatedObject(self, &ToolbarDoneHandler, doneHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"doneHandler"];
}

- (void (^)(void))previousHandler
{
    return objc_getAssociatedObject(self, &ToolbarPreviousHandler);
}

- (void)setPreviousHandler:(void (^)(void))previousHandler
{
    [self willChangeValueForKey:@"previousHandler"];
    objc_setAssociatedObject(self, &ToolbarPreviousHandler, previousHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"previousHandler"];
}

- (void (^)(void))nextHandler
{
    return objc_getAssociatedObject(self, &ToolbarNextHandler);
}

- (void)setNextHandler:(void (^)(void))nextHandler
{
    [self willChangeValueForKey:@"nextHandler"];
    objc_setAssociatedObject(self, &ToolbarNextHandler, nextHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"nextHandler"];
}

+ (instancetype)toolbarWithInputAccessoryViewType:(InputAccessoryViewType)type
{
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
//    toolbar.barStyle = UIBarStyleBlack;
    toolbar.translucent = YES;
    
    
    switch (type) {
        case InputAccessoryViewTypeCancelDone:
        {
            UIBarButtonItem *cancelBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", nil) style:UIBarButtonItemStyleBordered target:toolbar action:@selector(cancel)];
            UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:toolbar action:@selector(done)];
            UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            toolbar.items = [NSArray arrayWithObjects:cancelBarButtonItem, spaceBarButtonItem, doneBarButtonItem, nil];
        }
            break;
        case InputAccessoryViewTypePreviousNextDone:
        {
            UIBarButtonItem *previousBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Previous", nil) style:UIBarButtonItemStyleBordered target:toolbar action:@selector(previous)];
            UIBarButtonItem *nextBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Next", nil) style:UIBarButtonItemStyleBordered target:toolbar action:@selector(next)];
            UIBarButtonItem *doneBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Done", nil) style:UIBarButtonItemStyleBordered target:toolbar action:@selector(done)];
            UIBarButtonItem *spaceBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
            toolbar.items = [NSArray arrayWithObjects:previousBarButtonItem, nextBarButtonItem, spaceBarButtonItem, doneBarButtonItem, nil];
        }
            break;
        default:
            break;
    }
    
    return toolbar;
}

- (void)cancel
{
    if (self.cancelHandler) {
        self.cancelHandler();
    }
}

- (void)done
{
    if (self.doneHandler) {
        self.doneHandler();
    }
}

- (void)previous
{
    if (self.previousHandler) {
        self.previousHandler();
    }
}

- (void)next
{
    if (self.nextHandler) {
        self.nextHandler();
    }
}

- (void)setSeparatedByFlexibleSpaceItems:(NSArray *)items animated:(BOOL)animated
{
    [self setSeparatedByItems:items animated:animated];
}

- (void)setSeparatedByFlexibleSpaceViews:(NSArray *)views animated:(BOOL)animated
{
    [self setSeparatedBySpaceViews:views animated:animated];
}

#pragma mark - Private

- (void)setSeparatedByItems:(NSArray *)items animated:(BOOL)animated
{
    if ([items isKindOfClass:[NSArray class]]) {
        if (items.count > 0) {
            NSMutableArray *allItems = [NSMutableArray array];
            NSUInteger count = items.count;
            
            for (NSUInteger n = 0; n < count; n ++) {
                UIBarButtonItem *barButtonItem = [items objectAtIndex:n];
                if ([barButtonItem isKindOfClass:[UIBarButtonItem class]]) {
                    [allItems addObject:barButtonItem];
                    if (n != count - 1) {
                        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:NULL];
                        [allItems addObject:flexibleSpace];
                    }
                }
            }
            
            [self setItems:allItems animated:animated];
        }
    }
}

- (void)setSeparatedBySpaceViews:(NSArray *)views animated:(BOOL)animated
{
    if ([views isKindOfClass:[NSArray class]]) {
        if (views.count > 0) {
            NSMutableArray *items = [NSMutableArray array];
            for (UIView *view in views) {
                if ([view isKindOfClass:[UIView class]]) {
                    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:view];
                    [items addObject:barButtonItem];
                } else if ([view isKindOfClass:[UIBarButtonItem class]]) {
                    [items addObject:view];
                }
            }
            
            [self setSeparatedByItems:items animated:animated];
        }
    }
}

@end
