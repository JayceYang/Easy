//
//  PopoverViewController.m
//  iGuest
//
//  Created by Jayce Yang on 8/23/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "PopoverViewController.h"
#import "PopoverViewConfiguration.h"
#import "NSObject+Easy.h"

@interface PopoverWindow : UIWindow


@end

@implementation PopoverWindow

- (instancetype)init
{
    self = [super initWithFrame:[[UIScreen mainScreen] bounds]];
    if (self) {
        // Initialization code
        
        self.windowLevel = UIWindowLevelStatusBar;
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

@end

@interface PopoverContainerView : UIView

@property (nonatomic) CGSize popoverContentSize;
@property (readonly, nonatomic) CGRect contentFrame;

@end


@interface PopoverContainerView ()

@property (nonatomic) CGRect boxFrame;
@property (nonatomic) CGPoint arrowPoint;
@property (nonatomic) BOOL above;
@property (nonatomic) CGRect contentFrame;

@end

@implementation PopoverContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.

- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    // Build the popover path
    CGRect frame = _boxFrame;
    
    float xMin = CGRectGetMinX(frame);
    float yMin = CGRectGetMinY(frame);
    
    float xMax = CGRectGetMaxX(frame);
    float yMax = CGRectGetMaxY(frame);
    
    float radius = kBoxRadius; //Radius of the curvature.
    
    float cpOffset = kCPOffset; //Control Point Offset.  Modifies how "curved" the corners are.
    
    
    /*
     LT2            RT1
     LT1⌜⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⎺⌝RT2
     |               |
     |    popover    |
     |               |
     LB2⌞_______________⌟RB1
     LB1           RB2
     
     Traverse rectangle in clockwise order, starting at LT1
     L = Left
     R = Right
     T = Top
     B = Bottom
     1,2 = order of traversal for any given corner
     
     */
    
    UIBezierPath *popoverPath = [UIBezierPath bezierPath];
    [popoverPath moveToPoint:CGPointMake(CGRectGetMinX(frame), CGRectGetMinY(frame) + radius)];//LT1
    [popoverPath addCurveToPoint:CGPointMake(xMin + radius, yMin) controlPoint1:CGPointMake(xMin, yMin + radius - cpOffset) controlPoint2:CGPointMake(xMin + radius - cpOffset, yMin)];//LT2
    
    //If the popover is positioned below (!above) the arrowPoint, then we know that the arrow must be on the top of the popover.
    //In this case, the arrow is located between LT2 and RT1
    if (!_above) {
        [popoverPath addLineToPoint:CGPointMake(_arrowPoint.x - kArrowHeight, yMin)];//left side
        [popoverPath addCurveToPoint:_arrowPoint controlPoint1:CGPointMake(_arrowPoint.x - kArrowHeight + kArrowCurvature, yMin) controlPoint2:_arrowPoint];//actual arrow point
        [popoverPath addCurveToPoint:CGPointMake(_arrowPoint.x + kArrowHeight, yMin) controlPoint1:_arrowPoint controlPoint2:CGPointMake(_arrowPoint.x + kArrowHeight - kArrowCurvature, yMin)];//right side
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMax - radius, yMin)];//RT1
    [popoverPath addCurveToPoint:CGPointMake(xMax, yMin + radius) controlPoint1:CGPointMake(xMax - radius + cpOffset, yMin) controlPoint2:CGPointMake(xMax, yMin + radius - cpOffset)];//RT2
    [popoverPath addLineToPoint:CGPointMake(xMax, yMax - radius)];//RB1
    [popoverPath addCurveToPoint:CGPointMake(xMax - radius, yMax) controlPoint1:CGPointMake(xMax, yMax - radius + cpOffset) controlPoint2:CGPointMake(xMax - radius + cpOffset, yMax)];//RB2
    
    //If the popover is positioned above the arrowPoint, then we know that the arrow must be on the bottom of the popover.
    //In this case, the arrow is located somewhere between LB1 and RB2
    if (_above) {
        [popoverPath addLineToPoint:CGPointMake(_arrowPoint.x + kArrowHeight, yMax)];//right side
        [popoverPath addCurveToPoint:_arrowPoint controlPoint1:CGPointMake(_arrowPoint.x + kArrowHeight - kArrowCurvature, yMax) controlPoint2:_arrowPoint];//arrow point
        [popoverPath addCurveToPoint:CGPointMake(_arrowPoint.x - kArrowHeight, yMax) controlPoint1:_arrowPoint controlPoint2:CGPointMake(_arrowPoint.x - kArrowHeight + kArrowCurvature, yMax)];
    }
    
    [popoverPath addLineToPoint:CGPointMake(xMin + radius, yMax)];//LB1
    [popoverPath addCurveToPoint:CGPointMake(xMin, yMax - radius) controlPoint1:CGPointMake(xMin + radius - cpOffset, yMax) controlPoint2:CGPointMake(xMin, yMax - radius + cpOffset)];//LB2
    [popoverPath closePath];
    
    //// General Declarations
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    //// Shadow Declarations
    UIColor* shadow = [UIColor colorWithWhite:0.0f alpha:kShadowAlpha];
    CGSize shadowOffset = CGSizeMake(0, 1);
    CGFloat shadowBlurRadius = kShadowBlur;
    
    //// Gradient Declarations
    NSArray* gradientColors = [NSArray arrayWithObjects:
                               (id)kGradientTopColor.CGColor,
                               (id)kGradientBottomColor.CGColor, nil];
    CGFloat gradientLocations[] = {0, 1};
    CGGradientRef gradient = CGGradientCreateWithColors(colorSpace, (__bridge CFArrayRef)(gradientColors), gradientLocations);
    
    
    //These floats are the top and bottom offsets for the gradient drawing so the drawing includes the arrows.
    float bottomOffset = (_above ? kArrowHeight : 0.f);
    float topOffset = (!_above ? kArrowHeight : 0.f);
    
    //Draw the actual gradient and shadow.
    CGContextSaveGState(context);
    CGContextSetShadowWithColor(context, shadowOffset, shadowBlurRadius, shadow.CGColor);
    CGContextBeginTransparencyLayer(context, NULL);
    [popoverPath addClip];
    CGContextDrawLinearGradient(context, gradient, CGPointMake(CGRectGetMidX(frame), CGRectGetMinY(frame) - topOffset), CGPointMake(CGRectGetMidX(frame), CGRectGetMaxY(frame) + bottomOffset), 0);
    CGContextEndTransparencyLayer(context);
    CGContextRestoreGState(context);
    
    //// Cleanup
    CGGradientRelease(gradient);
    CGColorSpaceRelease(colorSpace);
    
    //Draw border if we need to
    //The border is done last because it needs to be drawn on top of everything else
    if (kDrawBorder) {
        [kBorderColor setStroke];
        popoverPath.lineWidth = kBorderWidth;
        [popoverPath stroke];
    }
    
}

#pragma mark - Private

- (void)layoutAtPoint:(CGPoint)point inView:(UIView *)view
{
    // make transparent
    self.alpha = 0.f;
    
    [self setupLayout:point inView:view];
    
    // animate back to full opacity
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.alpha = 1.f;
    } completion:nil];
}

- (void)setupLayout:(CGPoint)point inView:(UIView *)view
{
    CGPoint topPoint = [self.superview convertPoint:point fromView:view];
    
    self.arrowPoint = topPoint;
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    CGRect topViewBounds = self.superview.bounds;
    //NSLog(@"topViewBounds %@", NSStringFromCGRect(topViewBounds));
    
    float contentHeight = _popoverContentSize.height;
    float contentWidth = _popoverContentSize.width;
    
    float padding = kBoxPadding;
    
    float boxHeight = contentHeight + 2.f*padding;
    float boxWidth = contentWidth + 2.f*padding;
    
    float xOrigin = 0.f;
    
    //Make sure the arrow point is within the drawable bounds for the popover.
    if (_arrowPoint.x + kArrowHeight > topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding) {//Too far to the right
        _arrowPoint.x = topViewBounds.size.width - kHorizontalMargin - kBoxRadius - kArrowHorizontalPadding - kArrowHeight;
        //NSLog(@"Correcting Arrow Point because it's too far to the right");
    } else if (_arrowPoint.x - kArrowHeight < kHorizontalMargin + kBoxRadius + kArrowHorizontalPadding) {//Too far to the left
        _arrowPoint.x = kHorizontalMargin + kArrowHeight + kBoxRadius + kArrowHorizontalPadding;
        //NSLog(@"Correcting Arrow Point because it's too far to the left");
    }
    
    //NSLog(@"arrowPoint:%f,%f", arrowPoint.x, arrowPoint.y);
    
    xOrigin = floorf(_arrowPoint.x - boxWidth*0.5f);
    
    //Check to see if the centered xOrigin value puts the box outside of the normal range.
    if (xOrigin < CGRectGetMinX(topViewBounds) + kHorizontalMargin) {
        xOrigin = CGRectGetMinX(topViewBounds) + kHorizontalMargin;
    } else if (xOrigin + boxWidth > CGRectGetMaxX(topViewBounds) - kHorizontalMargin) {
        //Check to see if the positioning puts the box out of the window towards the left
        xOrigin = CGRectGetMaxX(topViewBounds) - kHorizontalMargin - boxWidth;
    }
    
    float arrowHeight = kArrowHeight;
    
    float topPadding = kTopMargin;
    
    self.above = YES;
    
    if (topPoint.y - contentHeight - arrowHeight - topPadding < CGRectGetMinY(topViewBounds)) {
        //Position below because it won't fit above.
        self.above = NO;
        
        self.boxFrame = CGRectMake(xOrigin, _arrowPoint.y + arrowHeight, boxWidth, boxHeight);
    } else {
        //Position above.
        self.above = YES;
        
        self.boxFrame = CGRectMake(xOrigin, _arrowPoint.y - arrowHeight - boxHeight, boxWidth, boxHeight);
    }
    
    //NSLog(@"boxFrame:(%f,%f,%f,%f)", boxFrame.origin.x, boxFrame.origin.y, boxFrame.size.width, boxFrame.size.height);
    
    self.contentFrame = CGRectMake(_boxFrame.origin.x + padding, _boxFrame.origin.y + padding, contentWidth, contentHeight);
//    contentView.frame = contentFrame;
    
    //We set the anchorPoint here so the popover will "grow" out of the arrowPoint specified by the user.
    //You have to set the anchorPoint before setting the frame, because the anchorPoint property will
    //implicitly set the frame for the view, which we do not want.
    self.layer.anchorPoint = CGPointMake(_arrowPoint.x / topViewBounds.size.width, _arrowPoint.y / topViewBounds.size.height);
//    DLog(@"%@", NSStringFromCGPoint(self.layer.anchorPoint));
    self.frame = topViewBounds;
    [self setNeedsDisplay];
    
//    [self addSubview:contentView];
//    [_topView addSubview:self];
}

@end

#pragma mark - Interface PopoverViewController

static CGFloat const smallerFactor = 0.1f;
static CGFloat const larherFactor = 1.05f;

@interface PopoverViewController () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) PopoverWindow *window;
@property (strong, nonatomic) PopoverContainerView *containerView;
@property (weak, nonatomic) UIViewController *contentViewController;

@end

#pragma mark - Implementation PopoverViewController

@implementation PopoverViewController

- (id)initWithContentViewController:(UIViewController *)viewController
{
    self = [super initWithNibName:nil bundle:nil];
    if (self) {
        // Initialization code
        
//        self.wantsFullScreenLayout = YES;
        self.contentViewController = viewController;
        
        
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
    
    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped:)];
    tapGestureRecognizer.numberOfTapsRequired = 1;
    tapGestureRecognizer.delegate = self;
    tapGestureRecognizer.cancelsTouchesInView = NO;
    [self.view addGestureRecognizer:tapGestureRecognizer];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
#ifdef __IPHONE_7_0
    if (systemVersionGreaterThanOrEqualTo(7)) {
        [self setNeedsStatusBarAppearanceUpdate];
    }
#endif
    
}

#ifdef __IPHONE_7_0

- (BOOL)prefersStatusBarHidden
{
    return NO;
}
- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}
#endif

#pragma mark - Public

- (void)presentPopoverAtPoint:(CGPoint)point inView:(UIView *)view
{
    
//    NSLog(@"point:%f,%f", point.x, point.y);
    
    self.window = [[PopoverWindow alloc] init];
    _window.rootViewController = self;
    _window.hidden = NO;
//    _window.userInteractionEnabled = YES;
    
//    [_window makeKeyAndVisible];
    
//    CGSize contentSize = CGSizeMake(150, 200);
    self.containerView = [[PopoverContainerView alloc] initWithFrame:CGRectZero];
    _containerView.popoverContentSize = self.contentViewController.contentSizeForViewInPopover;
    [self.view addSubview:_containerView];
    [self.containerView setupLayout:point inView:view];
    
    [self addChildViewController:_contentViewController];
    [self.view addSubview:_contentViewController.view];
    _contentViewController.view.layer.anchorPoint = CGPointMake(self.containerView.layer.anchorPoint.x, 0);
    _contentViewController.view.frame = _containerView.contentFrame;
    
    // Make the view small and transparent before animation
    self.containerView.alpha = 0.f;
    self.containerView.transform = CGAffineTransformMakeScale(smallerFactor, smallerFactor);
    self.contentViewController.view.alpha = 0.f;
    self.contentViewController.view.transform = CGAffineTransformMakeScale(smallerFactor, smallerFactor);
    
    // animate into full size
    // First stage animates to 1.05x normal size, then second stage animates back down to 1x size.
    // This two-stage animation creates a little "pop" on open.
    [UIView animateWithDuration:0.2f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        self.containerView.alpha = 0.f;
        self.contentViewController.view.alpha = 0.f;
        
        self.containerView.alpha = 1.f;
        self.containerView.transform = CGAffineTransformMakeScale(larherFactor, larherFactor);
        self.contentViewController.view.alpha = 1.f;
        self.contentViewController.view.transform = CGAffineTransformMakeScale(larherFactor, larherFactor);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:0.1f delay:0.f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            self.containerView.transform = CGAffineTransformIdentity;
            self.contentViewController.view.transform = CGAffineTransformIdentity;
        } completion:nil];
    }];
}

- (void)dismiss
{
    [self dismiss:YES];
}

- (void)dismiss:(BOOL)animated
{
    if (!animated) {
        [self dismissComplete];
    } else {
        [UIView animateWithDuration:0.3f animations:^{
            self.containerView.alpha = 0.1f;
            self.containerView.transform = CGAffineTransformMakeScale(smallerFactor, smallerFactor);
            self.contentViewController.view.alpha = 0.1f;
            self.contentViewController.view.transform = CGAffineTransformMakeScale(smallerFactor, smallerFactor);
        } completion:^(BOOL finished) {
            self.contentViewController.view.transform = CGAffineTransformIdentity;
            [self dismissComplete];
        }];
    }
}

- (void)animateRotationToNewPoint:(CGPoint)point inView:(UIView *)view withDuration:(NSTimeInterval)duration
{
    [self.containerView layoutAtPoint:point inView:view];
}

- (void)dismissComplete
{
//    [_window resignKeyWindow];
    _window.rootViewController = nil;
    _window.hidden = YES;
//    _window.alpha = 0;
    _window = nil;
    
    [_containerView removeFromSuperview];
    [_contentViewController removeFromParentViewController];
//    _contentViewController = nil;
}

#pragma mark - Private

- (void)tapped:(UITapGestureRecognizer *)tap
{
    [self dismiss:YES];
}

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
//    NSLog(@"%@",[touch view]);
//    
//    CGPoint point = [gestureRecognizer locationInView:self.containerView];
//    
//    NSLog(@"point:(%f,%f)", point.x, point.y);
//    
//    BOOL found = NO;
//    
//    if (CGRectContainsPoint(_containerView.contentFrame, point)) {
//        //The tap was within this view, so we notify the delegate, and break the loop.
//        
//        found = YES;
//    }
    
    return (touch.view == self.containerView);
}

@end