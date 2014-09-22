//
//  NSManagedObjectContext+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-7-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSManagedObjectContext+Easy.h"

@implementation NSManagedObjectContext (Easy)

- (NSArray *)objectsWithObjectIDs:(NSArray *)objectIDs
{
    if (!objectIDs || objectIDs.count == 0) {
        return nil;
    }
    __block NSMutableArray *objects = [[NSMutableArray alloc] initWithCapacity:objectIDs.count];
    
    [self performBlockAndWait:^{
        for (NSManagedObjectID *objectID in objectIDs) {
            if ([objectID isKindOfClass:[NSNull class]]) {
                continue;
            }
            
            [objects addObject:[self objectWithID:objectID]];
        }
    }];
    
    return objects.copy;
}

#pragma mark - Fetch ManagedObject IDs

- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:nil resultType:NSManagedObjectIDResultType];
}

- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:nil resultType:NSManagedObjectIDResultType];
}

- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:sortDescriptors resultType:NSManagedObjectIDResultType];
}

- (NSArray *)executeFetchManagedObjectIDsForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:sortDescriptors resultType:NSManagedObjectIDResultType];
}

#pragma mark - Fetch ManagedObject

- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:nil resultType:NSManagedObjectResultType];
}

- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:nil resultType:NSManagedObjectResultType];
}

- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:sortDescriptors resultType:NSManagedObjectResultType];
}

- (NSArray *)executeFetchManagedObjectForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    return [self executeFetchForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:sortDescriptors resultType:NSManagedObjectResultType];
}

#pragma mark - Fetch

- (NSArray *)executeFetchForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors resultType:(NSFetchRequestResultType)resultType
{
    __block NSArray *result = nil;
    
    if (managedObjectClass && [managedObjectClass isSubclassOfClass:[NSManagedObject class]]) {
        
//        [self performBlockAndWait:^{
            NSError *error = nil;
            
            NSString *entityName = NSStringFromClass(managedObjectClass);
            if (entityName.length > 0 && [NSEntityDescription entityForName:entityName inManagedObjectContext:self]) {
                NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
                fetchRequest.resultType = resultType;
                fetchRequest.predicate = predicate;
                fetchRequest.sortDescriptors = sortDescriptors;
                @try {
                    result = [self executeFetchRequest:fetchRequest error:&error];
                }
                @catch (NSException *exception) {
                    NSLog(@"%@",exception.reason);
                }
                @finally {
                    
                }
                
                if (error != nil) {
                    result = [NSArray array];
                    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                }
            } else {
                result = [NSArray array];
                NSLog(@"Entity %@ does not exist.", entityName);
            }
//        }];
    }
    
    return result.copy;
}

#pragma mark - Insert

- (id)insertNewObjectForEntityForManagedObjectClass:(Class)managedObjectClass
{
    id result = nil;
    if (managedObjectClass && [managedObjectClass isSubclassOfClass:[NSManagedObject class]]) {
        @try {
            result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(managedObjectClass) inManagedObjectContext:self];
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.reason);
        }
        @finally {
            
        }
    } else {
        
    }
    
    return result;
}

#pragma mark - Delete

- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass
{
    [self deleteObjectsForEntityForManagedObjectClass:managedObjectClass predicate:nil saveImmediately:NO];
}

- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass saveImmediately:(BOOL)saveImmediately
{
    [self deleteObjectsForEntityForManagedObjectClass:managedObjectClass predicate:nil saveImmediately:saveImmediately];
}

- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate
{
    [self deleteObjectsForEntityForManagedObjectClass:managedObjectClass predicate:predicate saveImmediately:NO];
}

- (void)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate saveImmediately:(BOOL)saveImmediately
{
    @try {
//        [self performBlockAndWait:^{
            NSArray *result = [self executeFetchManagedObjectForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:nil];
            if (result.count > 0) {
                for (NSManagedObject *managedObject in result) {
                    [self deleteObject:managedObject];
                }
                if (saveImmediately) {
                    NSError *error = nil;
                    [self save:&error];
                    if (error) {
                        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
                    }
                }
                
            }
//        }];
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

- (void)deleteObjectsForAllEntitiesForManagedObjectModel:(NSManagedObjectModel *)managedObjectModel
{
    [self deleteObjectsForAllEntitiesForManagedObjectModel:managedObjectModel saveImmediately:NO];
}

- (void)deleteObjectsForAllEntitiesForManagedObjectModel:(NSManagedObjectModel *)managedObjectModel saveImmediately:(BOOL)saveImmediately
{
    @try {
        NSArray *entities = managedObjectModel.entities;
//        NSLog(@"%@", entitiesByName);
        for (NSEntityDescription *entityDescription in entities) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = entityDescription;
            NSArray *result = [self executeFetchRequest:fetchRequest error:nil];
            
            for (NSManagedObject *managedObject in result) {
                [self deleteObject:managedObject];
            }
        }
        
        if (saveImmediately) {
            NSError *error = nil;
            if (error) {
                NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
        
    }
    @catch (NSException *exception) {
        NSLog(@"%@",exception.reason);
    }
    @finally {
        
    }
}

#pragma mark - Save

- (BOOL)save
{
    if (self.hasChanges) {
        NSError *error = nil;
        BOOL success = [self save:&error];
        if (error) {
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        return success;
    } else {
        return YES;
    }
}

@end
