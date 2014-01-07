//
//  UIToolbar+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-8-29.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "UIToolbar+Easy.h"

@implementation UIToolbar (Easy)

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
