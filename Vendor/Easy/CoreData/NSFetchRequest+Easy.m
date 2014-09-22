//
//  NSFetchRequest+Easy.m
//  Sales
//
//  Created by Jayce Yang on 14-8-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <objc/runtime.h>

#import "NSFetchRequest+Easy.h"
#import "CoreDataStore.h"

static char NSFetchRequestWaterKey;
static char NSFetchRequestUpdatingHandlerKey;
static char NSFetchRequestDeletingHandlerKey;

@class NSFetchRequestWatcher;

@interface NSFetchRequest ()

@property (strong, nonatomic) NSFetchRequestWatcher *wather;
@property (copy, nonatomic) void (^updatingHandler)(NSFetchRequest *fetchRequest);
@property (copy, nonatomic) void (^deletingHandler)(NSFetchRequest *fetchRequest);

@end

@interface NSFetchRequestWatcher : NSObject

@property (weak, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (weak, nonatomic) NSFetchRequest *fetchRequest;
@property (strong, nonatomic) NSMutableSet *objectsToWatch;

@end

@implementation NSFetchRequestWatcher

- (instancetype)init
{
    NSAssert([NSThread isMainThread], @"Initialization must be on main thread");
    
    if (!(self = [super init])) return nil;
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(contextUpdated:) name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
    
    self.persistentStoreCoordinator = [CoreDataStore persistentStoreCoordinator];
    self.objectsToWatch = [NSMutableSet set];
    
    return self;
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NSManagedObjectContextObjectsDidChangeNotification object:nil];
}

- (void)contextUpdated:(NSNotification *)notification
{
    if ([[notification object] persistentStoreCoordinator] == [self persistentStoreCoordinator]) {
        if (self.fetchRequest.updatingHandler) {
            NSSet *objectsToWatch = [[notification userInfo] objectForKey:NSUpdatedObjectsKey];
            if ([[self objectsToWatch] intersectsSet:objectsToWatch]) {
                if ([NSThread isMainThread]) {
                    self.fetchRequest.updatingHandler(self.fetchRequest);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.fetchRequest.updatingHandler(self.fetchRequest);
                    });
                }
            }
        }
        
        if (self.fetchRequest.deletingHandler) {
            NSSet *objectsToWatch = [[notification userInfo] objectForKey:NSDeletedObjectsKey];
            if ([[self objectsToWatch] intersectsSet:objectsToWatch]) {
                if ([NSThread isMainThread]) {
                    self.fetchRequest.deletingHandler(self.fetchRequest);
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        self.fetchRequest.deletingHandler(self.fetchRequest);
                    });
                }
            }
        }
    }
}

@end

@implementation NSFetchRequest (Easy)

- (void)addUpdatingWatcherForManagedObjects:(NSArray *)objects handler:(void (^)(NSFetchRequest *fetchRequest))handler
{
    self.updatingHandler = handler;
    
    [self addObjectsToWatch:objects];
}

- (void)addDeletingWatcherForManagedObjects:(NSArray *)objects handler:(void (^)(NSFetchRequest *fetchRequest))handler;
{
    self.deletingHandler = handler;
    [self addObjectsToWatch:objects];
}

#pragma mark - Water

- (NSFetchRequestWatcher *)wather
{
    return objc_getAssociatedObject(self, &NSFetchRequestWaterKey);
}

- (void)setWather:(NSFetchRequestWatcher *)wather
{
    [self willChangeValueForKey:@"wather"];
    objc_setAssociatedObject(self, &NSFetchRequestWaterKey, wather, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"wather"];
}

#pragma mark - Updating & Deleting Handler

- (void (^)(NSFetchRequest *))updatingHandler
{
    return objc_getAssociatedObject(self, &NSFetchRequestUpdatingHandlerKey);
}

- (void)setUpdatingHandler:(void (^)(NSFetchRequest *))updatingHandler
{
    [self willChangeValueForKey:@"updatingHandler"];
    objc_setAssociatedObject(self, &NSFetchRequestUpdatingHandlerKey, updatingHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"updatingHandler"];
}

- (void (^)(NSFetchRequest *))deletingHandler
{
    return objc_getAssociatedObject(self, &NSFetchRequestDeletingHandlerKey);
}

- (void)setDeletingHandler:(void (^)(NSFetchRequest *))deletingHandler
{
    [self willChangeValueForKey:@"deletingHandler"];
    objc_setAssociatedObject(self, &NSFetchRequestDeletingHandlerKey, deletingHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"deletingHandler"];
}

#pragma mark - Private

- (void)addObjectsToWatch:(NSArray *)objects;
{
    if ([NSThread isMainThread]) {
        if (self.wather == nil) {
            self.wather = [[NSFetchRequestWatcher alloc] init];
            self.wather.fetchRequest = self;
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (self.wather == nil) {
                self.wather = [[NSFetchRequestWatcher alloc] init];
                self.wather.fetchRequest = self;
            }
        });
    }
    
    [[self.wather objectsToWatch] addObjectsFromArray:objects];
}

@end
