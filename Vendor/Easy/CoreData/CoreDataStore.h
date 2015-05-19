//
//  CoreDataStore.h
//  Store
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "NSFetchedResultsController+Easy.h"
#import "NSManagedObject+Easy.h"
#import "NSManagedObjectContext+Easy.h"
#import "NSFetchRequest+Easy.h"

@interface CoreDataStore : NSObject

@property (readonly, nonatomic) NSUInteger referenceCount;
@property (readonly, nonatomic) NSCondition *referenceCountCondition;

+ (instancetype)defaultStore;

- (void)setup;
- (void)clean;
- (void)destroy;
- (void)reset;  // Calls 'destroy' first, and then calls 'setup'

+ (dispatch_queue_t)privateQueue;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;
+ (NSManagedObjectContext *)newMainQueueContext;
+ (NSManagedObjectContext *)newPrivateQueueContext;
+ (NSURL *)persistentStoreURL;

@end
