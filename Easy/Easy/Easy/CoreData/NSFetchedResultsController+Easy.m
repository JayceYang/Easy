//
//  NSFetchedResultsController+Easy.m
//  Easy
//
//  Created by Yang Jayce on 13-11-2.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSFetchedResultsController+Easy.h"

@implementation NSFetchedResultsController (Easy)

- (BOOL)performFetch
{
    NSError *error;
    BOOL success = [self performFetch:&error];
    if (!success) {
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return success;
}

@end
