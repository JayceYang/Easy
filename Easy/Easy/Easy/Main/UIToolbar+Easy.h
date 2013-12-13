//
//  UIToolbar+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-8-29.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIToolbar (Easy)

- (void)setSeparatedByFlexibleSpaceItems:(NSArray *)items animated:(BOOL)animated;
- (void)setSeparatedByFlexibleSpaceViews:(NSArray *)views animated:(BOOL)animated;

@end
