//
//  NSManagedObject+Mapping.m
//  Easy
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSManagedObject+Mapping.h"

#import "NSObject+Mapping.h"

@interface EntityMapping ()

@property (strong, nonatomic) NSMutableDictionary *mappingAttributes;
@property (strong, nonatomic) NSMutableDictionary *transparentAttributes;
@property (strong, nonatomic) NSMutableDictionary *transparentRelationshipsDuringSerialization;
@property (strong, nonatomic) NSMutableDictionary *transparentAllRelationshipsDuringSerialization;
@property (strong, nonatomic) NSMutableDictionary *includeRelationshipsDuringDeserialization;
@property (strong, nonatomic) NSMutableDictionary *includeAllRelationshipsDuringDeserialization;

@end

@interface NSManagedObject ()

@end

@implementation NSManagedObject (Mapping)

#pragma mark - Public

#pragma mark - Serialization

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    
    @try {
        // Skip all relationships
        BOOL transparentAll = [[[[EntityMapping sharedMapping] transparentAllRelationshipsDuringSerialization] objectForKey:NSStringFromClass([self class])] boolValue];
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            // Skip transparent attribute
            BOOL transparent = [[[[[EntityMapping sharedMapping] transparentAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
            if (transparent) {
                continue;
            }
            id property = [properties objectForKey:propertyName];
            NSString *targetKey = [[[[EntityMapping sharedMapping] mappingAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName];
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
            } else if (!transparentAll && [property isKindOfClass:[NSRelationshipDescription class]]) {
                // Skip transparent relationship
                BOOL transparent = [[[[[EntityMapping sharedMapping] transparentRelationshipsDuringSerialization] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
                if (transparent) {
                    continue;
                }
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
        return [result copy];
    }
}

#pragma mark - Deserialization

+ (NSManagedObjectID *)managedObjectIDForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    return [[self managedObjectForDictionary:dictionary insertIntoManagedObjectContext:context] objectID];
}

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context {
    NSManagedObject *result = [NSEntityDescription insertNewObjectForEntityForName:NSStringFromClass([self class]) inManagedObjectContext:context];
    
    [result safeSetValuesForKeysWithDictionary:dictionary];
    
    return result;
}

- (void)updateValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    [self safeSetValuesForKeysWithDictionary:keyedValues];
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
        // Skip all relationships
        BOOL transparentAll = [[[[EntityMapping sharedMapping] transparentAllRelationshipsDuringSerialization] objectForKey:NSStringFromClass([self class])] boolValue];
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            // Skip transparent attribute
            BOOL transparent = [[[[[EntityMapping sharedMapping] transparentAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
            if (transparent) {
                continue;
            }
            id property = [properties objectForKey:propertyName];
            NSString *targetKey = [[[[EntityMapping sharedMapping] mappingAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName];
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
            } else if (!transparentAll && [property isKindOfClass:[NSRelationshipDescription class]]) {
                // Skip transparent relationship
                BOOL transparent = [[[[[EntityMapping sharedMapping] transparentRelationshipsDuringSerialization] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
                if (transparent) {
                    continue;
                }
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
        return [result copy];
    }
}

#pragma mark - Core

- (void)safeSetValuesForKeysWithDictionary:(NSDictionary *)keyedValues
{
    NSManagedObjectContext *context = self.managedObjectContext;
    
    @try {
        // Include all relationships
        BOOL includeAll = [[[[EntityMapping sharedMapping] includeAllRelationshipsDuringDeserialization] objectForKey:NSStringFromClass([self class])] boolValue];
        NSDictionary *properties = [[self entity] propertiesByName];
        for (NSString *propertyName in properties) {
            // Skip transparent attribute
            BOOL transparent = [[[[[EntityMapping sharedMapping] transparentAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
            if (transparent) {
                continue;
            }
            id property = [properties objectForKey:propertyName];
            NSString *sourceKey = [[[[EntityMapping sharedMapping] mappingAttributes] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName];
            if (![sourceKey isKindOfClass:[NSString class]] || sourceKey.length == 0) {
                sourceKey = propertyName;
            }
            if ([property isKindOfClass:[NSAttributeDescription class]]) {
                NSAttributeType attributeType = [[properties objectForKey:propertyName] attributeType];
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
                [self setValue:value forKey:propertyName];
            } else if (includeAll && [property isKindOfClass:[NSRelationshipDescription class]]) {
                
                // Include certain relationship
                BOOL include = [[[[[EntityMapping sharedMapping] includeRelationshipsDuringDeserialization] objectForKey:NSStringFromClass([self class])] objectForKey:propertyName] boolValue];
                if (!include) {
                    continue;
                }
                NSRelationshipDescription *relationshipDescription = property;
                NSEntityDescription *destinationEntity = [relationshipDescription destinationEntity];
                NSString *destinationEntityName = [destinationEntity name];
                id value = [keyedValues objectForKey:sourceKey];
                if ([relationshipDescription isToMany]) {
                    if ([value isKindOfClass:[NSArray class]]) {
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [NSManagedObject orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:propertyName];
                        } else {
                            NSSet *set = [NSManagedObject managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:value insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:propertyName];
                        }
                    } else if ([value isKindOfClass:[NSDictionary class]]) {
                        if ([relationshipDescription isOrdered]) {
                            NSOrderedSet *set = [NSManagedObject orderedManagedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:propertyName];
                        } else {
                            NSSet *set = [NSManagedObject managedObjectsOfClass:NSClassFromString(destinationEntityName) forArray:@[value] insertIntoManagedObjectContext:context];
                            [self setValue:set forKey:propertyName];
                        }
                    }
                } else {
                    if ([value isKindOfClass:[NSDictionary class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value insertIntoManagedObjectContext:context];
                        [self setValue:managedObject forKey:propertyName];
                    } else if ([value isKindOfClass:[NSArray class]]) {
                        NSManagedObject *managedObject = [NSClassFromString(destinationEntityName) managedObjectForDictionary:value[0] insertIntoManagedObjectContext:context];
                        [self setValue:managedObject forKey:propertyName];
                    }
                }
            }
        }
        
//        NSError *error = nil;
//        [context save:&error];
//        if (error) {
//            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
//        }
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

@end

#pragma mark - Entity mapping configureration

@implementation EntityMapping

- (instancetype)init {
    self = [super init];
    if (self) {
        // Initialization code
        self.mappingAttributes = [NSMutableDictionary dictionary];
        self.transparentAttributes = [NSMutableDictionary dictionary];
        self.transparentRelationshipsDuringSerialization = [NSMutableDictionary dictionary];
        self.transparentAllRelationshipsDuringSerialization = [NSMutableDictionary dictionary];
        self.includeRelationshipsDuringDeserialization = [NSMutableDictionary dictionary];
        self.includeAllRelationshipsDuringDeserialization = [NSMutableDictionary dictionary];
    }
    return self;
}

+ (instancetype)sharedMapping {
    static EntityMapping *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)mappingEntityName:(NSString *)name attributes:(NSDictionary *)attributes {
    [self.mappingAttributes setValue:attributes forKey:name];
}

- (void)makeAttributeTransparentForEntityName:(NSString *)entityName attributeName:(NSString *)attributeName {
    [self.transparentAttributes setValue:@{attributeName: @(YES)} forKey:entityName];
}

- (void)makeRelationshipTransparentDuringSerializationForEntityName:(NSString *)entityName relationshipName:(NSString *)relationshipName {
    [self.transparentRelationshipsDuringSerialization setValue:@{relationshipName: @(YES)} forKey:entityName];
}

- (void)makeAllRelationshipsTransparentDuringSerializationForEntityName:(NSString *)entityName {
    [self.transparentAllRelationshipsDuringSerialization setValue:@(YES) forKey:entityName];
}

- (void)makeRelationshipIncludedDuringDeserializationForEntityName:(NSString *)entityName relationshipName:(NSString *)relationshipName {
    [self.includeRelationshipsDuringDeserialization setValue:@{relationshipName: @(YES)} forKey:entityName];
}

- (void)makeAllRelationshipsIncludedDuringDeserializationForEntityName:(NSString *)entityName {
    [self.includeAllRelationshipsDuringDeserialization setValue:@(YES) forKey:entityName];
}

@end
