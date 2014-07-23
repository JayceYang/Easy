//
//  UITableView+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableView (Easy)

@property (strong, nonatomic) UIDynamicAnimator *attachmentBehaviorAnimator;

- (void)scrollToBottom;
- (void)hideEmptyCells;
- (void)reloadDataWithCompletion:(void(^)(void))completionBlock;
- (void)configureBackgroundColorWithColor:(UIColor *)color;
- (void)configureBackgroundWithImage:(UIImage *)image;

//- (void)addAttachmentBehavior;
//- (void)removeAttachmentBehavior;

@end
