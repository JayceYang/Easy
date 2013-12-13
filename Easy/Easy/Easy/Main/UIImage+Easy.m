//
//  UIImage+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 6/6/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import <ImageIO/ImageIO.h>

#import "UIImage+Easy.h"
#import "NSObject+Easy.h"
#import "Macro.h"

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
    return [self resizableImageWithCapInsets:UIEdgeInsetsMake(height / 2, width / 2, height / 2, width / 2)];
}

- (UIImage *)imageWithCurrentScale
{
    UIImage *image = nil;
    @try {
        image = [UIImage imageWithCGImage:self.CGImage scale:[UIScreen mainScreen].scale orientation:image.imageOrientation];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
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
//    DLog(@"%@", NSStringFromCGSize(size));
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
//    DLog(@"%.0lf\t%.0lf", resultImage.size.width, resultImage.size.height);
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

@end