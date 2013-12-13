//
//  PopoverViewController.h
//  iGuest
//
//  Created by Jayce Yang on 8/23/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PopoverViewController : UIViewController

- (id)initWithContentViewController:(UIViewController *)viewController;

- (void)presentPopoverAtPoint:(CGPoint)point inView:(UIView *)view;

- (void)dismiss;
- (void)dismiss:(BOOL)animated;

/*
 This method animates the rotation of the PopoverView to a new point
 */

- (void)animateRotationToNewPoint:(CGPoint)point inView:(UIView *)view withDuration:(NSTimeInterval)duration;

@end
