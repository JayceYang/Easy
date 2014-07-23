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

+ (NSManagedObjectID *)managedObjectIDForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    return [[self managedObjectForDictionary:dictionary insertIntoManagedObjectContext:context] objectID];
}

+ (NSArray *)managedObjectIDsForArray:(NSArray *)array insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    NSMutableArray *result = [@[] mutableCopy];
    @try {
        for (NSDictionary *dictionary in array) {
            NSManagedObjectID *managedObjectID = [self managedObjectIDForDictionary:dictionary insertIntoManagedObjectContext:context];
            [result addObject:managedObjectID];
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return [result copy];
    }
}

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
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [self orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        } else {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        }
                    } else if ([value isKindOfClass:[NSDictionary class]]) {
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [self orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        } else {
                            NSSet *set = [self managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [result setValue:set forKey:key];
                        }
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
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
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
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return [NSSet setWithArray:managedObjects];
    }
}

+ (NSOrderedSet *)orderedManagedObjectsOfClass:(Class)aClass forArray:(NSArray *)array insertIntoManagedObjectContext:(NSManagedObjectContext *)context
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
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return [NSOrderedSet orderedSetWithArray:managedObjects];
    }
}

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey
{
    if (self.propertyNamesMapping == nil) {
        self.propertyNamesMapping = [NSMutableDictionary dictionary];
    }
    
    [self.propertyNamesMapping setValue:sourceKey forKey:key];
}

- (NSDictionary *)dictionaryValueIgnoreRelationship:(NSRelationshipDescription *)relationship
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    @try {
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            id property = [properties objectForKey:propertyName];
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType attributeType = [property attributeType];
                id value = [self valueForKey:propertyName];
                if (value == nil) {
                    // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
                    continue;
                }
                if (attributeType == NSDateAttributeType) {
                    value = [value stringValue];
                }
                [result setValue:value forKey:propertyName];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                NSString *destinationEntityName = [destinationEntity name];
                if (![destinationEntityName isEqualToString:[[relationship destinationEntity] name]]) {
                    id value = [self valueForKey:propertyName];
                    if ([relationshipDescription isToMany]) {
                        NSMutableArray *toMany = [NSMutableArray array];
                        if ([value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSOrderedSet class]]) {
                            for (NSManagedObject *entity in value) {
                                NSDictionary *dictionary = [entity dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                                if (dictionary) {
                                    [toMany addObject:dictionary];
                                }
                            }
                        }
                        [result setValue:toMany forKey:propertyName];
                    } else {
                        NSDictionary *dictionary = [value dictionaryValue];
                        if (dictionary) {
                            [result setValue:dictionary forKey:propertyName];
                        }
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return [result mutableCopy];
    }
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    @try {
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            id property = [properties objectForKey:propertyName];
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType attributeType = [property attributeType];
                id value = [self valueForKey:propertyName];
                if (value == nil) {
                    // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
                    continue;
                }
                if (attributeType == NSDateAttributeType) {
                    value = [value stringValue];
                }
                [result setValue:value forKey:propertyName];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                id value = [self valueForKey:propertyName];
                if ([relationshipDescription isToMany]) {
                    NSMutableArray *toMany = [NSMutableArray array];
                    if ([value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSOrderedSet class]]) {
                        for (NSManagedObject *entity in value) {
                            NSDictionary *dictionary = [entity dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                            if (dictionary) {
                                [toMany addObject:dictionary];
                            }
                        }
                    }
                    [result setValue:toMany forKey:propertyName];
                } else {
                    NSDictionary *dictionary = [value dictionaryValue];
                    if (dictionary) {
                        [result setValue:dictionary forKey:propertyName];
                    }
                }
            }
        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return [result mutableCopy];
    }
    
//    NSArray *allKeys = [[[self entity] propertiesByName] allKeys];
//    return [self dictionaryWithValuesForKeys:allKeys];
}

@end
