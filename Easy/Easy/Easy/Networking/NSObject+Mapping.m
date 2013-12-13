//  NSObject+Mapping.h
//  Mapping
//
//  Created by Jayce Yang on 13-10-2.
//  Copyright (c) 2013年 Personal. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Mapping.h"

#import "NSDate+Easy.h"
#import "NSString+Easy.h"
#import "Macro.h"

static char ClassNamesInArrayKey;
static char KeyPathMappingKey;
static char PropertyIndexKey;
//static char DateFormatKey;

//static NSString *DefaultDateFormat = @"yyyy-MM-dd HH:mm:ss";

@interface NSObject (MappingPrivate)

@property (strong, nonatomic) NSMutableDictionary *classNamesInArray;
@property (strong, nonatomic) NSMutableDictionary *keyPathMapping;
@property (copy, nonatomic) NSNumber *propertyIndex;

//- (BOOL)JSONTypeObject;

@end

@implementation NSObject (MappingPrivate)

- (NSMutableDictionary *)classNamesInArray
{
    return objc_getAssociatedObject(self, &ClassNamesInArrayKey);
}

- (void)setClassNamesInArray:(NSMutableDictionary *)classNamesInArray
{
    [self willChangeValueForKey:@"classNamesInArray"];
    objc_setAssociatedObject(self, &ClassNamesInArrayKey, classNamesInArray, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"classNamesInArray"];
}

- (NSMutableDictionary *)keyPathMapping
{
    return objc_getAssociatedObject(self, &KeyPathMappingKey);
}

- (void)setKeyPathMapping:(NSMutableDictionary *)keyPathMapping
{
    [self willChangeValueForKey:@"keyPathMapping"];
    objc_setAssociatedObject(self, &KeyPathMappingKey, keyPathMapping, OBJC_ASSOCIATION_RETAIN);
    [self didChangeValueForKey:@"keyPathMapping"];
}

- (NSString *)propertyIndex
{
    return objc_getAssociatedObject(self, &PropertyIndexKey);
}

- (void)setPropertyIndex:(NSString *)propertyIndex
{
    [self willChangeValueForKey:@"propertyIndex"];
    objc_setAssociatedObject(self, &PropertyIndexKey, propertyIndex, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"propertyIndex"];
}

//- (NSString *)dateFormat
//{
//    return objc_getAssociatedObject(self, &DateFormatKey);
//}
//
//- (void)setDateFormat:(NSString *)dateFormat
//{
//    [self willChangeValueForKey:@"dateFormat"];
//    objc_setAssociatedObject(self, &DateFormatKey, dateFormat, OBJC_ASSOCIATION_COPY_NONATOMIC);
//    [self didChangeValueForKey:@"dateFormat"];
//}

//- (BOOL)JSONTypeObject
//{
//    return ([self isKindOfClass:[NSString class]] || [self isKindOfClass:[NSNumber class]]);
//}

@end

@interface NSArray (Mapping)

- (NSArray *)makeObjectsDictionaryValue;

@end

@implementation NSArray (Mapping)

- (NSArray *)makeObjectsDictionaryValue
{
    NSMutableArray *result = [NSMutableArray array];
    
    @try {
        for (NSUInteger counter = 0; counter < self.count; counter ++) {
            @autoreleasepool {
                id object = [self objectAtIndex:counter];
                
                if ([object isKindOfClass:[NSArray class]]) {
                    [result addObject:[object makeObjectsDictionaryValue]];
                } else if ([object isKindOfClass:[NSDate class]]){
                    [result addObject:[object stringValue]];
                } else if ([object isKindOfClass:[NSString class]]){
                    [result addObject:[NSString stringWithFormat:@"\"%@\"", object]];
                } else if ([object isKindOfClass:[NSNumber class]]) {
                    [result addObject:object];
                } else {
                    [result addObject:[object dictionaryValue]];
                }
            }
        }
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        return result;
    }
}

@end


@implementation NSObject (Mapping)

+ (NSSortDescriptor *)sortDescriptorForPropertyIndex
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"propertyIndex" ascending:YES];
    
    return sortDescriptor;
}

- (NSDictionary *)dictionaryValue
{
    NSMutableDictionary *dictionary = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (NSUInteger counter = 0; counter < count; counter ++) {
        @autoreleasepool {
            
            NSString *key = [NSString stringWithUTF8String:property_getName(properties[counter])];
            key.propertyIndex = [NSNumber numberWithInteger:counter];
            id value = [self valueForKey:key];
//            DLog(@"%@:\t%@", key, NSStringFromClass([value class]));
            if ([value isKindOfClass:[NSArray class]]) {
                [dictionary setValue:[value makeObjectsDictionaryValue] forKey:key];
            } else if ([value isKindOfClass:[NSDate class]]){
                [dictionary setValue:[value stringValue] forKey:key];
            } else if ([value isKindOfClass:[NSString class]]){
                [dictionary setValue:value forKey:key];
            }  else if ([value isKindOfClass:[NSNumber class]]) {
                [dictionary setValue:value forKey:key];
            } else if ([value isKindOfClass:[NSData class]]){
                [dictionary setValue:[[NSString alloc] initWithData:value encoding:NSUTF8StringEncoding] forKey:key];
            } else if ([value isKindOfClass:[NSNull class]]){
                [dictionary setValue:nil forKey:key];
            } else {
                [dictionary setValue:[value dictionaryValue] forKey:key];
            }
        }
    }
    
    free(properties);
    
    return [NSDictionary dictionaryWithDictionary:dictionary];
}

- (NSData *)JSONData
{
    NSDictionary *dictionary = [self dictionaryValue];
    return [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
}

- (NSString *)JSONString
{
    NSDictionary *dictionary = [self dictionaryValue];
    NSData *data = [NSJSONSerialization dataWithJSONObject:dictionary options:NSJSONWritingPrettyPrinted error:nil];
    return [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
}

- (void)setClass:(Class)aClass ofObjectsInArrayForKeyPath:(NSString *)path
{
    if (self.classNamesInArray == nil) {
        self.classNamesInArray = [NSMutableDictionary dictionary];
    }
    
    [self.classNamesInArray setValue:NSStringFromClass(aClass) forKey:path];
}

- (void)makeMappingForKeyPath:(NSString *)path toKeyPath:(NSString *)toPath
{
    if (self.keyPathMapping == nil) {
        self.keyPathMapping = [NSMutableDictionary dictionary];
    }
    
    [self.keyPathMapping setValue:path forKey:toPath];
}

- (id)valueOfClass:(Class)aClass forJSONDictionary:(NSDictionary *)dictionary
{
    id result = [[aClass alloc] init];
    NSDictionary *mapDictionary = [result propertyDictionary];
    
    for (NSString *key in [dictionary allKeys]) {
        @autoreleasepool {
            
            NSString *toKey = [[result keyPathMapping] objectForKey:key];
            if (toKey.length == 0) {
                toKey = key;
            }
            
            NSString *propertyName = [mapDictionary objectForKey:toKey];
            if (!propertyName) {
                continue;
            }
            
            id object = [dictionary objectForKey:key];
            
            // If it's a Dictionary, make into object
            if ([object isKindOfClass:[NSDictionary class]]) {
                NSString *propertyType = [result classOfPropertyNamed:propertyName];
                Class typeClass = NSClassFromString(propertyType);
                if ([typeClass isSubclassOfClass:[NSArray class]]) {
                    propertyType = [[result classNamesInArray] objectForKey:propertyName];
                    NSArray *value = [propertyType valueOfClass:NSClassFromString(propertyType) forJSONArray:@[object]];
                    [result setValue:value forKey:toKey];
                } else {
                    id value = [self valueOfClass:typeClass forJSONDictionary:object];
                    [result setValue:value forKey:propertyName];
                }
            }
            
            // If it's an array, check for each object in array -> make into object/id
            else if ([object isKindOfClass:[NSArray class]]) {
//                NSArray *nestedArray = object;
                NSString *propertyType = [[result classNamesInArray] objectForKey:propertyName];
                [result setValue:[self valueOfClass:NSClassFromString(propertyType) forJSONArray:object] forKey:propertyName];
            }
            
            // Add to property name, because it is a type already
            else {
                objc_property_t property = class_getProperty([result class], [propertyName UTF8String]);
                NSString *classType = [result typeFromProperty:property];
                
                // check if NSDate or not
                if ([classType isEqualToString:@"T@\"NSDate\""]) {
                    NSString *dateString = [object stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                    [result setValue:[dateString dateValue] forKey:propertyName];
                } else {
                    if (object != [NSNull null]) {
                        [result setValue:object forKey:propertyName];
                    } else {
                        [result setValue:nil forKey:propertyName];
                    }
                }
            }
        }
    }
    
    return result;
}

- (id)valueOfClass:(Class)aClass forJSONArray:(NSArray *)array
{
    if (aClass) {
        // Set Up
        NSMutableArray *result = [NSMutableArray array];
        
        @try {
            // Create objects
            NSUInteger count = [array count];
            for (NSUInteger counter = 0; counter < count; counter ++) {
                
                @autoreleasepool {
                    
                    id object = [array objectAtIndex:counter];
                    
                    if ([object isKindOfClass:[NSDictionary class]]) {
                        // Create object of filteredProperty type
                        id nestedObject = [[aClass alloc] init];
                        
                        // Iterate through each key, create objects for each
                        for (NSString *key in [object allKeys]) {
                            @autoreleasepool {
                                
                                id objectInDictionary = [object objectForKey:key];
                                
                                NSString *toKey = [[nestedObject keyPathMapping] objectForKey:key];
                                if (toKey.length == 0) {
                                    toKey = key;
                                }
                                
                                if ([objectInDictionary isKindOfClass:[NSArray class]]) {
                                    NSString *propertyType = [[nestedObject classNamesInArray] objectForKey:toKey];
                                    id value = [self valueOfClass:NSClassFromString(propertyType) forJSONArray:objectInDictionary];
                                    if (value) {
                                        [nestedObject setValue:value forKey:toKey];
                                    }
                                } else if ([objectInDictionary isKindOfClass:[NSDictionary class]]) {
                                    NSString *propertyType = [nestedObject classOfPropertyNamed:toKey];
                                    //                            DLog(@"%@", toKey);
                                    if (propertyType.length > 0) {
                                        Class typeClass = NSClassFromString(propertyType);
                                        if ([typeClass isSubclassOfClass:[NSArray class]]) {
                                            propertyType = [[nestedObject classNamesInArray] objectForKey:toKey];
                                            NSArray *value = [self valueOfClass:NSClassFromString(propertyType) forJSONArray:@[objectInDictionary]];
                                            [nestedObject setValue:value forKey:toKey];
                                        } else {
                                            id value = [self valueOfClass:typeClass forJSONDictionary:objectInDictionary];
                                            [nestedObject setValue:value forKey:toKey];
                                        }
                                    }
                                } else {
                                    objc_property_t property = class_getProperty(aClass, [toKey UTF8String]);
                                    NSString *classType = [self typeFromProperty:property];
                                    if (classType.length > 0) {
                                        // check if NSDate or not
                                        if ([classType isEqualToString:@"T@\"NSDate\""]) {
                                            NSString *dateString = [objectInDictionary stringByReplacingOccurrencesOfString:@"T" withString:@" "];
                                            [nestedObject setValue:[dateString dateValue] forKey:toKey];
                                        } else {
                                            [nestedObject setValue:objectInDictionary forKey:toKey];
                                        }
                                    }
                                }
                            }
                        }
                        
                        // Finally add that object
                        [result addObject:nestedObject];
                    } else if ([object isKindOfClass:[NSArray class]]) {
                        [result addObject:[self valueOfClass:aClass forJSONArray:object]];
                    } else if ([object isKindOfClass:[NSNumber class]]) {
                        [result addObject:[object stringValue]];
                    } else {
                        [result addObject:object];
                    }
                }
            }
        }
        @catch (NSException *exception) {
            DLog(@"%@", exception.reason);
        }
        @finally {
            // This is now an Array of objects
            return result;
        }
    } else {
        return nil;
    }
}

#pragma mark - Dictionary to Object

- (NSString *)classOfPropertyNamed:(NSString *)propName
{
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int xx = 0; xx < count; xx++) {
        @autoreleasepool {
            if ([[NSString stringWithUTF8String:property_getName(properties[xx])] isEqualToString:propName]) {
                NSString *className = [NSString stringWithFormat:@"%s", getPropertyType(properties[xx])];
                free(properties);
                return className;
            }
        }
    }
    
    return nil;
}


static const char * getPropertyType(objc_property_t property) {
    const char *attributes = property_getAttributes(property);
    char buffer[1 + strlen(attributes)];
    strcpy(buffer, attributes);
    char *state = buffer, *attribute;
    while ((attribute = strsep(&state, ",")) != NULL) {
        if (attribute[0] == 'T' && attribute[1] != '@') {
            // it's a primitive type
            return (const char *)[[NSData dataWithBytes:(attribute + 1) length:strlen(attribute) - 1] bytes];
        }
        else if (attribute[0] == 'T' && attribute[1] == '@' && strlen(attribute) == 2) {
            // it's an ObjC id type:
            return "id";
        }
        else if (attribute[0] == 'T' && attribute[1] == '@') {
            // it's another ObjC object type:
            return (const char *)[[NSData dataWithBytes:(attribute + 3) length:strlen(attribute) - 4] bytes];
        }
    }
    return "";
}

- (NSDictionary *)propertyDictionary
{
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    
    unsigned count;
    objc_property_t *properties = class_copyPropertyList([self class], &count);
    
    for (int i = 0; i < count; i++) {
        NSString *key = [NSString stringWithUTF8String:property_getName(properties[i])];
        key.propertyIndex = [NSNumber numberWithInt:i];
        [dict setObject:key forKey:key];
    }
    
    free(properties);
    
    // Add all superclass properties as well, until it hits NSObject
    NSString *superClassName = NSStringFromClass([self superclass]);
    if (![superClassName isEqualToString:NSStringFromClass([NSObject class])]) {
        for (NSString *property in [[[self superclass] propertyDictionary] allKeys]) {
            @autoreleasepool {
                [dict setObject:property forKey:property];
            }
        }
    }
    
    return dict;
}

- (NSString *)typeFromProperty:(objc_property_t)property
{
    if (property) {
        return [[NSString stringWithUTF8String:property_getAttributes(property)] componentsSeparatedByString:@","][0];
    } else {
        return nil;
    }
}

@end