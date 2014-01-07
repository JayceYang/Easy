//
//  NSObject+Mapping.h
//  Easy
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Mapping)

@property (readonly, copy, nonatomic) NSString *propertyIndex;

+ (NSSortDescriptor *)sortDescriptorForPropertyIndex;

- (NSDictionary *)propertyDictionary;
- (NSDictionary *)dictionaryValue;

/* 
 JSON
 */
- (NSData *)JSONData;

- (NSString *)JSONString;

/*
 Mapping for certain keys
 */
- (void)setClass:(Class)aClass ofObjectsInArrayForKeyPath:(NSString *)path;

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey;

/*
 Object Mapping
 */
- (id)valueOfClass:(Class)aClass forJSONDictionary:(NSDictionary *)dictionary;

- (NSArray *)valueOfClass:(Class)aClass forJSONArray:(NSArray *)array;

@end
