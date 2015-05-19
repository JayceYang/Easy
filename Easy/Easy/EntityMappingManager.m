//
//  EntityMappingManager.m
//  Sales
//
//  Created by Jayce Yang on 14-9-26.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "EntityMappingManager.h"

#import "Easy.h"
#import "Post.h"
#import "User.h"

@implementation EntityMappingManager

#pragma mark - Lifecycle

- (instancetype)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
        [[EntityMapping sharedMapping] mappingEntityName:NSStringFromClass([Post class]) attributes:@{@"postID": @"trackId", @"text": @"description"}];
        [[EntityMapping sharedMapping] mappingEntityName:NSStringFromClass([User class]) attributes:@{@"userID": @"id"}];
    }
    return self;
}

- (void)dealloc {
    
}

#pragma mark - Public

+ (instancetype)sharedManager {
    static id sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

@end
