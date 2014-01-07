//
//  UIWebView+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-12-18.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EasyWebViewProgressView : UIView

//@property (nonatomic) CGFloat progress;
//@property (nonatomic) UIView *progressBarView;
@property (nonatomic) NSTimeInterval barAnimationDuration; // default 0.1
@property (nonatomic) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

@interface UIWebView (Easy)

@property (readonly, strong, nonatomic) EasyWebViewProgressView *progressView;
@property (nonatomic) BOOL showsProgress;

- (void)addProgressUpdatingHandler:(void (^)(CGFloat progress))updatingHandler;
- (void)addProgressUpdatingHandler:(void (^)(CGFloat progress))updatingHandler webViewDelegate:(id <UIWebViewDelegate>)delegate;
- (void)removeProgressUpdatingObserver;
- (NSString *)title;

@end
