//
//  User.h
//  Easy
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface User : NSManagedObject

@property (nonatomic, retain) NSString * userID;
@property (nonatomic, retain) NSString * username;
@property (nonatomic, retain) NSManagedObject *post;

@end
