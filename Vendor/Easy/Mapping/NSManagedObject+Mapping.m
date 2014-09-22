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

static char SourceKeyPathMappingKey;
static char TargetKeyPathMappingKey;

@interface NSManagedObject ()

@property (strong, nonatomic) NSMutableDictionary *sourcekeyPathMapping;
@property (strong, nonatomic) NSMutableDictionary *targetKeyPathMapping;

@end

@implementation NSManagedObject (Mapping)

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
    
    [result safeSetValuesForKeysWithDictionary:dictionary];
    
    return result;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    @try {
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            id property = [properties objectForKey:propertyName];
            NSString *targetKey = [[self targetKeyPathMapping] objectForKey:propertyName];
            if (![targetKey isKindOfClass:[NSString class]] || targetKey.length == 0) {
                targetKey = propertyName;
            }
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
                [result setValue:value forKey:targetKey];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                id value = [self valueForKey:propertyName];
                if (value == nil) {
                    // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
                    continue;
                }
                if ([relationshipDescription isToMany]) {
                    NSMutableArray *toMany = [NSMutableArray array];
                    if ([value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSOrderedSet class]]) {
                        for (NSManagedObject *entity in value) {
                            NSDictionary *dictionary = [entity dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                            if (dictionary.count > 0) {
                                [toMany addObject:dictionary];
                            }
                        }
                    }
                    if (toMany.count > 0) {
                        [result setValue:toMany forKey:targetKey];
                    }
                } else {
                    NSDictionary *dictionary = [value dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                    if (dictionary.count > 0) {
                        [result setValue:dictionary forKey:targetKey];
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

- (void)updateValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    [self safeSetValuesForKeysWithDictionary:keyedValues];
}

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey
{
    if (self.sourcekeyPathMapping == nil) {
        self.sourcekeyPathMapping = [NSMutableDictionary dictionary];
    }
    
    [self.sourcekeyPathMapping setValue:sourceKey forKey:key];
}

- (void)makePropertyNamesMappingForKey:(NSString *)key targetKey:(NSString *)targetKey
{
    if (self.targetKeyPathMapping == nil) {
        self.targetKeyPathMapping = [NSMutableDictionary dictionary];
    }
    
    [self.targetKeyPathMapping setValue:targetKey forKey:key];
}

#pragma mark - Names Mapping

- (NSMutableDictionary *)sourcekeyPathMapping
{
    return objc_getAssociatedObject(self, &SourceKeyPathMappingKey);
}

- (void)setSourcekeyPathMapping:(NSMutableDictionary *)sourcekeyPathMapping
{
    [self willChangeValueForKey:@"sourcekeyPathMapping"];
    objc_setAssociatedObject(self, &SourceKeyPathMappingKey, sourcekeyPathMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"sourcekeyPathMapping"];
}

- (NSMutableDictionary *)targetKeyPathMapping
{
    return objc_getAssociatedObject(self, &TargetKeyPathMappingKey);
}

- (void)setTargetKeyPathMapping:(NSMutableDictionary *)targetKeyPathMapping
{
    [self willChangeValueForKey:@"targetKeyPathMapping"];
    objc_setAssociatedObject(self, &TargetKeyPathMappingKey, targetKeyPathMapping, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"targetKeyPathMapping"];
}

#pragma mark - Private

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

- (NSDictionary *)dictionaryValueIgnoreRelationship:(NSRelationshipDescription *)relationship
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    @try {
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            id property = [properties objectForKey:propertyName];
            NSString *targetKey = [[self targetKeyPathMapping] objectForKey:propertyName];
            if (![targetKey isKindOfClass:[NSString class]] || targetKey.length == 0) {
                targetKey = propertyName;
            }
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
                [result setValue:value forKey:targetKey];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                NSString *destinationEntityName = [destinationEntity name];
                if (![destinationEntityName isEqualToString:[[relationship destinationEntity] name]]) {
                    id value = [self valueForKey:propertyName];
                    if (value == nil) {
                        // Don't attempt to set nil, or you'll overwite values in self that aren't present in keyedValues
                        continue;
                    }
                    if ([relationshipDescription isToMany]) {
                        NSMutableArray *toMany = [NSMutableArray array];
                        if ([value isKindOfClass:[NSSet class]] || [value isKindOfClass:[NSOrderedSet class]]) {
                            for (NSManagedObject *entity in value) {
                                NSDictionary *dictionary = [entity dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                                if (dictionary.count > 0) {
                                    [toMany addObject:dictionary];
                                }
                            }
                        }
                        if (toMany.count > 0) {
                            [result setValue:toMany forKey:targetKey];
                        }
                    } else {
                        NSDictionary *dictionary = [value dictionaryValueIgnoreRelationship:[relationshipDescription inverseRelationship]];
                        if (dictionary.count > 0) {
                            [result setValue:dictionary forKey:targetKey];
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

#pragma mark - Core

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    @try {
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *key in properties) {
            id property = [properties objectForKey:key];
            NSString *sourceKey = [[self sourcekeyPathMapping] objectForKey:key];
            if (![sourceKey isKindOfClass:[NSString class]] || sourceKey.length == 0) {
                sourceKey = key;
            }
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType attributeType = [[properties objectForKey:key] attributeType];
                id value = [keyedValues objectForKey:sourceKey];
                if (value == nil || [value isKindOfClass:[NSNull class]]) {
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
                [self setValue:value forKey:key];
            } else if ([property isKindOfClass:[NSRelationshipDescription class]]) {
                NSRelationshipDescription *relationshipDescription = property;
                NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                NSString *destinationEntityName = [destinationEntity name];
                id value = [keyedValues objectForKey:sourceKey];
                if ([relationshipDescription isToMany]) {
                    if ([value isKindOfClass:[NSArray class]]) {
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [NSManagedObject orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:key];
                        } else {
                            NSSet *set = [NSManagedObject managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:key];
                        }
                    } else if ([value isKindOfClass:[NSDictionary class]]) {
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [NSManagedObject orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:key];
                        } else {
                            NSSet *set = [NSManagedObject managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:key];
                        }
                    }
                } else {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value insertIntoManagedObjectContext:context];
                        [self setValue:managedObject forKey:key];
                    } else if ([value isKindOfClass:[NSArray class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value[0] insertIntoManagedObjectContext:context];
                        [self setValue:managedObject forKey:key];
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
        
    }
}

@end
