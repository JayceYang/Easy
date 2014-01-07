//
//  UITableView+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import "UITableView+Easy.h"

@implementation UITableView (Easy)

- (void)scrollToBottom
{
    CGFloat result = self.contentSize.height - self.frame.size.height;
    if (result > 0) {
        CGPoint offset = CGPointMake(0, result);
        [self setContentOffset:offset animated:YES];
    }
}

- (void)hideEmptyCells
{
    self.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)reloadDataWithCompletion:(void(^)(void))completionBlock
{
    [self reloadData];
    if (completionBlock) {
        completionBlock();
    }
}

- (void)configureBackgroundColorWithColor:(UIColor *)color
{
    self.backgroundColor = color;
    UIView *view = [[UIView alloc] initWithFrame:CGRectZero];
    view.backgroundColor = self.backgroundColor;
    self.backgroundView = view;
}

@end
