//
//  UINavigationItem+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-11-18.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <objc/runtime.h>
#import "UINavigationItem+Easy.h"

#import "NSObject+Easy.h"


static char ExtraTitleLabelKey;

@interface UINavigationItem ()

@property (strong, nonatomic) UILabel *extraTitleLabel;

@end

@implementation UINavigationItem (Easy)

#pragma mark - Extra Title

- (UILabel *)extraTitleLabel
{
    return objc_getAssociatedObject(self, &ExtraTitleLabelKey);
}

- (void)setExtraTitleLabel:(UILabel *)extraTitleLabel
{
    [self willChangeValueForKey:@"extraTitleLabel"];
    objc_setAssociatedObject(self, &ExtraTitleLabelKey, extraTitleLabel, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"extraTitleLabel"];
}

- (NSString *)extraTitle
{
    [self makeTitleLabelIfRequired];
    return self.extraTitleLabel.text;
}

- (void)setExtraTitle:(NSString *)extraTitle
{
    [self makeTitleLabelIfRequired];
    self.extraTitleLabel.text = extraTitle;
}

- (void)makeTitleLabelIfRequired
{
    if (self.extraTitleLabel == nil) {
        self.extraTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 200, 30)];
        self.extraTitleLabel.backgroundColor = [UIColor clearColor];
        self.extraTitleLabel.textAlignment = NSTextAlignmentCenter;
        self.extraTitleLabel.adjustsFontSizeToFitWidth = YES;
        self.extraTitleLabel.minimumScaleFactor = .7;
        self.extraTitleLabel.font = [UIFont systemFontOfSize:[UIFont labelFontSize]];
        self.extraTitleLabel.textColor = [UIColor whiteColor];
        [self setPreferedTitleView:self.extraTitleLabel];
//        self.titleView = self.extraTitleLabel;
    }
}

- (void)setPreferedTitleView:(UIView *)view
{
    [self setPreferedTitleView:view autoresizingMask:UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin];
}

- (void)setPreferedTitleView:(UIView *)view autoresizingMask:(UIViewAutoresizing)mask
{
    UINavigationBar *navigationBar = self.currentNavigationController.navigationBar;
    CGFloat width = CGRectGetWidth(navigationBar.bounds);
    CGFloat height = CGRectGetHeight(navigationBar.bounds);
    UIView *titleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, width, height)];
    titleView.backgroundColor = [UIColor clearColor];
    view.autoresizingMask = mask;
    view.center = CGPointMake(width / 2, height / 2);
    [titleView addSubview:view];
    self.titleView = titleView;
}

@end
