//
//  NSFetchedResultsController+Easy.h
//  Easy
//
//  Created by Yang Jayce on 13-11-2.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

typedef void (^FetchedResultsChangeHandler)(id changedObject, NSIndexPath *indexPath, NSFetchedResultsChangeType type, NSIndexPath *newIndexPath);

@interface NSFetchedResultsController (Easy)

@property (readonly, copy, nonatomic) FetchedResultsChangeHandler fetchedResultsChangeHandler;

- (void)watchFetchedResultsChangeWithHandler:(FetchedResultsChangeHandler)handler;
- (void)unwatchFetchedResultsChange;

- (BOOL)performFetch;

@end
