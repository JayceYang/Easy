//
//  UIImage+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/6/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "UIImage+Easy.h"
#import "NSObject+Easy.h"
#import "Macro.h"

NSString * const kExtensionPNG           = @"png";
NSString * const kExtensionJPEG          = @"jpeg";

@implementation UIImage (Easy)

+ (UIImage *)imageFromColor:(UIColor *)color
{
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}

+ (UIImage *)imageFromView:(UIView *)view
{
//    CGFloat scale = [UIScreen mainScreen].scale;
//    UIGraphicsBeginImageContextWithOptions(view.bounds.size, view.opaque, scale);
    UIGraphicsBeginImageContext(view.frame.size);
	CGContextRef context = UIGraphicsGetCurrentContext();
	[view.layer renderInContext:context];
	UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
    return image;
}

+ (UIColor *)dropdownBackgroundImageColor
{
    return [UIColor colorWithWhite:0.32 alpha:1];
}

+ (UIImage *)dropdownBackgroundImageGray
{
    return [[UIImage imageFromColor:[self dropdownBackgroundImageColor]] resizableImageWithCenterCapInsets];
}

- (UIImage *)resizableImageWithZeroCapInsets
{
    return [self resizableImageWithCapInsets:UIEdgeInsetsZero];
}

- (UIImage *)resizableImageWithCenterCapInsets
{
    CGFloat width = self.size.width;
    CGFloat height = self.size.height;
    CGFloat step = .5f;
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake((height - step) / 2, (width - step) / 2, (height - step) / 2, (width - step) / 2)];
}

- (UIImage *)imageWithCurrentScale
{
    UIImage *image = nil;
    @try {
        image = [UIImage imageWithCGImage:self.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return image;
    }
}

- (CGSize)sizeToFitSize:(CGSize)size
{
    if (!self || (NSInteger)fabsf(self.size.width) == 0 || (NSInteger)fabsf(self.size.height) == 0 || (NSInteger)fabsf(size.width) == 0 || (NSInteger)fabsf(size.height) == 0) {
        return CGSizeZero;
    }
    
    CGFloat factor;
	CGSize resultSize;
	
	if (self.size.width < size.width && self.size.height < size.height) {
		resultSize = self.size;
	} else {
		if (self.size.width >= self.size.height) {
			factor = size.width / self.size.width;
			resultSize.width = size.width;
			resultSize.height = self.size.height * factor;
		} else {
			factor = size.height / self.size.height;
			resultSize.height = size.height;
			resultSize.width = self.size.width * factor;
		}
	}
	return resultSize;
}

- (UIImage *)imageToFitSize:(CGSize)size
{
//    NSLog(@"%@", NSStringFromCGSize(size));
    CGFloat scale = [UIScreen mainScreen].scale;
//    UIGraphicsBeginImageContext(size);
    UIGraphicsBeginImageContextWithOptions(size, YES, scale);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextScaleCTM(context, 1, -1);
    CGContextSetInterpolationQuality(context, kCGInterpolationHigh);
	CGRect rect = CGRectMake(0, 0, size.width, size.height);
    CGContextDrawTiledImage(context, rect, self.CGImage);
//	[self drawInRect:rect];
	UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
	UIGraphicsEndImageContext();
//    NSLog(@"%.0lf\t%.0lf", resultImage.size.width, resultImage.size.height);
	return resultImage;
}

- (UIImage *)imageByApplyingAlpha:(CGFloat)alpha
{
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0.0f);
    
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGRect area = CGRectMake(0, 0, self.size.width, self.size.height);
    
    CGContextScaleCTM(ctx, 1, -1);
    CGContextTranslateCTM(ctx, 0, -area.size.height);
    
    CGContextSetBlendMode(ctx, kCGBlendModeMultiply);
    
    CGContextSetAlpha(ctx, alpha);
    
    CGContextDrawImage(ctx, area, self.CGImage);
    
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return newImage;
}

+ (UIImage *)animatedGIFWithData:(NSData *)data
{
    if (!data) {
        return nil;
    }
    
    CGImageSourceRef source = CGImageSourceCreateWithData((__bridge CFDataRef)data, NULL);
    
    size_t count = CGImageSourceGetCount(source);
    NSMutableArray *images = [NSMutableArray array];
    
    NSTimeInterval duration = 0.0f;
    
    for (size_t i = 0; i < count; i++) {
        CGImageRef image = CGImageSourceCreateImageAtIndex(source, i, NULL);
        
        NSDictionary *frameProperties = CFBridgingRelease(CGImageSourceCopyPropertiesAtIndex(source, i, NULL));
        duration += [[[frameProperties objectForKey:(NSString *)kCGImagePropertyGIFDictionary] objectForKey:(NSString *)kCGImagePropertyGIFDelayTime] doubleValue];
        
        [images addObject:[UIImage imageWithCGImage:image scale:[UIScreen mainScreen].scale orientation:UIImageOrientationUp]];
        
        CGImageRelease(image);
    }
    
    CFRelease(source);
    
    if (!duration) {
        duration = (1.0f/10.0f)*count;
    }
    
    return [UIImage animatedImageWithImages:images duration:duration];
}

- (UIImage *)imageWithCorrectiveRotation
{
    CGImageRef imageRef = self.CGImage;
    
    CGFloat width = CGImageGetWidth(imageRef);
    CGFloat height = CGImageGetHeight(imageRef);
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    CGRect bounds = CGRectMake(0, 0, width, height);
    CGFloat scaleRatio = 1;
    CGFloat boundHeight;
    UIImageOrientation orient = self.imageOrientation;
    
    switch(orient) {
            
        case UIImageOrientationUp:
            transform = CGAffineTransformIdentity;
            break;
            
        case UIImageOrientationUpMirrored:
            transform = CGAffineTransformMakeTranslation(width, 0.0);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            break;
            
        case UIImageOrientationDown:
            transform = CGAffineTransformMakeTranslation(width, height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformMakeTranslation(0.0, height);
            transform = CGAffineTransformScale(transform, 1.0, -1.0);
            break;
            
        case UIImageOrientationLeftMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, width);
            transform = CGAffineTransformScale(transform, -1.0, 1.0);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationLeft:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(0.0, width);
            transform = CGAffineTransformRotate(transform, 3.0 * M_PI / 2.0);
            break;
            
        case UIImageOrientationRightMirrored:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeScale(-1.0, 1.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        case UIImageOrientationRight:
            boundHeight = bounds.size.height;
            bounds.size.height = bounds.size.width;
            bounds.size.width = boundHeight;
            transform = CGAffineTransformMakeTranslation(height, 0.0);
            transform = CGAffineTransformRotate(transform, M_PI / 2.0);
            break;
            
        default:
            NSLog(@"Invalid image orientation");
            break;
    }
    
    UIGraphicsBeginImageContext(bounds.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    if (orient == UIImageOrientationRight || orient == UIImageOrientationLeft) {
        CGContextScaleCTM(context, -scaleRatio, scaleRatio);
        CGContextTranslateCTM(context, -height, 0);
    } else {
        CGContextScaleCTM(context, scaleRatio, -scaleRatio);
        CGContextTranslateCTM(context, 0, -height);
    }
    
    CGContextConcatCTM(context, transform);
    CGContextDrawImage(UIGraphicsGetCurrentContext(), CGRectMake(0, 0, width, height), imageRef);
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return resultImage;
}

- (NSString *)writeToFileNamed:(NSString *)name
{
    return [self writeToFileNamed:name extension:kExtensionPNG];
}

- (NSString *)writeToFileNamed:(NSString *)name extension:(NSString *)extension
{
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingPathExtension:extension];
    if ([extension isEqualToString:kExtensionPNG]) {
        [UIImagePNGRepresentation([self imageWithCorrectiveRotation]) writeToFile:filePath atomically:YES];
    } else {
        [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], 1.0) writeToFile:filePath atomically:YES];
    }
    return filePath;
}

- (NSString *)writeToFileNamed:(NSString *)name compressionQuality:(CGFloat)quality
{
    NSString *filePath = [[self documentsPath] stringByAppendingPathComponent:name];
    filePath = [filePath stringByAppendingPathExtension:kExtensionJPEG];
    [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], quality) writeToFile:filePath atomically:YES];
    return filePath;
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent
{
    return [self writeToURLWithLastPathComponent:pathComponent extension:kExtensionPNG];
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent extension:(NSString *)extension
{
    NSURL *absoluteURL = [[[self documentsURL] URLByAppendingPathComponent:pathComponent] URLByAppendingPathExtension:extension];
    if ([extension isEqualToString:kExtensionPNG]) {
        [UIImagePNGRepresentation([self imageWithCorrectiveRotation]) writeToURL:absoluteURL atomically:YES];
    } else {
        [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], .8) writeToURL:absoluteURL atomically:YES];
    }
    return absoluteURL;
}

- (NSURL *)writeToURLWithLastPathComponent:(NSString *)pathComponent compressionQuality:(CGFloat)quality
{
    NSURL *absoluteURL = [[[self documentsURL] URLByAppendingPathComponent:pathComponent] URLByAppendingPathExtension:kExtensionJPEG];
    [UIImageJPEGRepresentation([self imageWithCorrectiveRotation], quality) writeToURL:absoluteURL atomically:YES];
    return absoluteURL;
}

@end