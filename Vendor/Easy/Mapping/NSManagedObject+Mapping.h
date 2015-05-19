//
//  NSManagedObject+Mapping.h
//  Easy
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Mapping)

#pragma mark - Serialization

- (NSDictionary *)dictionaryValue;

#pragma mark - Deserialization

/*
 NSManagedObjectID is Thread Safety, and NSManagedObject is not Thread Safety 
 */

+ (NSManagedObjectID *)managedObjectIDForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (void)updateValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

@end

@interface EntityMapping : NSObject

+ (instancetype)sharedMapping;

/*
 name:
    The name of an entity.
 attributes:
    Mapping dictonary,and the key will be entity's property name, value will be the 'key' of data source.For example,@{@"identity": @"id"}
 */
- (void)mappingEntityName:(NSString *)name attributes:(NSDictionary *)attributes;

/*
 Ignore certain attribute as well as relationship during serialization and deserialization
 */
- (void)makeAttributeTransparentForEntityName:(NSString *)entityName attributeName:(NSString *)attributeName;

/*
 Ignore certain relationship during serialization
 */
- (void)makeRelationshipTransparentDuringSerializationForEntityName:(NSString *)entityName relationshipName:(NSString *)relationshipName;

/*
 Ignore all relationships during serialization
 */
- (void)makeAllRelationshipsTransparentDuringSerializationForEntityName:(NSString *)entityName;

/*
 Included certain relationship during deserialization
 */
- (void)makeRelationshipIncludedDuringDeserializationForEntityName:(NSString *)entityName relationshipName:(NSString *)relationshipName;

/*
 Included all relationships during deserialization
 */
- (void)makeAllRelationshipsIncludedDuringDeserializationForEntityName:(NSString *)entityName;

@end