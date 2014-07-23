//
//  MasterViewController.h
//  Easy
//
//  Created by Jayce Yang on 13-12-13.
//  Copyright (c) 2013年 Jayce Yang. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailViewController;

#import <CoreData/CoreData.h>

@interface MasterViewController : UITableViewController

@property (strong, nonatomic) DetailViewController *detailViewController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
