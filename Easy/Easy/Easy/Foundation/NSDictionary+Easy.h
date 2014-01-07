//
//  NSDictionary+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-10-15.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Easy)

- (id)objectForTreeStyleKey:(NSString*)key;     //format the key to string separated by "/", eg. key/subkey

@end
