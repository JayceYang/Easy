//
//  UIImage+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import <objc/runtime.h>

#import "UIView+Easy.h"
#import "UIImage+Easy.h"
#import "NSObject+Easy.h"

static char EasyProgressHUDControllerKey;
static char UserInfoKey;
static char SubtitleNavigationItemKey;

@interface UIView ()

//@property (strong, nonatomic) EasyProgressHUDController *progressHUDController;
@property (strong, nonatomic) UINavigationItem *subtitleNavigationItem;

@end

@implementation UIView (Easy)

- (EasyProgressHUDController *)progressHUDController
{
    return objc_getAssociatedObject(self, &EasyProgressHUDControllerKey);
}

- (void)setProgressHUDController:(EasyProgressHUDController *)progressHUDController
{
    [self willChangeValueForKey:@"progressHUDController"];
    objc_setAssociatedObject(self, &EasyProgressHUDControllerKey, progressHUDController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"progressHUDController"];
}

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

- (UINavigationItem *)subtitleNavigationItem
{
    return objc_getAssociatedObject(self, &SubtitleNavigationItemKey);
}

- (void)setSubtitleNavigationItem:(UINavigationItem *)subtitleNavigationItem
{
    [self willChangeValueForKey:@"subtitleNavigationItem"];
    objc_setAssociatedObject(self, &SubtitleNavigationItemKey, subtitleNavigationItem, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"subtitleNavigationItem"];
}

- (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image
{
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:frame];
    imageView.image = image;
    return imageView;
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = 0;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    [button setImage:image forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
{
    return [self buttonWithFrame:frame target:target action:action title:title image:image imageIndentation:indentation navigated:NO];
}

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
                    navigated:(BOOL)navigated
{
    CGFloat navigationButtonMargin = 6;
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    //    button.backgroundColor = [UIColor purpleColor];
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    //    [[button titleLabel] setBackgroundColor:[UIColor orangeColor]];
    CGFloat width = image.size.width;
    CGFloat height = image.size.height;
    CGFloat top = (frame.size.height - height) * .5;
    CGFloat left = indentation;
    CGFloat bottom = top;
    CGFloat right = frame.size.width - left - width;
    [button setImageEdgeInsets:UIEdgeInsetsMake(top, left, bottom, right)];
    BOOL putTitleLeft = left > frame.size.width * .5 ? YES : NO;
    if (navigated) {
        CGFloat titleLeft = putTitleLeft ? frame.size.width - left - navigationButtonMargin : left + navigationButtonMargin;
        CGFloat titleRight = putTitleLeft ? frame.size.width - left : left;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, titleLeft, 0, titleRight)];
    } else {
        CGFloat titleIndentation = putTitleLeft ? frame.size.width - left : left;
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, titleIndentation, 0, putTitleLeft ? titleIndentation + width : titleIndentation - width)];
    }
    
    [button setImage:image forState:UIControlStateNormal];
    [button setTitle:title forState:UIControlStateNormal];
    return button;
}

- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        title:(NSString *)title
              backgroundImage:(UIImage *)image
{
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    if (CGRectEqualToRect(frame, CGRectZero)) {
        frame = CGRectMake(0, 0, image.size.width, image.size.height);
    }
    [button setFrame:frame];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    [[button titleLabel] setFont:[UIFont systemFontOfSize:kSystemFontSize]];
    [button setTitle:title forState:UIControlStateNormal];
    [button setBackgroundImage:image forState:UIControlStateNormal];
    return button;
}

- (UILabel *)labelWithFrame:(CGRect)frame 
                       text:(NSString *)text 
                  textColor:(UIColor *)color 
              textAlignment:(UITextAlignment)alignment 
                       font:(UIFont *)font
{
    UILabel *label = [[UILabel alloc] initWithFrame:frame];
    label.text = text;
    label.textColor = color;
    label.textAlignment = alignment;
    label.font = font;
    label.backgroundColor = [UIColor clearColor];
    return label;
}

- (UITextField *)textFieldWithFrame:(CGRect)frame
                        borderStyle:(UITextBorderStyle)style
                    backgroundColor:(UIColor *)backgroundColor
                               text:(NSString *)text 
                          textColor:(UIColor *)textColor 
                      textAlignment:(UITextAlignment)alignment 
                               font:(UIFont *)font;
{
    UITextField *textField = [[UITextField alloc] initWithFrame:frame];
    textField.borderStyle = style;
    textField.backgroundColor = backgroundColor;
    textField.text = text;
    textField.textColor = textColor;
    textField.textAlignment = alignment;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    textField.font = font;
    return textField;
}

- (UITextView *)textViewWithFrame:(CGRect)frame 
                  backgroundColor:(UIColor *)backgroundColor
                             text:(NSString *)text 
                        textColor:(UIColor *)textColor 
                    textAlignment:(UITextAlignment)alignment 
                             font:(UIFont *)font;
{
    UITextView *textView = [[UITextView alloc] initWithFrame:frame];
    textView.backgroundColor = backgroundColor;
    textView.text = text;
    textView.textColor = textColor;
    textView.textAlignment = alignment;
    textView.font = font;
    return textView;
}

- (UISearchBar *)searchBarWithFrame:(CGRect)frame 
                 clearBarBackground:(BOOL)clearBar 
                    clearButtonMode:(UITextFieldViewMode)mode
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
        }
    }
    return searchBar;
}

- (UISearchBar *)searchBarRoundedRectWithFrame:(CGRect)frame 
                            clearBarBackground:(BOOL)clearBar 
                               clearButtonMode:(UITextFieldViewMode)mode 
                      clearTextFieldBackground:(BOOL)clearTextField
{
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:frame];
    for (UIView *view in searchBar.subviews) {
        if (clearBar && [view isKindOfClass:NSClassFromString(@"UISearchBarBackground")]) {
            [view removeFromSuperview];
        } else if ([view isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)view;
            textField.clearButtonMode = mode;
            textField.borderStyle = UITextBorderStyleRoundedRect;
            if (clearTextField) {
                [[textField.subviews lastObject] removeFromSuperview];
            }
        }
    }
    return searchBar;
}

- (UITableView *)tableViewWithFrame:(CGRect)frame 
                              style:(UITableViewStyle)style 
                     backgroundView:(UIView *)backgroundView 
                         dataSource:(id<UITableViewDataSource>)dataSource 
                           delegate:(id<UITableViewDelegate>)delegate
{
    UITableView *tableView = [[UITableView alloc] initWithFrame:frame style:style];
    tableView.backgroundView = backgroundView;
    tableView.dataSource = dataSource;
    tableView.delegate = delegate;
    return tableView;
}

- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items 
                            segmentedControlStyle:(UISegmentedControlStyle)style 
                                        momentary:(BOOL)momentary
{
    UISegmentedControl *segmentedControl = [[UISegmentedControl alloc] initWithItems:items];
    segmentedControl.segmentedControlStyle = style;
    segmentedControl.momentary = momentary;
    return segmentedControl;
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

#pragma mark - Subtitle

- (UINavigationBar *)configureSubtitle:(NSString *)subtilte
{
    UINavigationBar *navigationBar = [[UINavigationBar alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth([UIScreen mainScreen].bounds), 44)];
    navigationBar.barStyle = UIBarStyleBlack;
    UINavigationItem *topItem = [[UINavigationItem alloc] initWithTitle:subtilte];
    navigationBar.items = [NSArray arrayWithObjects:topItem, nil];
    [self addSubview:navigationBar];
    
    self.subtitleNavigationItem = topItem;
    
    return navigationBar;
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
