//
//  CIImage+Easy.m
//  Sales
//
//  Created by Jayce Yang on 14-8-28.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "CIImage+Easy.h"

#import "UIDevice+Easy.h"

@implementation CIImage (Easy)

+ (CIImage *)QRCodeImageFromString:(NSString *)string
{
    // Need to convert the string to a UTF-8 encoded NSData object
    NSData *dara = [string dataUsingEncoding:NSUTF8StringEncoding];
    
    // Create the filter
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // Set the message content and error-correction level
    [filter setValue:dara forKey:@"inputMessage"];
    [filter setValue:@"H" forKey:@"inputCorrectionLevel"];
    
    // Send the image back
    return filter.outputImage;
}

- (UIImage *)nonInterpolatedUIImageWitiScale:(CGFloat)scale
{
    // Render the CIImage into a CGImage
    NSDictionary *options = nil;
    if (![UIDevice runningOnSimulator]) {
        options = @{kCIContextUseSoftwareRenderer: @(YES)};
    }
    CGImageRef cgImage = [[CIContext contextWithOptions:options] createCGImage:self fromRect:self.extent];
    
    // Now we'll rescale using CoreGraphics
    UIGraphicsBeginImageContext(CGSizeMake(self.extent.size.width * scale, self.extent.size.width * scale));
    CGContextRef context = UIGraphicsGetCurrentContext();
    // We don't want to interpolate (since we've got a pixel-correct image)
    CGContextSetInterpolationQuality(context, kCGInterpolationNone);
    CGContextDrawImage(context, CGContextGetClipBoundingBox(context), cgImage);
    // Get the image out
    UIImage *scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    // Tidy up
    UIGraphicsEndImageContext();
    CGImageRelease(cgImage);
    // Need to set the image orientation correctly
    UIImage *flippedImage = [UIImage imageWithCGImage:[scaledImage CGImage] scale:scaledImage.scale orientation:UIImageOrientationDownMirrored];
    
    return flippedImage;
}

@end
