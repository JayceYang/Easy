//
//  EasyDraggableView.m
//  Sales
//
//  Created by Jayce Yang on 14-9-2.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "EasyDraggableView.h"

@interface EasyDraggableView () <UIGestureRecognizerDelegate>

@property (strong, nonatomic) UIImageView *backgroundImageView;
@property (strong, nonatomic) UIPanGestureRecognizer *panGestureRecognizer;
@property (strong, nonatomic) UITapGestureRecognizer *tapGestureRecognizer;
@property (nonatomic) CGPoint startingPoint;

@end

@implementation EasyDraggableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (void)setBackground:(UIImage *)background
{
    _background = background;
    [self updateBackground];
}

#pragma mark - Private

- (void)setupDefaults
{
    self.panGestureRecognizer = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panAction:)];
    self.panGestureRecognizer.delegate = self;
    [self addGestureRecognizer:self.panGestureRecognizer];
    
    self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    [self.tapGestureRecognizer requireGestureRecognizerToFail:self.panGestureRecognizer];
    [self addGestureRecognizer:self.tapGestureRecognizer];
}

- (void)updateBackground
{
    if (self.background == nil) {
        [self.backgroundImageView removeFromSuperview];
        self.backgroundImageView = nil;
    } else {
        self.backgroundImageView = [[UIImageView alloc] initWithImage:self.background];
        self.backgroundImageView.frame = CGRectZero;
        self.backgroundImageView.translatesAutoresizingMaskIntoConstraints = NO;
        [self addSubview:self.backgroundImageView];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeTop multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeBottom multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self.backgroundImageView attribute:NSLayoutAttributeLeading relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:self attribute:NSLayoutAttributeTrailing relatedBy:NSLayoutRelationEqual toItem:self.backgroundImageView attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
    }
}

- (void)panAction:(UIPanGestureRecognizer *)gestureRecognizer
{
    switch (gestureRecognizer.state) {
        case UIGestureRecognizerStateBegan:
        {
            self.startingPoint = [gestureRecognizer locationInView:self];
        }
            break;
        case UIGestureRecognizerStateChanged:
        {
            CGPoint currentLocation = [gestureRecognizer locationInView:self];
            
            CGFloat offsetX = currentLocation.x - self.startingPoint.x;
            CGFloat offsetY = currentLocation.y - self.startingPoint.y;
            
            self.center = CGPointMake(self.center.x + offsetX, self.center.y + offsetY);
            
            CGRect superviewFrame = self.superview.frame;
            CGRect frame = self.frame;
            CGFloat leftLimitX = frame.size.width / 2;
            CGFloat rightLimitX = superviewFrame.size.width - leftLimitX;
            CGFloat topLimitY = frame.size.height / 2;
            CGFloat bottomLimitY = superviewFrame.size.height - topLimitY;
            
            if (self.center.x > rightLimitX) {
                self.center = CGPointMake(rightLimitX, self.center.y);
            } else if (self.center.x <= leftLimitX) {
                self.center = CGPointMake(leftLimitX, self.center.y);
            }
            
            if (self.center.y > bottomLimitY) {
                self.center = CGPointMake(self.center.x, bottomLimitY);
            } else if (self.center.y <= topLimitY) {
                self.center = CGPointMake(self.center.x, topLimitY);
            }
        }
            break;
        case UIGestureRecognizerStateEnded:
        {
            CGRect frame = self.frame;
            CGFloat superviewWidth = CGRectGetWidth(self.superview.bounds);
            CGFloat middleX = superviewWidth / 2;
            
            NSTimeInterval duration = 0.2;
            if (self.center.x >= middleX) {
                [UIView animateWithDuration:duration animations:^{
                    self.center = CGPointMake(superviewWidth - frame.size.width / 2, self.center.y);
                } completion:nil];
            } else {
                [UIView animateWithDuration:duration animations:^{
                    self.center = CGPointMake(frame.size.width / 2, self.center.y);
                } completion:nil];
            }
        }
            break;
        case UIGestureRecognizerStateCancelled:
        {
            
        }
            break;
        case UIGestureRecognizerStateFailed:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)tapAction:(UITapGestureRecognizer *)gestureRecognizer
{
    if (self.tapHandler) {
        self.tapHandler(self);
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
