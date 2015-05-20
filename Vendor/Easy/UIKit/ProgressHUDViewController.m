//
//  ProgressHUDViewController.m
//  SKYPIXEL
//
//  Created by Jayce Yang on 15/1/26.
//  Copyright (c) 2015年 DJI. All rights reserved.
//

#import "ProgressHUDViewController.h"

#import "BlurView.h"
#import "UIView+Easy.h"

NS_INLINE CGFloat ProgressHUDMathDegreesToRadians(CGFloat degrees) { return degrees * (M_PI / 180); };
static CGFloat const ProgressHUDInfiniteLoopAnimationDuration = 1.0f;

@interface ProgressHUDViewController ()

@property (strong, nonatomic) BlurView *contentView;
@property (strong, nonatomic) UIView *progressContainerView;
@property (strong, nonatomic) CAShapeLayer *circleProgressLineLayer;

@end

@implementation ProgressHUDViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    [self setupDefaults];
}

#pragma mark - Public

- (void)startAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    self.view.hidden = NO;
    self.contentView.hidden = NO;
    self.progressContainerView.hidden = NO;
    CABasicAnimation *rotationAnimation;
    rotationAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    rotationAnimation.toValue = @(M_PI * 2.0f * ProgressHUDInfiniteLoopAnimationDuration);
    rotationAnimation.duration = ProgressHUDInfiniteLoopAnimationDuration;
    rotationAnimation.cumulative = YES;
    rotationAnimation.repeatCount = HUGE_VALF;
    [self.progressContainerView.layer addAnimation:rotationAnimation forKey:@"rotationAnimation"];
    [CATransaction commit];
}

- (void)stopAnimation {
    [CATransaction begin];
    [CATransaction setDisableActions:YES];
    [self.progressContainerView.layer removeAllAnimations];
    self.view.hidden = YES;
    self.contentView.hidden = YES;
    self.progressContainerView.hidden = YES;
    [CATransaction commit];
}

#pragma mark - Private

- (void)setupDefaults {
    
    CGFloat circleSize = 25;
    CGFloat radius = (circleSize / 2.0f);
    
    self.contentView = [[BlurView alloc] initWithFrame:CGRectZero];
    self.contentView.backgroundColor = [UIColor clearColor];
    self.contentView.translatesAutoresizingMaskIntoConstraints = NO;
    self.contentView.layer.cornerRadius = 4.0f;
    self.contentView.layer.masksToBounds = YES;
    [self.view addSubview:self.contentView];
    [self.contentView constrainCentrallyToView:self.view width:50 height:50];
    
    self.progressContainerView = [[UIView alloc] initWithFrame:CGRectZero];
    self.progressContainerView.backgroundColor = [UIColor clearColor];
    self.progressContainerView.translatesAutoresizingMaskIntoConstraints = NO;
    self.progressContainerView.layer.cornerRadius = radius;
    self.progressContainerView.layer.masksToBounds = YES;
    [self.view addSubview:self.progressContainerView];
    [self.progressContainerView constrainCentrallyToView:self.view width:circleSize height:circleSize];

    CGPoint center = CGPointMake(radius, radius);
    CGFloat lineWidth = 1.0;
    UIBezierPath *circlePath = [UIBezierPath bezierPathWithArcCenter:center radius:(radius - lineWidth) startAngle:ProgressHUDMathDegreesToRadians(-45.0f) endAngle:ProgressHUDMathDegreesToRadians(275.0f) clockwise:YES];
    self.circleProgressLineLayer = [CAShapeLayer layer];
    self.circleProgressLineLayer.path = circlePath.CGPath;
    self.circleProgressLineLayer.strokeColor = [UIColor darkGrayColor].CGColor;
    self.circleProgressLineLayer.fillColor = [UIColor clearColor].CGColor;
    self.circleProgressLineLayer.lineWidth = lineWidth;
    [self.progressContainerView.layer addSublayer:self.circleProgressLineLayer];
    
    [self startAnimation];
}

@end
