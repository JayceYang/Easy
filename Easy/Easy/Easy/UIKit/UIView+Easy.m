//
//  UIImage+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "UIView+Easy.h"
#import "UIImage+Easy.h"
#import "NSObject+Easy.h"

static char UserInfoKey;
static char TapGestureHandlerKey;
static char KeyboardWillShowHandlerKey;
static char KeyboardWillHideHandlerKey;

@interface UIView ()

@property (copy, nonatomic) void (^tapGestureHandler)(void);

@property (copy, nonatomic) void (^keyboardWillShowHandler)(void);
@property (copy, nonatomic) void (^keyboardWillHideHandler)(void);

@end

@implementation UIView (Easy)

- (id)userInfo
{
    return objc_getAssociatedObject(self, &UserInfoKey);
}

- (void)setUserInfo:(id)userInfo
{
    [self willChangeValueForKey:@"userInfo"];
    objc_setAssociatedObject(self, &UserInfoKey, userInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"userInfo"];
}

- (void (^)(void))tapGestureHandler
{
    return objc_getAssociatedObject(self, &TapGestureHandlerKey);
}

- (void)setTapGestureHandler:(void (^)(void))tapGestureHandler
{
    [self willChangeValueForKey:@"tapGestureHandler"];
    objc_setAssociatedObject(self, &TapGestureHandlerKey, tapGestureHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"tapGestureHandler"];
}

- (void (^)(void))keyboardWillShowHandler
{
    return objc_getAssociatedObject(self, &KeyboardWillShowHandlerKey);
}

- (void)setKeyboardWillShowHandler:(void (^)(void))keyboardWillShowHandler
{
    [self willChangeValueForKey:@"keyboardWillShowHandler"];
    objc_setAssociatedObject(self, &KeyboardWillShowHandlerKey, keyboardWillShowHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"keyboardWillShowHandler"];
}

- (void (^)(void))keyboardWillHideHandler
{
    return objc_getAssociatedObject(self, &KeyboardWillHideHandlerKey);
}

- (void)setKeyboardWillHideHandler:(void (^)(void))keyboardWillHideHandler
{
    [self willChangeValueForKey:@"keyboardWillHideHandler"];
    objc_setAssociatedObject(self, &KeyboardWillHideHandlerKey, keyboardWillHideHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"keyboardWillHideHandler"];
}

#pragma mark - TapGesture

- (UITapGestureRecognizer *)addTapGestureRecognizerWithHandler:(void (^)(void))handler
{
    return [self addTapGestureRecognizerWithHandler:handler delegate:nil];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithHandler:(void (^)(void))handler delegate:(id <UIGestureRecognizerDelegate>)delegate
{
    self.tapGestureHandler = handler;
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureAction:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = delegate;
    [self addGestureRecognizer:tapGestureRecognizer];
    return tapGestureRecognizer;
}

- (void)tapGestureAction:(UITapGestureRecognizer *)tapGestureRecognizer
{
    if (self.tapGestureHandler) {
        self.tapGestureHandler();
    }
}

#pragma mark - Keyboard

- (void)addObserverWithKeyboardWillShowHandler:(void (^)(void))showHandler keyboardWillHideHandler:(void (^)(void))hideHandler
{
    if (self.keyboardWillShowHandler == nil) {
        self.keyboardWillShowHandler = showHandler;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShowAction:) name:UIKeyboardWillShowNotification object:nil];
    }
    
    if (self.keyboardWillHideHandler == nil) {
        self.keyboardWillHideHandler = hideHandler;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHideAction:) name:UIKeyboardWillHideNotification object:nil];
    }
}

- (void)removeObserverForKeyboard
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
    self.keyboardWillShowHandler = nil;
    self.keyboardWillHideHandler = nil;
}

- (void)keyboardWillShowAction:(NSNotification *)notification
{
    if (self.keyboardWillShowHandler) {
        self.keyboardWillShowHandler();
    }
}

- (void)keyboardWillHideAction:(NSNotification *)notification
{
    if (self.keyboardWillHideHandler) {
        self.keyboardWillHideHandler();
    }
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:1 delegate:nil];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action delegate:(id <UIGestureRecognizerDelegate>)delegate
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:1 delegate:delegate];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired
{
    return [self addTapGestureRecognizerWithTarget:target action:action numberOfTapsRequired:numberOfTapsRequired delegate:nil];
}

- (UITapGestureRecognizer *)addTapGestureRecognizerWithTarget:(id)target action:(SEL)action numberOfTapsRequired:(NSUInteger)numberOfTapsRequired delegate:(id <UIGestureRecognizerDelegate>)delegate
{
    self.userInteractionEnabled = YES;
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:target action:action];
    tapGestureRecognizer.numberOfTapsRequired = numberOfTapsRequired;
    tapGestureRecognizer.delegate = delegate;
    [self addGestureRecognizer:tapGestureRecognizer];
    return tapGestureRecognizer;
}

- (void)configureFrameBySettingX:(CGFloat)setting
{
    CGRect rect = self.frame;
    rect.origin.x = setting;
    self.frame = rect;
}

- (void)configureFrameBySettingY:(CGFloat)setting
{
    CGRect rect = self.frame;
    rect.origin.y = setting;
    self.frame = rect;
}

- (void)configureFrameBySettingWidth:(CGFloat)setting
{
    CGRect rect = self.frame;
    rect.size.width = setting;
    self.frame = rect;
}

- (void)configureFrameBySettingHeight:(CGFloat)setting
{
    CGRect rect = self.frame;
    rect.size.height = setting;
    self.frame = rect;
}

- (void)configureFrameByAppendingX:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.origin.x += appending;
    self.frame = rect;
}

- (void)configureFrameByAppendingY:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.origin.y += appending;
    self.frame = rect;
}

- (void)configureFrameByAppendingWidth:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.size.width += appending;
    self.frame = rect;
}

- (void)configureFrameByAppendingHeight:(CGFloat)appending
{
    CGRect rect = self.frame;
    rect.size.height += appending;
    self.frame = rect;
}

- (void)configureWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    self.layer.borderColor = borderColor.CGColor;
    self.layer.borderWidth = borderWidth;
    self.layer.cornerRadius = cornerRadius;
}

- (void)configureBackgroundWithImage:(UIImage *)image
{
    if ([image isKindOfClass:[UIImage class]]) {
        self.layer.contents = (id)image.CGImage;
    }
}

- (void)removeAllSubviews
{
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[UIView class]]) {
            [view removeFromSuperview];
        }
    }
}

- (void)configureGeneralAppearanceWhenFetchingNoData
{
    self.layer.borderWidth = 1;
    self.layer.cornerRadius = 5.0;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [[UIColor colorWithRed:204/255.0 green:204/255.0 blue:204/255.0 alpha:1] CGColor];
    if ([self isKindOfClass:[UIButton class]]) {
        [(UIButton *)self setBackgroundImage:[UIImage imageFromColor:[UIColor grayColor]] forState:UIControlStateNormal];
    }
}

@end
