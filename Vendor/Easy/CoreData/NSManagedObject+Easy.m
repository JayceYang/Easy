//
//  NSManagedObject+Easy.m
//  DJIStore
//
//  Created by Jayce Yang on 14-2-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "NSManagedObject+Easy.h"

#import "CoreDataStore.h"
#import "NSManagedObjectContext+Easy.h"

@implementation NSManagedObject (Easy)

+ (instancetype)managedObjectWithoutManagedObjectContext {
    NSManagedObjectContext *managedObjectContext = [CoreDataStore mainQueueContext];
    NSString *entityName = NSStringFromClass([self class]);
    NSEntityDescription *entityDescription = [NSEntityDescription entityForName:entityName inManagedObjectContext:managedObjectContext];
    return [[self alloc] initWithEntity:entityDescription insertIntoManagedObjectContext:nil];
}

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate
{
    NSArray *existed = [context executeFetchManagedObjectForManagedObjectClass:self predicate:predicate];
    NSUInteger counter = 0;
    NSLog(@"Found %lu items of %@ in total:", (unsigned long)existed.count, NSStringFromClass([self class]));
    for (NSManagedObject *object in existed) {
        NSLog(@"%lu:\t%@", (unsigned long)counter, object);
        counter ++ ;
    }
}

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context
{
#if DEBUG
    NSArray *existed = [context executeFetchManagedObjectForManagedObjectClass:self];
    NSUInteger counter = 0;
    NSLog(@"Found %lu items of %@ in total:", (unsigned long)existed.count, NSStringFromClass([self class]));
    for (NSManagedObject *object in existed) {
        NSLog(@"%lu:\t%@", (unsigned long)counter, object);
        counter ++ ;
    }
#endif
}

- (void)logAll
{
    [[self class] logAllInManagedObjectContext:self.managedObjectContext];
}

@end
