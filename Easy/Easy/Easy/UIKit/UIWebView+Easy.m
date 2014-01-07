//
//  UIWebView+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-12-18.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "UIWebView+Easy.h"
#import "Macro.h"

#pragma mark - WebViewProgress

static NSString *completeRPCURL = @"webviewprogressproxy:///complete";
static const float initialProgressValue = 0.1;
static const float beforeInteractiveMaxProgressValue = 0.5;
static const float afterInteractiveMaxProgressValue = 0.9;

@interface WebViewProgress : NSObject <UIWebViewDelegate>

@property (weak, nonatomic) id <UIWebViewDelegate> delegate;
@property (weak, nonatomic) UIWebView *webView;
@property (copy, nonatomic) void (^progressUpdatingHandler)(CGFloat progress);
@property (readonly, nonatomic) CGFloat progress; // 0.0..1.0

@property (nonatomic) NSUInteger loadingCount;
@property (nonatomic) NSUInteger maxLoadCount;
@property (nonatomic) BOOL interactive;
@property (copy, nonatomic) NSURL *currentURL;

@end

@implementation WebViewProgress

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc
{
//    DLog();
}

#pragma mark - Private

- (void)startProgress
{
    if (self.progress < initialProgressValue) {
        [self setProgress:initialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = self.interactive ? afterInteractiveMaxProgressValue : beforeInteractiveMaxProgressValue;
    float remainPercent = (float)self.loadingCount / (float)self.maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        
        [self.webView.progressView setProgress:progress animated:YES];
        if (self.progressUpdatingHandler) {
            self.progressUpdatingHandler(progress);
        }
    }
}

- (void)reset
{
    self.maxLoadCount = 0;
    self.loadingCount = 0;
    self.interactive = NO;
    [self setProgress:0.0];
}

#pragma mark - UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    if ([request.URL.absoluteString isEqualToString:completeRPCURL]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL ret = YES;
    if ([self.delegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
        ret = [self.delegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }
    
    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];
    
    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation) {
        self.currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
        [self.delegate webViewDidStartLoad:webView];
    }
    
    self.loadingCount++;
    self.maxLoadCount = fmax(self.maxLoadCount, self.loadingCount);
    
    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self.delegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
        [self.delegate webViewDidFinishLoad:webView];
    }
    
    self.loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        self.interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = self.currentURL && [self.currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    if ([self.delegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
        [self.delegate webView:webView didFailLoadWithError:error];
    }
    
    self.loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        self.interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = self.currentURL && [self.currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

@end

#pragma mark - EasyWebViewProgressView

@interface EasyWebViewProgressView ()

@property (strong, nonatomic) UIView *progressBarView;

@end

@implementation EasyWebViewProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        
        self.progressBarView = [[UIView alloc] initWithFrame:self.bounds];
        self.progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        self.progressBarView.backgroundColor = [UIColor colorWithRed:22.f / 255.f green:126.f / 255.f blue:251.f / 255.f alpha:1.0]; // iOS7 Safari bar color
        [self addSubview:self.progressBarView];
        
        self.barAnimationDuration = 0.27f;
        self.fadeAnimationDuration = 0.27f;
        self.fadeOutDelay = 0.1f;
    }
    return self;
}

- (void)dealloc
{
//    DLog();
}

#pragma mark - Public

- (void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? self.barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = self.progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        self.progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? self.fadeAnimationDuration : 0.0 delay:self.fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = self.progressBarView.frame;
            frame.size.width = 0;
            self.progressBarView.frame = frame;
        }];
    } else {
        [UIView animateWithDuration:animated ? self.fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end

#pragma mark - UIWebView

@interface UIWebView ()

@property (strong, nonatomic) EasyWebViewProgressView *progressView;
@property (strong, nonatomic) WebViewProgress *webViewProgress;

@end

@implementation UIWebView (Easy)

const void *ProgressViewKey = "ProgressViewKey";
const void *WebViewProgressKey = "WebViewProgressKey";
const void *ShowsProgressKey = "ShowsProgressKey";

#pragma mark - Public

- (BOOL)showsProgress
{
    return [objc_getAssociatedObject(self, ShowsProgressKey) boolValue];
}

- (void)setShowsProgress:(BOOL)showsProgress
{
    [self willChangeValueForKey:@"showsProgress"];
    objc_setAssociatedObject(self, ShowsProgressKey, [NSNumber numberWithBool:showsProgress], OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"showsProgress"];
}

- (void)addProgressUpdatingHandler:(void (^)(CGFloat progress))updatingHandler
{
    [self addProgressUpdatingHandler:updatingHandler webViewDelegate:nil];
}

- (void)addProgressUpdatingHandler:(void (^)(CGFloat progress))updatingHandler webViewDelegate:(id <UIWebViewDelegate>)delegate
{
    if (self.showsProgress) {
        CGFloat progressBarHeight = 2.5f;
        EasyWebViewProgressView *progressView = [[EasyWebViewProgressView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.bounds), progressBarHeight)];
        progressView.autoresizingMask = UIViewAutoresizingFlexibleBottomMargin | UIViewAutoresizingFlexibleWidth;
        self.progressView = progressView;
        [self addSubview:progressView];
    } else {
        [self.progressView removeFromSuperview];
    }
    
    self.webViewProgress = [[WebViewProgress alloc] init];
    self.webViewProgress.progressUpdatingHandler = updatingHandler;
    self.webViewProgress.delegate = delegate;
    self.webViewProgress.webView = self;
    self.delegate = self.webViewProgress;
}

- (void)removeProgressUpdatingObserver
{
    self.delegate = nil;
    self.webViewProgress.delegate = nil;
    self.webViewProgress = nil;
}

- (NSString *)title
{
    return [self stringByEvaluatingJavaScriptFromString:@"document.title"];
}

#pragma mark - Private

- (EasyWebViewProgressView *)progressView
{
    return objc_getAssociatedObject(self, ProgressViewKey);
}

- (void)setProgressView:(EasyWebViewProgressView *)progressView
{
    [self willChangeValueForKey:@"progressView"];
    objc_setAssociatedObject(self, ProgressViewKey, progressView, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"progressView"];
}

- (WebViewProgress *)webViewProgress
{
    return objc_getAssociatedObject(self, WebViewProgressKey);
}

- (void)setWebViewProgress:(WebViewProgress *)webViewProgress
{
    [self willChangeValueForKey:@"webViewProgress"];
    objc_setAssociatedObject(self, WebViewProgressKey, webViewProgress, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"webViewProgress"];
}

@end