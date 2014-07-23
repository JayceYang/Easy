//
//  NSCalendar+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-9-23.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSCalendar+Easy.h"

#import "Macro.h"

@implementation NSCalendar (Easy)

- (NSDateComponents *)dayComponentsFromDate:(NSDate *)date
{
    NSDateComponents *dateComponents = nil;
    @try {
        dateComponents = [self components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:date];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return dateComponents;
    }
}

- (NSDateComponents *)timeComponentsFromDate:(NSDate *)date
{
    NSDateComponents *dateComponents = nil;
    @try {
        dateComponents = [self components:(NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:date];
    }
    @catch (NSException *exception) {
        NSLog(@"%@", exception.reason);
    }
    @finally {
        return dateComponents;
    }
}

@end
