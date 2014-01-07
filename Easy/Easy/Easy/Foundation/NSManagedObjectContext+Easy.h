//
//  NSManagedObjectContext+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-7-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObjectContext (Easy)

/*
 If an error occurs, returns or no objects match the criteria specified by request, returns an empty array.
 */
- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass;
- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate;
- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors;
- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors;

- (id)insertNewObjectForEntityForManagedObjectClass:(Class)managedObjectClass;

- (BOOL)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass;
- (BOOL)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate;

- (BOOL)deleteObjectsForAllEntities;

- (BOOL)save;

@end
