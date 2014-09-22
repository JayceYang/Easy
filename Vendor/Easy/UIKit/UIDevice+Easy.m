//
//  UIDevice+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-10-24.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "UIDevice+Easy.h"

@implementation UIDevice (Easy)

+ (NSString *)currentModel
{
    NSString *result = nil;
    if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone) {
        result = @"IPHONE";
    } else {
        result = @"IPAD";
    }
    
    return result;
}

- (NSString *)UUIDString
{
    CFUUIDRef UUIDRef = CFUUIDCreate(kCFAllocatorDefault);
    NSString *result = CFBridgingRelease(CFUUIDCreateString(kCFAllocatorDefault, UUIDRef));
    CFRelease(UUIDRef);
    return result;
}

@end
