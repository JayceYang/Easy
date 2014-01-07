//
//  UIToolbar+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-8-29.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Easy)

- (void)setSeparatedByFlexibleSpaceItems:(NSArray *)items animated:(BOOL)animated;
- (void)setSeparatedByFlexibleSpaceViews:(NSArray *)views animated:(BOOL)animated;

@end
