//
//  NSManagedObject+Easy.h
//  DJIStore
//
//  Created by Jayce Yang on 14-2-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSManagedObject (Easy)

+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context predicate:(NSPredicate *)predicate;
+ (void)logAllInManagedObjectContext:(NSManagedObjectContext *)context;
- (void)logAll;

@end
