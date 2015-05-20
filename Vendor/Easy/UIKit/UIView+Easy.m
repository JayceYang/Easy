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

static char TapGestureHandlerKey;
static char KeyboardWillShowHandlerKey;
static char KeyboardWillHideHandlerKey;

static NSUInteger const UIViewBorderViewTagBase = 1000;

@interface UIView ()

@property (copy, nonatomic) void (^tapGestureHandler)(void);

@property (copy, nonatomic) void (^keyboardWillShowHandler)(void);
@property (copy, nonatomic) void (^keyboardWillHideHandler)(void);

@end

@implementation UIView (Easy)

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

- (void)configureFrameBySettingSize:(CGSize)size
{
    CGRect rect = self.frame;
    rect.size = size;
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

- (void)configureWithBorderPosition:(BorderPosition)position
{
//    switch (position) {
//        case BorderPositionTop:
//        {
//            
//        }
//            break;
//        case BorderPositionLeft:
//        {
//            
//        }
//            break;
//        case BorderPositionBottom:
//        {
//            
//        }
//            break;
//        case BorderPositionRight:
//        {
//            
//        }
//            break;
//        case BorderPositionTop & BorderPositionLeft:
//        {
//            
//        }
//            break;
//        case BorderPositionTop & BorderPositionBottom:
//        {
//            
//        }
//            break;
//        case BorderPositionTop | BorderPositionRight:
//        {
//            
//        }
//            break;
//        case BorderPositionLeft | BorderPositionBottom:
//        {
//            
//        }
//            break;
//        case BorderPositionLeft | BorderPositionRight:
//        {
//            
//        }
//            break;
//        case BorderPositionBottom | BorderPositionRight:
//        {
//            
//        }
//            break;
//        default:
//            break;
//    }
}

- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor {
    [self addOneRetinaPixelBorderWithBorderColor:borderColor borderWidth:1];
}

- (void)addOneRetinaPixelBorderWithBorderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth {
    self.layer.borderWidth = borderWidth * 1.0f / [[UIScreen mainScreen] scale];
    self.layer.borderColor = borderColor.CGColor;
}

- (void)removeOneRetinaPixelBorder {
    self.layer.borderWidth = 0;
    self.layer.borderColor = [UIColor clearColor].CGColor;
}

- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor
{
    [self addBorderWithBorderPosition:position borderColor:borderColor borderWidth:1 * 1.0f / [[UIScreen mainScreen] scale]];
}

- (void)addBorderWithBorderPosition:(BorderPosition)position borderColor:(UIColor *)borderColor borderWidth:(CGFloat)borderWidth
{
    CGFloat scale = [[UIScreen mainScreen] scale];
    if (borderWidth * scale < 1) {
        borderWidth = 1 * 1.0f / scale;
    }
    
    NSUInteger tag = [self tagForPosition:position];
    UIView *border = [self viewWithTag:tag];
    if (border == nil) {
        border = [[UIView alloc] initWithFrame:CGRectZero];
        border.tag = tag;
        [self addSubview:border];
    }
    border.backgroundColor = borderColor;
    border.translatesAutoresizingMaskIntoConstraints = NO;
    switch (position) {
        case BorderPositionTop:
        {
//            border.frame = CGRectMake(0, 0, CGRectGetWidth(self.bounds), borderWidth);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
            
        }
            break;
            
        case BorderPositionBottom:
        {
//            border.frame = CGRectMake(0, CGRectGetHeight(self.bounds) - borderWidth, CGRectGetWidth(self.bounds), borderWidth);
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        case BorderPositionLeft:
        {
//            border.frame = CGRectMake(0, 0, borderWidth, CGRectGetHeight(self.bounds));
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        case BorderPositionRight:
        {
//            border.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin;
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:border attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
            [self addConstraint:[NSLayoutConstraint constraintWithItem:border attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1 constant:borderWidth]];
        }
            break;
            
        default:
            
            break;
    }
}

- (void)removeBorderAtPosition:(BorderPosition)position
{
    NSUInteger tag = [self tagForPosition:position];
    [[self viewWithTag:tag] removeFromSuperview];
}

- (void)removeAllBorders
{
    [self removeBorderAtPosition:BorderPositionTop];
    [self removeBorderAtPosition:BorderPositionBottom];
    [self removeBorderAtPosition:BorderPositionLeft];
    [self removeBorderAtPosition:BorderPositionRight];
}

- (void)updateAllBorders
{
//    [self updateBorderAtPosition:BorderPositionTop];
//    [self updateBorderAtPosition:BorderPositionBottom];
//    [self updateBorderAtPosition:BorderPositionLeft];
//    [self updateBorderAtPosition:BorderPositionRight];
}

- (NSUInteger)tagForPosition:(BorderPosition)position
{
    NSUInteger tag = UIViewBorderViewTagBase;
    
    switch (position) {
        case BorderPositionTop:
            return tag + 1;
        case BorderPositionBottom:
            return tag + 2;
        case BorderPositionLeft:
            return tag + 3;
        case BorderPositionRight:
            return tag + 4;
        default:
            return tag;
            break;
    }
    
    NSAssert(NO, @"invalid position");
    return 0;
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

- (void)constrainEquallyToSuperview {
    
    NSDictionary *views = @{@"view": self};
    //        NSDictionary *metrics = @{@"margin":@(margin)};
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"|-0-[view]-0-|" options:0 metrics:nil views:views]];
    [self.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[view]-0-|" options:0 metrics:nil views:views]];
    
    //    UIView *view = self.superview;
    //    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    //    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    //    NSLayoutConstraint *width = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeWidth relatedBy:0 toItem:view attribute:NSLayoutAttributeWidth multiplier:1 constant:0];
    //    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeHeight relatedBy:0 toItem:view attribute:NSLayoutAttributeHeight multiplier:1 constant:0];
    //    NSArray *constraints = @[centerX, centerY, width, height];
    //    [view addConstraints:constraints];
}

- (NSArray *)constrainToSuperviewWithEdgeInsets:(UIEdgeInsets)insets {
    NSMutableArray *constraints = [@[] mutableCopy];
    NSDictionary *views = @{@"view": self};
    CGFloat top = insets.top;
    CGFloat left = insets.left;
    CGFloat bottom = insets.bottom;
    CGFloat right = insets.right;
    NSDictionary *metrics = @{@"top":@(top), @"left":@(left), @"bottom":@(bottom), @"right":@(right)};
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"|-left-[view]-right-|" options:0 metrics:metrics views:views]];
    [constraints addObjectsFromArray:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-top-[view]-bottom-|" options:0 metrics:metrics views:views]];
    [self.superview addConstraints:constraints];
    return constraints;
}

- (void)constrainCentrallyToSuperview {
    [self constrainCentrallyToView:self.superview];
}

- (void)constrainCentrallyToView:(UIView *)view {
    NSLayoutConstraint *centerX = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterX relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterX multiplier:1 constant:0];
    NSLayoutConstraint *centerY = [NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeCenterY relatedBy:0 toItem:view attribute:NSLayoutAttributeCenterY multiplier:1 constant:0];
    NSArray *constraints = @[centerX, centerY];
    [view addConstraints:constraints];
}

- (void)constrainCentrallyToView:(UIView *)view width:(CGFloat)width height:(CGFloat)height {
    NSDictionary *metrics = @{@"width": @(width), @"height": @(height)};
    NSDictionary *views = @{@"view": self};
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"[view(width)]" options:0 metrics:metrics views:views]];
    [view addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:[view(height)]" options:0 metrics:metrics views:views]];
    [self constrainCentrallyToView:view];
}

@end
