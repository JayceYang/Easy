//
//  UIImage+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kButtonFontSize                     [UIFont buttonFontSize]         /* 18px */
#define kLabelFontSize                      [UIFont labelFontSize]          /* 17px */
#define kSystemFontSize                     [UIFont systemFontSize]         /* 14px */
#define kSmallSystemFontSize                [UIFont smallSystemFontSize]    /* 12px */

#define kButtonFont                         [UIFont systemFontOfSize:[UIFont buttonFontSize]]
#define kLabelFont                          [UIFont systemFontOfSize:[UIFont labelFontSize]]
#define kSystemFont                         [UIFont systemFontOfSize:[UIFont systemFontSize]]
#define kSmallSystemFont                    [UIFont systemFontOfSize:[UIFont smallSystemFontSize]]

#define RGBColor(r,g,b)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1.0]
#define RGBAColor(r,g,b,a)  [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]

@interface UIView (Easy)

@property (strong, nonatomic) id userInfo;

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
- (void)configureFrameByAppendingX:(CGFloat)appending;
- (void)configureFrameByAppendingY:(CGFloat)appending;
- (void)configureFrameByAppendingWidth:(CGFloat)appending;
- (void)configureFrameByAppendingHeight:(CGFloat)appending;

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius;
- (void)configureBackgroundWithImage:(UIImage *)image;
- (void)removeAllSubviews;

//Default is [UIFont labelFontSize] 17px, black background

- (void)configureGeneralAppearanceWhenFetchingNoData;

@end
