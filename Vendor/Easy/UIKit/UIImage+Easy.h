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
+ (UIImage *)imageFromView:(UIView *)view;
+ (UIColor *)dropdownBackgroundImageColor;
+ (UIImage *)dropdownBackgroundImageGray;

- (UIImage *)resizableImageWithZeroCapInsets;
- (UIImage *)resizableImageWithCenterCapInsets;

- (UIImage *)imageWithCurrentScale;
//- (CGSize)sizeToFitSize:(CGSize)size;
- (UIImage *)imageToFitSize:(CGSize)size;
- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha;
+ (UIImage *)animatedGIFWithData:(NSData *)data;

- (UIImage *)imageWithCorrectiveRotation;

- (NSString *)writeToFileNamed:(NSString *)name;
- (NSString *)writeToFileNamed:(NSString *)name extension:(NSString *)extension;
- (NSString *)writeToFileNamed:(NSString *)name compressionQuality:(CGFloat)quality;

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent;
- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent extension:(NSString *)extension;
- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent compressionQuality:(CGFloat)quality;

@end

extern NSString * const kExtensionPNG;
extern NSString * const kExtensionJPEG;
