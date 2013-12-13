//
//  UIImage+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
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

static CGFloat const kDefaultSubtileViewHeight = 45;

@class EasyProgressHUDController;

@interface UIView (Easy)

@property (strong, nonatomic) EasyProgressHUDController *progressHUDController;
@property (strong, nonatomic) id userInfo;
@property (readonly, strong, nonatomic) UINavigationItem *subtitleNavigationItem;

- (UIImageView *)imageViewWithFrame:(CGRect)frame image:(UIImage *)image;            

/* if the frame is CGRectZero, the button will use the image's size as its size and CGPointZero as its origin */
- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        image:(UIImage *)image;  

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image;

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation;

- (UIButton *)buttonWithFrame:(CGRect)frame
                       target:(id)target
                       action:(SEL)action
                        title:(NSString *)title
                        image:(UIImage *)image
             imageIndentation:(CGFloat)indentation
                    navigated:(BOOL)navigated;

/* if the frame is CGRectZero, the button will use the image's size as its size and CGPointZero as its origin */
- (UIButton *)buttonWithFrame:(CGRect)frame 
                       target:(id)target 
                       action:(SEL)action 
                        title:(NSString *)title
              backgroundImage:(UIImage *)image;

/* default background color is clear color */
- (UILabel *)labelWithFrame:(CGRect)frame 
                       text:(NSString *)text 
                  textColor:(UIColor *)color 
              textAlignment:(UITextAlignment)alignment 
                       font:(UIFont *)font; 

- (UITextField *)textFieldWithFrame:(CGRect)frame 
                        borderStyle:(UITextBorderStyle)style 
                    backgroundColor:(UIColor *)backgroundColor 
                               text:(NSString *)text 
                          textColor:(UIColor *)textColor 
                      textAlignment:(UITextAlignment)alignment 
                               font:(UIFont *)font;

- (UITextView *)textViewWithFrame:(CGRect)frame 
                  backgroundColor:(UIColor *)backgroundColor
                             text:(NSString *)text 
                        textColor:(UIColor *)textColor 
                    textAlignment:(UITextAlignment)alignment 
                             font:(UIFont *)font;

- (UISearchBar *)searchBarWithFrame:(CGRect)frame 
                 clearBarBackground:(BOOL)clearBar 
                    clearButtonMode:(UITextFieldViewMode)mode;

- (UISearchBar *)searchBarRoundedRectWithFrame:(CGRect)frame 
                            clearBarBackground:(BOOL)clearBar 
                               clearButtonMode:(UITextFieldViewMode)mode 
                      clearTextFieldBackground:(BOOL)clearTextField;

- (UITableView *)tableViewWithFrame:(CGRect)frame 
                              style:(UITableViewStyle)style 
                     backgroundView:(UIView *)backgroundView 
                         dataSource:(id<UITableViewDataSource>)dataSource 
                           delegate:(id<UITableViewDelegate>)delegate;

- (UISegmentedControl *)segmentedControlWithItems:(NSArray *)items 
                            segmentedControlStyle:(UISegmentedControlStyle)style 
                                        momentary:(BOOL)momentary;

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

- (UINavigationBar *)configureSubtitle:(NSString *)subtilte;

- (void)configureGeneralAppearanceWhenFetchingNoData;

@end
