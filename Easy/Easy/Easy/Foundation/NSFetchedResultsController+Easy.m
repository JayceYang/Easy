//
//  NSFetchedResultsController+Easy.m
//  Easy
//
//  Created by Yang Jayce on 13-11-2.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSFetchedResultsController+Easy.h"

#import "Macro.h"

@implementation NSFetchedResultsController (Easy)

- (BOOL)performFetch
{
    NSError *error;
    BOOL success = [self performFetch:&error];
    if (!success) {
        /*
         Replace this implementation with code to handle the error appropriately.
         
         abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
         */
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        //        abort();
    }
    
    return success;
}

@end
