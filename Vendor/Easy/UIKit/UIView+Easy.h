//
//  UIImage+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ButtonFontSize                     [UIFont buttonFontSize]         /* 18px */
#define LabelFontSize                      [UIFont labelFontSize]          /* 17px */
#define SystemFontSize                     [UIFont systemFontSize]         /* 14px */
#define SmallSystemFontSize                [UIFont smallSystemFontSize]    /* 12px */

#define ButtonFont                         [UIFont systemFontOfSize:[UIFont buttonFontSize]]
#define LabelFont                          [UIFont systemFontOfSize:[UIFont labelFontSize]]
#define SystemFont                         [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define SmallSystemFont                    [UIFont systemFontOfSize:[UIFont smallSystemFontSize]]
#define SystemFontOfSize(fontSize)         [UIFont systemFontOfSize:fontSize]

#define BoldButtonFont                         [UIFont boldSystemFontOfSize:[UIFont buttonFontSize]]
#define BoldLabelFont                          [UIFont boldSystemFontOfSize:[UIFont labelFontSize]]
#define BoldSystemFont                         [UIFont boldSystemFontOfSize:[UIFont systemFontSize]]
#define BoldSmallSystemFont                    [UIFont boldSystemFontOfSize:[UIFont smallSystemFontSize]]
#define BoldSystemFontOfSize(fontSize)         [UIFont boldSystemFontOfSize:fontSize]

#define RGBColor(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

typedef NS_OPTIONS(NSUInteger, BorderPosition) {
    BorderPositionNone          = 0,
    BorderPositionTop           = 1,
    BorderPositionBottom        = 2,
    BorderPositionLeft          = 3,
    BorderPositionRight         = 4,
};

@interface UIView (Easy)

- (UITapGestureRecognizer *)addTapGestureRecognizerWithHandler:(void (^)(void))handler;
- (UITapGestureRecognizer *)addTapGestureRecognizerWithHandler:(void (^)(void))handler delegate:(id <UIGestureRecognizerDelegate>)delegate;

- (void)addObserverWithKeyboardWillShowHandler:(void (^)(void))showHandler keyboardWillHideHandler:(void (^)(void))hideHandler;
- (void)removeObserverForKeyboard;

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action;
- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action delegate:(id <UIGestureRecognizerDelegate>)delegate;
- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired;
- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired delegate:(id <UIGestureRecognizerDelegate>)delegate;

- (void)configureFrameBySettingX:(CGFloat)setting;
- (void)configureFrameBySettingY:(CGFloat)setting;
- (void)configureFrameBySettingWidth:(CGFloat)setting;
- (void)configureFrameBySettingHeight:(CGFloat)setting;
- (void)configureFrameBySettingSize:(CGSize)size;
- (void)configureFrameByAppendingX:(CGFloat)appending;
- (void)configureFrameByAppendingY:(CGFloat)appending;
- (void)configureFrameByAppendingWidth:(CGFloat)appending;
- (void)configureFrameByAppendingHeight:(CGFloat)appending;

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;

- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor;
- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth;
- (void)removeOneRetinaPixelBorder;
- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor;
- (void)removeBorderAtPosition:(BorderPosition)position;
- (void)removeAllBorders;
//- (void)updateBorderAtPosition:(BorderPosition)position;
- (void)updateAllBorders;

- (void)configureBackgroundWithImage:(UIImage *)image;
- (void)removeAllSubviews;

- (void)configureGeneralAppearanceWhenFetchingNoData;

- (void)constrainEquallyToSuperview;
- (NSArray *)constrainToSuperviewWithEdgeInsets:(UIEdgeInsets)insets;
- (void)constrainCentrallyToSuperview;
- (void)constrainCentrallyToView:(UIView *)view;
- (void)constrainCentrallyToView:(UIView *)view width:(CGFloat)width height:(CGFloat)height;

@end
