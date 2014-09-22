//
//  NSManagedObject+Mapping.h
//  Easy
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Mapping)

/* 
 NSManagedObjectID is Thread Safety, and NSManagedObject is not Thread Safety 
 */
+ (NSManagedObjectID *)managedObjectIDForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;
+ (NSArray *)managedObjectIDsForArray:(NSArray *)array insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSDictionary *)dictionaryValue;
- (void)updateValuesForKeysWithDictionary:(NSDictionary *)keyedValues;

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey;

@end
