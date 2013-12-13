//
//  NSData+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-7-31.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (Easy)

- (NSString *)writeToFileDirectory:(NSString *)directory name:(NSString *)name extension:(NSString *)extension;

@end
