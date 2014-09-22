//
//  NSDictionary+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-10-15.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSDictionary+Easy.h"

#import "Macro.h"

@implementation NSDictionary (Easy)

- (id)objectForTreeStyleKey:(NSString *)key
{
    NSDictionary *result = nil;
    @try {
        NSArray *keys = [key componentsSeparatedByString:@"/"];
        NSDictionary *dictionary = [self copy];
        NSInteger count = [keys count];
        for (NSInteger n = 0; n < count - 1; n ++) {
            dictionary = [dictionary objectForKey:[keys objectAtIndex:n]];
        }
        result = [dictionary objectForKey:[keys objectAtIndex:count - 1]];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        return result;
    }
}

- (instancetype)mappingSourceKey:(NSString *)sourceKey withKey:(NSString *)targetKey
{
    NSMutableDictionary *result = [self mutableCopy];
    @try {
        result[targetKey] = result[sourceKey];
        [result removeObjectForKey:sourceKey];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        return [result mutableCopy];
    }
}

@end
