//
//  User.m
//  Easy
//
//  Created by Jayce Yang on 14-7-23.
//  Copyright (c) 2014年 Personal. All rights reserved.
//

#import "User.h"

#import "Easy.h"

@implementation User

@dynamic userID;
@dynamic username;
@dynamic post;

- (instancetype)initWithEntity:(NSEntityDescription *)entity insertIntoManagedObjectContext:(NSManagedObjectContext *)context
{
    self = [super initWithEntity:entity insertIntoManagedObjectContext:context];
    if (self) {
        // Initialization code
        
        [self makePropertyNamesMappingForKey:@"userID" sourceKey:@"id"];
    }
    return self;
}

@end
