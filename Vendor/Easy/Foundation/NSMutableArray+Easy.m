//
//  NSMutableArray+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import "NSMutableArray+Easy.h"

#import "Macro.h"

@implementation NSMutableArray (Easy)

- (void)addTheObject:(id)anObject
{
    @try {
        [self addObject:anObject];
    }
    @catch (NSException *exception) {
        ELog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

- (void)addTheObjectsFromArray:(NSArray *)array
{
    @try {
        [self addObjectsFromArray:array];
    }
    @catch (NSException *exception) {
        ELog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

@end
