//
//  NSMutableArray+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
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
        DLog(@"%@",exception.reason);
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
        DLog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

@end
