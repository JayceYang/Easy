//
//  NSMutableDictionary+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-8-7.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableDictionary (Easy)

- (void)removeObjectsExceptForKeys:(NSArray *)array;
- (void)removeObjectsExceptForKeysContainsTheString:(NSString *)string;
- (void)removeObjectsExceptForKeysInGroup:(NSArray *)group;

@end
