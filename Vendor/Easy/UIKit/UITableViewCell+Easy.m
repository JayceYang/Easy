//
//  UITableViewCell+Easy.m
//  DJIStore
//
//  Created by Jayce Yang on 14-1-15.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <objc/runtime.h>

#import "UITableViewCell+Easy.h"

#import "UITableView+Easy.h"

static char TableViewCellTableViewKey;

//@interface UITableViewCell ()
//
//@end

@implementation UITableViewCell (Easy)

#pragma mark - TableView

- (UITableView *)tableView
{
    return objc_getAssociatedObject(self, &TableViewCellTableViewKey);
}

- (void)setTableView:(UITableView *)tableView
{
    [self willChangeValueForKey:@"tableView"];
    objc_setAssociatedObject(self, &TableViewCellTableViewKey, tableView, OBJC_ASSOCIATION_ASSIGN);
    [self didChangeValueForKey:@"tableView"];
}

#pragma mark - AttachmentBehaviorAnimator

- (void)addAttachmentBehaviorWithReferenceTableView:(UITableView *)tableView
{
    self.tableView = tableView;
    
    if (self.tableView.attachmentBehaviorAnimator == nil) {
        self.tableView.attachmentBehaviorAnimator = [[UIDynamicAnimator alloc] initWithReferenceView:self.tableView];
    }
    
//    UITableView *tableView = self.tableView;
    if ([tableView isKindOfClass:[UITableView class]]) {
        for (UIDynamicBehavior *dynamicBehavior in tableView.attachmentBehaviorAnimator.behaviors) {
            if ([dynamicBehavior isKindOfClass:[UIAttachmentBehavior class]]) {
                if ([[(UIAttachmentBehavior *)dynamicBehavior items] containsObject:self]){
                    [tableView.attachmentBehaviorAnimator removeBehavior:dynamicBehavior];
                }
            }
        }
        
        CGPoint anchorPoint = CGPointMake(CGRectGetMidX(self.frame), CGRectGetMidY(self.frame) + 2);
        UIAttachmentBehavior *attachmentBehavior = [[UIAttachmentBehavior alloc] initWithItem:self attachedToAnchor:anchorPoint];
        attachmentBehavior.length = 0;
        attachmentBehavior.damping = .5f;
        attachmentBehavior.frequency = .8f;
        [tableView.attachmentBehaviorAnimator addBehavior:attachmentBehavior];
    }
}

- (void)hideSeparator
{
    self.clipsToBounds = YES;
    self.separatorInset = UIEdgeInsetsMake(0, CGRectGetWidth(self.bounds), 0, 0);
}

@end
