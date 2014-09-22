//
//  NSSet+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-10-22.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSSet+Easy.h"

#import "NSArray+Easy.h"

@implementation NSSet (Easy)

- (NSArray *)sortedArrayUsingIndexOfWSDL
{
    return [[self allObjects] sortedArrayUsingIndexOfWSDL];
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path
{
    return [[self allObjects] sortedArrayUsingKeyPath:path];
}

- (NSArray *)sortedArrayUsingKeyPath:(NSString *)path ascending:(BOOL)ascending
{
    return [[self allObjects] sortedArrayUsingKeyPath:path ascending:ascending];
}

@end
