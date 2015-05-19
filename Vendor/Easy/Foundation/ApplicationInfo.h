//
//  ApplicationInfo.h
//  Easy
//
//  Created by Jayce Yang on 13-9-13.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@interface ApplicationInfo : NSObject <NSCoding, NSCopying>

@property (copy, nonatomic) NSString *UUID;
@property (copy, nonatomic) NSString *currencyCode;
@property (copy, nonatomic) NSString *currencySymbol;

/*
 Holds in memory
 */
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (strong, nonatomic) NSManagedObjectModel *managedObjectModel;

+ (instancetype)sharedInfo;

- (void)write;
- (void)clear;  //Reset all values except UUID

@end
