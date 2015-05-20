//
//  BlurView.m
//  Sales
//
//  Created by Jayce Yang on 14/11/25.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "BlurView.h"

#import "UIView+Easy.h"
#import "NSObject+Easy.h"
#import "UIImage+ImageEffects.h"

@interface BlurView ()

@property (strong, nonatomic) UIToolbar *toolbar;

@end

@implementation BlurView

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (instancetype)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        
        [self setupDefaults];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.toolbar.frame = self.bounds;
}

- (void)setupDefaults {
    if (!systemVersionGreaterThanOrEqualTo(8)) {
        UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:self.bounds];
        toolbar.translucent = YES;
        [self.layer insertSublayer:toolbar.layer atIndex:0];
        self.toolbar = toolbar;
    }
    [self blurBackground];
}

- (void)blurBackground {
    self.backgroundColor = [UIColor clearColor];
    self.clipsToBounds = YES;
    
    if (self.toolbar == nil) {
        UIVisualEffect *visualEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleExtraLight];
        UIVisualEffectView *blurView = [[UIVisualEffectView alloc] initWithEffect:visualEffect];
        blurView.translatesAutoresizingMaskIntoConstraints = NO;
        [self insertSubview:blurView atIndex:0];
        [blurView constrainEquallyToSuperview];
    } else {
//        UIGraphicsBeginImageContextWithOptions(self.bounds.size, NO, [[UIScreen mainScreen] scale]);
//        //Snapshot finished in 0.051982 seconds.
//        [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:NO];
//        __block UIImage *snapshot = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
//        self.backgroundImageView.image = [snapshot applyExtraLightEffect];
        
//        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
//            //Blur finished in 0.004884 seconds.
//            snapshot = [snapshot applyExtraLightEffect];
//            dispatch_sync(dispatch_get_main_queue(), ^{
//                self.backgroundImageView.image = snapshot;
//            });
//        });
    }
}

@end
