//
//  NSCalendar+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-9-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Easy)

- (NSDateComponents *)dayComponentsFromDate:(NSDate *)date;
- (NSDateComponents *)timeComponentsFromDate:(NSDate *)date;

@end
