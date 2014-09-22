//
//  NSFetchedResultsController+Easy.m
//  Easy
//
//  Created by Yang Jayce on 13-11-2.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "NSFetchedResultsController+Easy.h"

static char FetchedResultsChangeHandlerKey;
static char FetchedResultsChangeWatherKey;

#pragma mark - FetchedResultsChangeWather

@interface FetchedResultsChangeWather : NSObject <NSFetchedResultsControllerDelegate>

@property (weak, nonatomic) NSFetchedResultsController *fetchedResultsController;

@end

@implementation FetchedResultsChangeWather

#pragma mark - NSFetchedResultsControllerDelegate

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type newIndexPath:(NSIndexPath *)newIndexPath
{
    if (self.fetchedResultsController.fetchedResultsChangeHandler) {
        self.fetchedResultsController.fetchedResultsChangeHandler(anObject, indexPath, type, newIndexPath);
    }
}

@end

#pragma mark - NSFetchedResultsController

@interface NSFetchedResultsController ()

@property (copy, nonatomic) FetchedResultsChangeHandler fetchedResultsChangeHandler;
@property (strong, nonatomic) FetchedResultsChangeWather *fetchedResultsChangeWather;

@end

@implementation NSFetchedResultsController (Easy)

#pragma mark - Configure fetchedResultsChangeWather

- (void)watchFetchedResultsChangeWithHandler:(FetchedResultsChangeHandler)handler
{
    if (self.fetchedResultsChangeWather == nil) {
        self.fetchedResultsChangeHandler = handler;
        self.fetchedResultsChangeWather = [[FetchedResultsChangeWather alloc] init];
        self.fetchedResultsChangeWather.fetchedResultsController = self;
        self.delegate = self.fetchedResultsChangeWather;
    }
}

- (void)unwatchFetchedResultsChange
{
    self.delegate = nil;
    self.fetchedResultsChangeWather = nil;
}

#pragma mark - Fetched Results Change Handler

- (FetchedResultsChangeHandler)fetchedResultsChangeHandler
{
    return objc_getAssociatedObject(self, &FetchedResultsChangeHandlerKey);
}

- (void)setFetchedResultsChangeHandler:(FetchedResultsChangeHandler)fetchedResultsChangeHandler
{
    [self willChangeValueForKey:@"fetchedResultsChangeHandler"];
    objc_setAssociatedObject(self, &FetchedResultsChangeHandlerKey, fetchedResultsChangeHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"fetchedResultsChangeHandler"];
}

#pragma mark - Fetched Results Change Wather

- (FetchedResultsChangeWather *)fetchedResultsChangeWather
{
    return objc_getAssociatedObject(self, &FetchedResultsChangeWatherKey);
}

- (void)setFetchedResultsChangeWather:(FetchedResultsChangeWather *)fetchedResultsChangeWather
{
    [self willChangeValueForKey:@"fetchedResultsChangeWather"];
    objc_setAssociatedObject(self, &FetchedResultsChangeWatherKey, fetchedResultsChangeWather, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"fetchedResultsChangeWather"];
}

#pragma mark - Fetch

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
