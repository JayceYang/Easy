//
//  NSFetchRequest+Easy.h
//  Sales
//
//  Created by Jayce Yang on 14-8-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <CoreData/CoreData.h>

@interface NSFetchRequest (Easy)

- (void)addUpdatingWatcherForManagedObjects:(NSArray *)objects handler:(void (^)(NSFetchRequest *fetchRequest))handler;
- (void)addDeletingWatcherForManagedObjects:(NSArray *)objects handler:(void (^)(NSFetchRequest *fetchRequest))handler;

@end
