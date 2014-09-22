//
//  NSMutableDictionary+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-8-7.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSMutableDictionary+Easy.h"

#import "Macro.h"

@implementation NSMutableDictionary (Easy)

- (void)removeObjectsExceptForKeys:(NSArray *)array
{
    if (array.count > 0) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"(any NOT IN [cd] %@)",array];
        NSArray *toBeRemoved = [self.allKeys filteredArrayUsingPredicate:predicate];
        @try {
            [self removeObjectsForKeys:toBeRemoved];
        }
        @catch (NSException *exception) {
            ELog(@"%@", exception.reason);
        }
        @finally {
            
        }
    }
}

- (void)removeObjectsExceptForKeysContainsTheString:(NSString *)string
{
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF CONTAINS %@)", string];
        NSArray *toBeRemoved = [self.allKeys filteredArrayUsingPredicate:predicate];
        [self removeObjectsForKeys:toBeRemoved];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

- (void)removeObjectsExceptForKeysInGroup:(NSArray *)group
{
    @try {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"NOT (SELF IN %@)", group];
        NSArray *toBeRemoved = [self.allKeys filteredArrayUsingPredicate:predicate];
        [self removeObjectsForKeys:toBeRemoved];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

@end
