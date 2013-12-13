//
//  NSObject+Mapping.h
//  Mapping
//
//  Created by Jayce Yang on 13-10-2.
//  Copyright (c) 2013年 Personal. All rights reserved.
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

- (void)setClass:(Class)aClass ofObjectsInArrayForKeyPath:(NSString *)path;

- (void)makeMappingForKeyPath:(NSString *)path toKeyPath:(NSString *)toPath;

- (id)valueOfClass:(Class)aClass forJSONDictionary:(NSDictionary *)dictionary;

- (id)valueOfClass:(Class)aClass forJSONArray:(NSArray *)array;

@end;