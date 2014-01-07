//
//  NSManagedObjectContext+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-7-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSManagedObjectContext+Easy.h"

#import "ApplicationInfo.h"
#import "Macro.h"

@implementation NSManagedObjectContext (Easy)

- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass
{
    return [self executeFetchEntityForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:nil];
}

- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate
{
    return [self executeFetchEntityForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:nil];
}

- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass sortDescriptors:(NSArray *)sortDescriptors
{
    return [self executeFetchEntityForManagedObjectClass:managedObjectClass predicate:nil sortDescriptors:sortDescriptors];
}

- (NSArray *)executeFetchEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate sortDescriptors:(NSArray *)sortDescriptors
{
    NSArray *result = nil;
    
    if (managedObjectClass && [managedObjectClass isSubclassOfClass:[NSManagedObject class]]) {
        NSError *error = nil;
        
        NSString *entityName = NSStringFromClass(managedObjectClass);
        if (entityName.length > 0 && [NSEntityDescription entityForName:entityName inManagedObjectContext:self]) {
            NSFetchRequest *fetchRequest = [NSFetchRequest fetchRequestWithEntityName:entityName];
            fetchRequest.predicate = predicate;
            fetchRequest.sortDescriptors = sortDescriptors;
            @try {
                result = [self executeFetchRequest:fetchRequest error:&error];
            }
            @catch (NSException *exception) {
                DLog(@"%@",exception.reason);
            }
            @finally {
                
            }
            
            if (error != nil) {
                result = [NSArray array];
                DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        } else {
            result = [NSArray array];
            DLog(@"Entity %@ does not exist.", entityName);
        }
    }
    
    return result;
}

- (id)insertNewObjectForEntityForManagedObjectClass:(Class)managedObjectClass
{
    id result = nil;
    if (managedObjectClass && [managedObjectClass isSubclassOfClass:[NSManagedObject class]]) {
        @try {
            result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass(managedObjectClass) inManagedObjectContext:self];
        }
        @catch (NSException *exception) {
            DLog(@"%@",exception.reason);
        }
        @finally {
            
        }
    } else {
        
    }
    
    return result;
}

//- (BOOL)insertTheObject:(NSManagedObject *)object
//{
//    BOOL success = NO;
//    if (object) {
//        @try {
//            [self insertObject:object];
//            
//            NSError *error = nil;
//            success = [self save:&error];
//            if (error) {
//                DLog(@"Unresolved error %@, %@", error, [error userInfo]);
//            }
//        }
//        @catch (NSException *exception) {
//            DLog(@"%@",exception.reason);
//        }
//        @finally {
//            
//        }
//    } else {
//        DLog(@"Nil object cann't be deleted.");
//    }
//}

- (BOOL)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass
{
    return [self deleteObjectsForEntityForManagedObjectClass:managedObjectClass predicate:nil];
}

- (BOOL)deleteObjectsForEntityForManagedObjectClass:(Class)managedObjectClass predicate:(NSPredicate *)predicate
{
    BOOL success = NO;
    
    @try {
        NSArray *result = [self executeFetchEntityForManagedObjectClass:managedObjectClass predicate:predicate sortDescriptors:nil];
        if (result.count > 0) {
            for (NSManagedObject *managedObject in result) {
                [self deleteObject:managedObject];
            }
            NSError *error = nil;
            success = [self save:&error];
            if (error) {
                DLog(@"Unresolved error %@, %@", error, [error userInfo]);
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception.reason);
    }
    @finally {
        
    }
    
    return success;
}

- (BOOL)deleteObjectsForAllEntities
{
    BOOL success = NO;
    
    @try {
        NSArray *entities = [ApplicationInfo sharedInfo].managedObjectModel.entities;
//        DLog(@"%@", entitiesByName);
        for (NSEntityDescription *entityDescription in entities) {
            NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
            fetchRequest.entity = entityDescription;
            NSArray *result = [self executeFetchRequest:fetchRequest error:nil];
            
            for (NSManagedObject *managedObject in result) {
                [self deleteObject:managedObject];
            }
        }
        
        NSError *error = nil;
        success = [self save:&error];
        if (error) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
        
        if (error == nil) {
            success = YES;
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@",exception.reason);
    }
    @finally {
        
    }
    
    return success;
}

- (BOOL)save
{
    NSError *error = nil;
    BOOL success = [self save:&error];
    if (error) {
        DLog(@"Unresolved error %@, %@", error, [error userInfo]);
    }
    
    return success;
}

@end
