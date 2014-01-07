//
//  NSManagedObject+Mapping.m
//  Easy
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "NSManagedObject+Mapping.h"

#import "NSObject+Mapping.h"
#import "NSManagedObjectContext+Easy.h"
#import "NSString+Easy.h"
#import "Macro.h"

//static char SortIDKey;
static char PropertyNamesMappingKey;

@interface NSManagedObject ()

@property (strong, nonatomic) NSMutableDictionary *propertyNamesMapping;

@end

@implementation NSManagedObject (Mapping)

#pragma mark - Private

- (NSMutableDictionary *)propertyNamesMapping
{
    return objc_getAssociatedObject(self, &PropertyNamesMappingKey);
}

- (void)setPropertyNamesMapping:(NSMutableDictionary *)propertyNamesMapping
{
    [self willChangeValueForKey:@"propertyNamesMapping"];
    objc_setAssociatedObject(self, &PropertyNamesMappingKey, propertyNamesMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"propertyNamesMapping"];
}

#pragma mark - Public

//- (NSString *)sortID
//{
//    return objc_getAssociatedObject(self, &SortIDKey);
//}
//
//- (void)setSortID:(NSString *)sortID
//{
//    [self willChangeValueForKey:@"sortID"];
//    objc_setAssociatedObject(self, &SortIDKey, sortID, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
//    [self didChangeValueForKey:@"sortID"];
//}

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSManagedObject *result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    @try {
        NSDictionary *properties = [[result entity] propertiesByName];
        for (NSString *key in properties) {
            id property = [properties objectForKey:key];
            NSString *sourceKey = [[result propertyNamesMapping] objectForKey:key];
            if (![sourceKey isKindOfClass:[NSString class]] || sourceKey.length == 0) {
                sourceKey = key;
            }
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType attributeType = [[properties objectForKey:key] attributeType];
                id value = [dictionary objectForKey:sourceKey];
                if (value == nil) {
                    // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
                    continue;
                }
                if ((attributeType == NSStringAttributeType) && ([value isKindOfClass:[NSNumber class]])) {
                    value = [value stringValue];
                } else if ((attributeType == NSDateAttributeType) && ([value isKindOfClass:[NSString class]])) {
                    value = [value dateValue];
                } else if (((attributeType == NSInteger16AttributeType) || (attributeType == NSInteger32AttributeType) || (attributeType == NSInteger64AttributeType) || (attributeType == NSBooleanAttributeType)) && ([value isKindOfClass:[NSString class]])) {
                    value = [NSNumber numberWithInteger:[value  integerValue]];
                } else if ((attributeType == NSFloatAttributeType) && ([value isKindOfClass:[NSString class]])) {
                    value = [NSNumber numberWithDouble:[value doubleValue]];
                }
//                else if ((attributeType == NSTransformableAttributeType) && ([value isKindOfClass:[NSDictionary class]])) {
//                    value = [property valueOfClass:[TheClass class] forJSONDictionary:value];
//                }
                [result setValue:value forKey:key];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                NSString *destinationEntityName = [destinationEntity name];
                id value = [dictionary objectForKey:sourceKey];
                if ([relationshipDescription isToMany]) {
                    if ([value isKindOfClass:[NSArray class]]) {
                        NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                        [result setValue:set forKey:key];
                    } else if ([value isKindOfClass:[NSDictionary class]]) {
                        NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                        [result setValue:set forKey:key];
                    }
                } else {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value insertIntoManagedObjectContext:context];
                        [result setValue:managedObject forKey:key];
                    } else if ([value isKindOfClass:[NSArray class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value[0] insertIntoManagedObjectContext:context];
                        [result setValue:managedObject forKey:key];
                    }
                }
            }
        }
        
        NSError *error = nil;
        [context save:&error];
        if (error) {
            DLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        return result;
    }
}

+ (NSSet *)managedObjectsOfClass:(Class)aClass forArray:(NSArray *)array insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *managedObjects = [NSMutableArray array];
    
    @try {
        NSUInteger count = [array count];
        for (NSUInteger counter = 0; counter < count; counter ++) {
            id object = [array objectAtIndex:counter];
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSManagedObject *managedObject = [aClass managedObjectForDictionary:object insertIntoManagedObjectContext:context];
                if (managedObject) {
                    [managedObjects addObject:managedObject];
                }
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        return [NSSet setWithArray:managedObjects];
    }
}

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey
{
    if (self.propertyNamesMapping == nil) {
        self.propertyNamesMapping = [NSMutableDictionary dictionary];
    }
    
    [self.propertyNamesMapping setValue:sourceKey forKey:key];
}

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context
{
    NSArray *existed = [context executeFetchEntityForManagedObjectClass:self];
    NSUInteger counter = 0;
    DLog(@"Found %lu items of %@ in total:", (unsigned long)existed.count, NSStringFromClass([self class]));
    for (NSManagedObject *object in existed) {
        DLog(@"%lu:\t%@", (unsigned long)counter, object);
        counter ++ ;
    }
}

- (void)logAll
{
    [[self class] logAllInManagedObjectContext:self.managedObjectContext];
}

- (NSDictionary *)dictionaryValue
{
    NSArray *allKeys = [[[self entity] propertiesByName] allKeys];
    return [self dictionaryWithValuesForKeys:allKeys];
}

@end