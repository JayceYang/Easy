//
//  NSData+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-7-31.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSData+Easy.h"

@implementation NSData (Easy)

- (NSString *)writeToFileDirectory:(NSString *)directory name:(NSString *)name extension:(NSString *)extension
{
    NSString *filePath = nil;
    if ([directory isKindOfClass:[NSString class]] && [name isKindOfClass:[NSString class]] && [extension isKindOfClass:[NSString class]]) {
        if (directory.length > 0 && name.length > 0 && extension.length > 0) {
            filePath = [directory stringByAppendingPathComponent:name];
            filePath = [filePath stringByAppendingPathExtension:extension];
            [self writeToFile:filePath atomically:YES];
        }
    }
    
    return filePath;
}

@end
