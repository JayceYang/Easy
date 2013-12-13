//
//  NSManagedObject+Mapping.h
//  iGuest
//
//  Created by Jayce Yang on 13-10-16.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Mapping)

//@property (strong, nonatomic) NSNumber *sortID;

+ (instancetype)managedObjectForDictionary:(NSDictionary *)dictionary insertIntoManagedObjectContext:(NSManagedObjectContext *)context;

- (NSDictionary *)dictionaryValue;

- (void)makePropertyNamesMappingForKey:(NSString *)key sourceKey:(NSString *)sourceKey;

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context;
- (void)logAll;

@end
