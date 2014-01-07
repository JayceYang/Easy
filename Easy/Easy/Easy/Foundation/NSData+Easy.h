//
//  NSData+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-7-31.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Easy)

- (NSString *)writeToFileDirectory:(NSString *)directory name:(NSString *)name extension:(NSString *)extension;

@end
