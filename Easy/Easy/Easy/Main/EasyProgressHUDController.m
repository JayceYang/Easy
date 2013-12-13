//
//  EasyProgressHUDController.m
//  Easy
//
//  Created by Jayce Yang on 13-9-27.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "Macro.h"

#pragma mark - Window

@interface EasyProgressHUDWindow : UIWindow

/** The window that was key at presentation time. Used to grab the view controller associated with the key window for rotation callbacks if they are available. */
@property (nonatomic, strong) UIWindow *oldWindow;

@end

@implementation EasyProgressHUDWindow

- (id)init
{
    self = [super initWithFrame:[UIScreen mainScreen].bounds];
    if (self) {
        // Initialization code
        
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor clearColor];
        self.userInteractionEnabled = NO;
    }
    return self;
}

- (void)dealloc
{
    //    DLog();
}

//- (void)setRootViewController:(UIViewController *)rootViewController
//{
//    [super setRootViewController:rootViewController];
//    
//    [self orientRootViewControllerForOrientation:rootViewController.interfaceOrientation];
//}

- (UIWindow *)oldWindow
{
    if (_oldWindow == nil) {
        UIResponder <UIApplicationDelegate> *applicationDelegate = [[UIApplication sharedApplication] delegate];
        UIWindow *keyWindow = [[UIApplication sharedApplication] keyWindow];
        if (keyWindow != nil) {
            self.oldWindow = keyWindow;
        } else if([applicationDelegate respondsToSelector:@selector(window)]) {
            UIWindow *delegateWindow = applicationDelegate.window;
            self.oldWindow = delegateWindow;
        } else {
            self.oldWindow = nil;
        }
    }
    
//    DLog(@"%@", _oldWindow);
    
    return _oldWindow;
}

- (void)orientRootViewControllerForOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    CGAffineTransform transform;
    
    switch (interfaceOrientation) {
        case UIInterfaceOrientationLandscapeRight:
            transform = CGAffineTransformMakeRotation(M_PI_2);
            break;
        case UIInterfaceOrientationLandscapeLeft:
            transform = CGAffineTransformMakeRotation(- M_PI_2);
            break;
        case UIInterfaceOrientationPortraitUpsideDown:
            transform = CGAffineTransformMakeRotation(M_PI);
            break;
        default:
        case UIInterfaceOrientationPortrait:
            transform = CGAffineTransformIdentity;
            break;
    }
    
    self.rootViewController.view.transform = transform;
}

@end

#import <QuartzCore/QuartzCore.h>

#import "EasyProgressHUDController.h"

#import "NSObject+Easy.h"
#import "UIView+Easy.h"

#pragma mark - OverlayView

CGFloat const MMProgressHUDStandardDismissDelay = 0.75f;

typedef NS_ENUM(NSInteger, MMProgressHUDWindowOverlayMode){
    MMProgressHUDWindowOverlayModeNone = -1,
    MMProgressHUDWindowOverlayModeGradient = 0,
    MMProgressHUDWindowOverlayModeLinear,
};

@interface EasyProgressHUDOverlayView : UIView

/** The style of the overlay. */
@property (nonatomic) MMProgressHUDWindowOverlayMode overlayMode;

/** The color for the overlay. This color will be used in both the linear and gradient overlay modes. */
@property (nonatomic) CGColorRef overlayColor;

@property (nonatomic) CGGradientRef gradientRef;

/** Init a new overlay view with the specified frame and overlayMode.
 
 @param frame The frame of the overlayView.
 @param overlayMode The style of the overlay.
 */
- (id)initWithFrame:(CGRect)frame overlayMode:(MMProgressHUDWindowOverlayMode)overlayMode;

@end

@implementation EasyProgressHUDOverlayView

- (id)initWithFrame:(CGRect)frame
{
    self = [self initWithFrame:frame overlayMode:MMProgressHUDWindowOverlayModeGradient];
    if (self) {
        // Initialization code
        
        
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame overlayMode:(MMProgressHUDWindowOverlayMode)overlayMode
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _overlayMode = overlayMode;
        
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGFloat r = 0/255.0;
        CGFloat g = 0/255.0;
        CGFloat b = 0/255.0;
        CGFloat a = 0/255.0;
        CGFloat components[4] = {r,g,b,a};
        
        _overlayColor = CGColorCreate(colorSpace, components);
        CGColorSpaceRelease(colorSpace);
        
        self.opaque = NO;
        
        [self _buildGradient];
    }
    return self;
}

- (void)dealloc
{
//    DLog();
    
    CGGradientRelease(_gradientRef);
    CGColorRelease(_overlayColor);
}

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    switch (self.overlayMode) {
        case MMProgressHUDWindowOverlayModeGradient:
            [self _drawRadialGradientInRect:rect];
            break;
            /*case MMProgressHUDWindowOverlayModeBlur:
             //            NSAssert(NO, @"Blur overlay not yet implemented!");
             break;*/
        case MMProgressHUDWindowOverlayModeNone:
            //draw nothing
            break;
        case MMProgressHUDWindowOverlayModeLinear:{
            [self _drawLinearOverlayInRect:rect];
        }
            break;
    }
}

- (void)_buildGradient
{
    if (_gradientRef) {
        CGGradientRelease(_gradientRef);
    }
    
    NSAssert(self.overlayColor, @"Overlay color is nil!");
    
    CGColorRef firstColor = CGColorCreateCopyWithAlpha(self.overlayColor, 0.f);
    CGColorRef secondColor = CGColorCreateCopyWithAlpha(self.overlayColor, 0.4f);
    CGColorRef thirdColor = CGColorCreateCopyWithAlpha(self.overlayColor, 0.5f);
    
    CGColorSpaceRef rgb = CGColorSpaceCreateDeviceRGB();
    CGColorRef colorsArray[] = {
        firstColor,
        secondColor,
        thirdColor
    };
    
    CFArrayRef colors = CFArrayCreate(NULL,
                                      (const void**)colorsArray,
                                      sizeof(colorsArray)/sizeof(CGColorRef),
                                      &kCFTypeArrayCallBacks);
    
    CGFloat locationList[] = {0.0,0.5,1.0};
    
    _gradientRef = CGGradientCreateWithColors(rgb, colors, locationList);
    
    CGColorRelease(firstColor);
    CGColorRelease(secondColor);
    CGColorRelease(thirdColor);
    
    CFRelease(colors);
    
    CGColorSpaceRelease(rgb);
}

- (void)_drawRadialGradientInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    CGPoint center = CGPointMake(CGRectGetMidX(rect), CGRectGetMidY(rect));
    
    float startRadius = 50.0f;
    float endRadius = rect.size.height*0.66f;
    
    NSAssert(self.gradientRef != nil, @"Gradient is nil!");
    
    CGContextDrawRadialGradient(context,
                                self.gradientRef,
                                center,
                                startRadius,
                                center,
                                endRadius,
                                kCGGradientDrawsBeforeStartLocation |
                                kCGGradientDrawsAfterEndLocation);
    
    CGContextRestoreGState(context);
}

- (void)_drawLinearOverlayInRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSaveGState(context);
    
    //create copy of overlay color
    CGColorRef linearColor = CGColorCreateCopyWithAlpha(self.overlayColor, 0.3f);
    
    CGContextSetFillColorWithColor(context, linearColor);
    CGContextFillRect(context, rect);
    
    CGColorRelease(linearColor);
    
    CGContextRestoreGState(context);
}

- (void)setOverlayMode:(MMProgressHUDWindowOverlayMode)overlayMode
{
    if (_overlayMode != overlayMode) {
        _overlayMode = overlayMode;
    }
    
    [self setNeedsDisplay];
}

- (void)setOverlayColor:(CGColorRef)overlayColor
{
    CGColorRelease(_overlayColor);
    _overlayColor = CGColorCreateCopy(overlayColor);
    
    [self _buildGradient];
    [self setNeedsDisplay];
}

@end

#pragma mark - ContentViewController

@interface EasyProgressHUDContentViewController : UIViewController

//@property (weak, nonatomic) UIWindow *window;
@property (strong, nonatomic) EasyProgressHUDOverlayView *overlayView;
@property (strong, nonatomic) UIView *containerView;
@property (strong, nonatomic) UIView *backgroundView;
@property (strong, nonatomic) UILabel *statusLabel;
@property (strong, nonatomic) UIActivityIndicatorView *activityIndicatorView;

@end

@implementation EasyProgressHUDContentViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        
//        self.wantsFullScreenLayout = YES;
        
    }
    return self;
}

- (void)dealloc
{
//    DLog();
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
#ifdef __IPHONE_7_0
    if (systemVersionGreaterThanOrEqualTo(7)) {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
#endif
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    
    EasyProgressHUDOverlayView *overlayView = [[EasyProgressHUDOverlayView alloc] initWithFrame:self.view.bounds overlayMode:MMProgressHUDWindowOverlayModeGradient];
    overlayView.backgroundColor = [UIColor clearColor];
//    overlayView.alpha = .4;
//    overlayView.overlayColor = [UIColor redColor].CGColor;
    overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    [self.view insertSubview:overlayView atIndex:0];
    self.overlayView = overlayView;
    
    CGFloat width = 150;
    CGFloat height = 120;
    
    self.containerView = [[UIView alloc] initWithFrame:CGRectMake((CGRectGetWidth(self.view.bounds) - width) / 2.f, (CGRectGetHeight(self.view.bounds) - height) / 2.f, width, height)];
    _containerView.userInteractionEnabled = NO;
    _containerView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
    _containerView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:_containerView];
    
    self.backgroundView = [[UIView alloc] initWithFrame:_containerView.bounds];
    _backgroundView.autoresizingMask = _containerView.autoresizingMask;
    _backgroundView.backgroundColor = [UIColor blackColor];
    _backgroundView.alpha = .8;
    _backgroundView.layer.cornerRadius = 10;
//    _backgroundView.userInteractionEnabled = NO;
    [_containerView addSubview:_backgroundView];
    
    self.activityIndicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    _activityIndicatorView.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _activityIndicatorView.center = CGPointMake(CGRectGetMidX(_containerView.bounds), 20 + CGRectGetHeight(_activityIndicatorView.bounds) / 2);
    _activityIndicatorView.hidesWhenStopped = YES;
//    _activityIndicatorView.userInteractionEnabled = NO;
    [_containerView addSubview:_activityIndicatorView];
    
    [_activityIndicatorView startAnimating];
    
    self.statusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_activityIndicatorView.frame), CGRectGetWidth(_containerView.bounds), CGRectGetHeight(_containerView.bounds) - CGRectGetMaxY(_activityIndicatorView.frame))];
    _statusLabel.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    _statusLabel.backgroundColor = [UIColor clearColor];
    _statusLabel.textAlignment = UITextAlignmentCenter;
    _statusLabel.textColor = [UIColor whiteColor];
    _statusLabel.adjustsFontSizeToFitWidth = YES;
    _statusLabel.font = [UIFont boldSystemFontOfSize:[UIFont labelFontSize]];
    _statusLabel.minimumFontSize = [UIFont smallSystemFontSize];
    _statusLabel.text = NSLocalizedString(@"Loading...", nil);
    
    [_containerView addSubview:_statusLabel];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//#ifdef __IPHONE_7_0
//    [self setNeedsStatusBarAppearanceUpdate];
//#endif
    
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
//
//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

//- (BOOL)shouldAutorotate
//{
//    CGFloat width = 150;
//    CGFloat height = 120;
//    DLog(@"%@", NSStringFromCGRect(self.view.bounds));
//    self.containerView.frame = CGRectMake((CGRectGetWidth(self.view.bounds) - width) / 2.f, (CGRectGetHeight(self.view.bounds) - height) / 2.f, width, height);
//    
//    return YES;
//}
//
//- (NSUInteger)supportedInterfaceOrientations
//{
//    return UIInterfaceOrientationMaskAllButUpsideDown;
//}
//
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
//{
//    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

@end

#pragma mark - ViewController

@interface EasyProgressHUDViewController : UIViewController <UIGestureRecognizerDelegate>

//@property (weak, nonatomic) UIWindow *window;
@property (strong, nonatomic) EasyProgressHUDContentViewController *contentViewController;
@property (nonatomic) CGRect contentViewFrame;
@property (copy, nonatomic) NSString *status;

@end

@implementation EasyProgressHUDViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Initialization code
        
        self.wantsFullScreenLayout = YES;
        
    }
    return self;
}

- (void)dealloc
{
//    DLog();
}

#pragma mark - View Lifecycle

- (void)loadView
{
    [super loadView];
    
//#ifdef __IPHONE_7_0
//    if (systemVersionGreaterThanOrEqualTo(7)) {
//        self.edgesForExtendedLayout = UIRectEdgeNone;
//    }
//#endif
    self.view.backgroundColor = [UIColor clearColor];
    self.view.userInteractionEnabled = YES;
    
    
    if (self.contentViewController == nil) {
        EasyProgressHUDContentViewController *contentViewController = [[EasyProgressHUDContentViewController alloc] initWithNibName:nil bundle:nil];
//        contentViewController.window = _window;
        [self addChildViewController:contentViewController];
        [self.view addSubview:contentViewController.view];
        contentViewController.view.frame = _contentViewFrame;
        contentViewController.statusLabel.text = _status;
        self.contentViewController = contentViewController;
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
//#ifdef __IPHONE_7_0
//    [self setNeedsStatusBarAppearanceUpdate];
//#endif
    
}

//- (BOOL)prefersStatusBarHidden
//{
//    return NO;
//}
//

#ifdef __IPHONE_7_0
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#endif

- (BOOL)shouldAutorotate
{
//    DLog(@"%@\t%@", NSStringFromCGRect(self.view.bounds), NSStringFromCGRect(_contentViewFrame));
//    return YES;
    
    EasyProgressHUDWindow *window = (EasyProgressHUDWindow *)self.view.window;
    UIViewController *rootViewController = window.oldWindow.rootViewController;
    
    if ([window isKindOfClass:[EasyProgressHUDWindow class]] && [rootViewController respondsToSelector:@selector(shouldAutorotate)]) {
        return [rootViewController shouldAutorotate];
    }
    
    return [super shouldAutorotate];
}

- (NSUInteger)supportedInterfaceOrientations
{
    EasyProgressHUDWindow *window = (EasyProgressHUDWindow *)self.view.window;
    UIViewController *rootViewController = window.oldWindow.rootViewController;
    
    if ([window isKindOfClass:[EasyProgressHUDWindow class]] && [rootViewController respondsToSelector:@selector(supportedInterfaceOrientations)]) {
        return [rootViewController supportedInterfaceOrientations];
    }
    
    return [super supportedInterfaceOrientations];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ([self.view.window isKindOfClass:[EasyProgressHUDWindow class]]) {
        return [self oldRootViewControllerShouldRotateToOrientation:toInterfaceOrientation];;
    } else {
        return [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
}

- (BOOL)oldRootViewControllerShouldRotateToOrientation:(UIInterfaceOrientation)toInterfaceOrientation
{
    BOOL shouldRotateToOrientation = NO;
    EasyProgressHUDWindow *window = (EasyProgressHUDWindow *)self.view.window;
    UIViewController *rootViewController = window.oldWindow.rootViewController;
    
    if ([[self superclass] instancesRespondToSelector:@selector(presentedViewController)] && ([rootViewController presentedViewController] != nil)) {
        DLog(@"Presented view controller: %@", rootViewController.presentedViewController);
        shouldRotateToOrientation = [rootViewController.presentedViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    
    if ((shouldRotateToOrientation == NO) && (rootViewController != nil)) {
        shouldRotateToOrientation = [rootViewController shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    } else if(rootViewController == nil){
        DLog(@"Root view controller for your application cannot be found! Defaulting to liberal rotation handling for your device!");
        
        shouldRotateToOrientation = [super shouldAutorotateToInterfaceOrientation:toInterfaceOrientation];
    }
    
    return shouldRotateToOrientation;
}

@end

@interface EasyProgressHUDController ()

@property (strong, nonatomic) UIView *overlayViewInMainWindow;
@property (strong, nonatomic) EasyProgressHUDWindow *window;
@property (strong, nonatomic) EasyProgressHUDViewController *viewController;

@end

#pragma mark - Controller

@implementation EasyProgressHUDController

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
    [_overlayViewInMainWindow removeFromSuperview];
//    DLog();
}

#pragma mark - Public

+ (void)showInView:(UIView *)view
{
    [self showInView:view status:NSLocalizedString(@"Loading", nil)];
}

+ (void)showInView:(UIView *)view status:(NSString *)status
{
    view.progressHUDController = [[EasyProgressHUDController alloc] init];
    
//    EasyProgressHUDController *controller = [EasyProgressHUDController sharedController];
    EasyProgressHUDController *controller = view.progressHUDController;
    if (controller.window == nil) {
        
        UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
//        CGRect contentViewFrame = [keyWindow convertRect:view.frame fromView:view];
//        DLog(@"%@\n%@", view, NSStringFromCGRect(contentViewFrame));
        CGRect contentViewFrame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(view.bounds), CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        UIView *overlayViewInMainWindow = [[UIView alloc] initWithFrame:contentViewFrame];
        overlayViewInMainWindow.userInteractionEnabled = YES;
        overlayViewInMainWindow.backgroundColor = [UIColor clearColor];
//        overlayViewInMainWindow.alpha = .3;
        [keyWindow addSubview:overlayViewInMainWindow];
        
        controller.overlayViewInMainWindow = overlayViewInMainWindow;
        
        EasyProgressHUDWindow *window = [[EasyProgressHUDWindow alloc] init];
        EasyProgressHUDViewController *viewController = [[EasyProgressHUDViewController alloc] initWithNibName:nil bundle:nil];
//        viewController.window = window;
//        viewController.contentViewFrame = CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds) - CGRectGetHeight(view.bounds), CGRectGetWidth(view.bounds), CGRectGetHeight(view.bounds));
        viewController.contentViewFrame = contentViewFrame;
        viewController.status = status;
        window.rootViewController = viewController;
        controller.window = window;
        controller.viewController = viewController;
        
//        EasyProgressHUDOverlayView *overlayView = [[EasyProgressHUDOverlayView alloc] initWithFrame:window.bounds overlayMode:MMProgressHUDWindowOverlayModeGradient];
//        overlayView.backgroundColor = [UIColor clearColor];
//        overlayView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
//        [window insertSubview:overlayView atIndex:0];
//        controller.overlayView = overlayView;
        
    } else {
//        controller.window.frame = view.frame;
//        controller.overlayView.frame = controller.window.bounds;
//        [controller.overlayView _buildGradient];
        [self updateStatus:status forView:view];
    }
    
//    [controller.window makeKeyAndVisible];
    controller.window.hidden = NO;
    
    UIView *animatedView = controller.viewController.contentViewController.containerView;
    //Make the view small and transparent before animation
    animatedView.alpha = 0.f;
    animatedView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    
    //animate into full size
    //First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    //This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        animatedView.alpha = 1.f;
        animatedView.transform = CGAffineTransformMakeScale(1.05f, 1.05f);
    } completion:^(BOOL finished) {
        animatedView.transform = CGAffineTransformIdentity;
    }];
}

+ (void)dismissFromView:(UIView *)view
{
//    EasyProgressHUDController *controller = [EasyProgressHUDController sharedController];
    EasyProgressHUDController *controller = view.progressHUDController;
    
    UIView *animatedView = controller.viewController.contentViewController.containerView;
    [UIView animateWithDuration:.2 delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
//        controller.overlayView.alpha = 0.f;
        animatedView.alpha = 0.f;
        animatedView.transform = CGAffineTransformMakeScale(0.1f, 0.1f);
    } completion:^(BOOL finished) {
//        [controller.window resignKeyWindow];
//        controller.overlayView.alpha = 1.0f;
//        [controller.overlayView removeFromSuperview];
//        controller.overlayView = nil;
        controller.window.hidden = YES;
//        controller.window = nil;
//        controller.window.rootViewController = nil;
//        [controller.viewController.contentViewController.view removeFromSuperview];
//        [controller.viewController.contentViewController removeFromParentViewController];
        animatedView.transform = CGAffineTransformIdentity;
        animatedView.alpha = 1.0f;
        
        view.progressHUDController = nil;
        
        [controller.overlayViewInMainWindow removeFromSuperview];
    }];
}

+ (void)updateStatus:(NSString *)status forView:(UIView *)view
{
    if ([status isKindOfClass:[NSString class]] && [view isKindOfClass:[UIView class]]) {
        EasyProgressHUDController *controller = view.progressHUDController;
        controller.viewController.contentViewController.statusLabel.text = status;
    }
}

#pragma mark - Private

@end
