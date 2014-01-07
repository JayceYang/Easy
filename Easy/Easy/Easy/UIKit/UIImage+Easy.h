//
//  UIImage+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/6/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Easy)

+ (UIImage *)imageFromColor:(UIColor *)color;
+ (UIColor *)dropdownBackgroundImageColor;
+ (UIImage *)dropdownBackgroundImageGray;

- (UIImage *)resizableImageWithZeroCapInsets;
- (UIImage *)resizableImageWithCenterCapInsets;

- (UIImage *)imageWithCurrentScale;
//- (CGSize)sizeToFitSize:(CGSize)size;
- (UIImage *)imageToFitSize:(CGSize)size;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
+ (UIImage *)animatedGIFWithData:(NSData *)data;

@end
