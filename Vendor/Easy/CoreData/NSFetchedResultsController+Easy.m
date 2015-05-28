//
//  NSFetchedResultsController+Easy.m
//  Easy
//
//  Created by Yang Jayce on 13-11-2.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSFetchedResultsController+Easy.h"
#import "Macro.h"

#pragma mark - NSFetchedResultsController

@interface NSFetchedResultsController ()

@end

@implementation NSFetchedResultsController (Easy)

#pragma mark - Fetch

- (BOOL)performFetch
{
    NSError *error;
    BOOL success = [self performFetch:&error];
    if (!success) {
        ELog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
//    ELog(@"Fetched %ld item of %@", (unsigned long)self.fetchedObjects.count, self.fetchRequest.entityName);
    return success;
}

- (id)objectAtTheIndexPath:(NSIndexPath *)indexPath {
    id result = nil;
    @try {
        result = [self objectAtIndexPath:indexPath];
    }
    @catch (NSException *exception) {
        ELog(@"%@",exception.reason);
    }
    @finally {
        return result;
    }
}

@end
