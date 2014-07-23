//
//  UITableView+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "UITableView+Easy.h"

static char TableViewAttachmentBehaviorAnimatorKey;

@interface UITableView ()

//@property (strong, nonatomic) UIDynamicAnimator *attachmentBehaviorAnimator;

@end

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

- (void)configureBackgroundWithImage:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    imageView.backgroundColor = self.backgroundColor;
    self.backgroundView = imageView;
}

#pragma mark - AttachmentBehaviorAnimator

- (UIDynamicAnimator *)attachmentBehaviorAnimator
{
    return objc_getAssociatedObject(self, &TableViewAttachmentBehaviorAnimatorKey);
}

- (void)setAttachmentBehaviorAnimator:(UIDynamicAnimator *)attachmentBehaviorAnimator
{
    [self willChangeValueForKey:@"attachmentBehaviorAnimator"];
    objc_setAssociatedObject(self, &TableViewAttachmentBehaviorAnimatorKey, attachmentBehaviorAnimator, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"attachmentBehaviorAnimator"];
}

- (void)addAttachmentBehavior
{
    if (self.attachmentBehaviorAnimator == nil) {
        self.attachmentBehaviorAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self];
    }
}

- (void)removeAttachmentBehavior
{
    [self.attachmentBehaviorAnimator removeAllBehaviors];
}

@end
