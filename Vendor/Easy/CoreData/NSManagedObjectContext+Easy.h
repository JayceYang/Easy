//
//  NSManagedObjectContext+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-7-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Easy)

- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs;

/*
 If an error occurs, returns or no objects match the criteria specified by request, returns an empty array.
 */

- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass;
- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate;
- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass;
- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate;
- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

- (id)insertNewObjectForEntityForManagedObjectClass:(Class)managedObjectClass;

- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass;
- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass saveImmediately:(BOOL)saveImmediately;
- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate;
- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate saveImmediately:(BOOL)saveImmediately;

- (void)deleteObjectsForAllEntitiesForManagedObjectModel:(NSManagedObjectModel *)managedObjectModel;
- (void)deleteObjectsForAllEntitiesForManagedObjectModel:(NSManagedObjectModel *)managedObjectModel saveImmediately:(BOOL)saveImmediately;

- (BOOL)save;

@end
