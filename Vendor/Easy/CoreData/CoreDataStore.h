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

@property (copy, nonatomic) NSString *modelFileName;        //Default is CFBundleName

+ (instancetype)defaultStore;
- (void)reset;

+ (NSPersistentStoreCoordinator *)persistentStoreCoordinator;
+ (NSManagedObjectModel *)managedObjectModel;
+ (NSManagedObjectContext *)mainQueueContext;
+ (NSManagedObjectContext *)privateQueueContext;
+ (NSURL *)persistentStoreURL;

@end
