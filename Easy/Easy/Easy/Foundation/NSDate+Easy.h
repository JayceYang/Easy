//
//  NSDate+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/3/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDate (Easy)

+ (id)dateWithDate:(NSDate *)date time:(NSDate *)time;

/* use kDateFormatForServer */
- (NSString *)stringValue;

- (NSString *)stringValueFromDateFormat:(NSString *)dateFormat;
- (NSString *)stringValueWithDateFormatStyle:(NSDateFormatterStyle)style;

/*
 NSDateFormatterShortStyle = kCFDateFormatterShortStyle,
 NSDateFormatterMediumStyle = kCFDateFormatterMediumStyle,
 NSDateFormatterLongStyle = kCFDateFormatterLongStyle,
 NSDateFormatterFullStyle = kCFDateFormatterFullStyle
 */

- (NSString *)stringValueWithStyleShort;
- (NSString *)stringValueWithStyleMedium;
- (NSString *)stringValueWithStyleLong;
- (NSString *)stringValueWithStyleFull;

- (NSString *)stringValueWithStylePrefered;
- (NSString *)stringValueWithStylePreferedDateOnly;
- (NSString *)stringValueWithStylePreferedTimeOnly;

- (NSDate *)noneDaylightSavingTimeDate;
- (NSDate *)noneDaylightSavingTimeDateForDateComponents;
- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat;

- (BOOL)earlierThanDate:(NSDate *)anotherDate;
- (BOOL)laterThanDate:(NSDate *)anotherDate;

- (BOOL)earlierThanOrEqualToDate:(NSDate *)anotherDate;
- (BOOL)laterThanOrEqualToDate:(NSDate *)anotherDate;

- (NSDate *)theDayBeforeYesterday;
- (NSDate *)yesterday;
- (NSDate *)today;
- (NSDate *)tomorrow;
- (NSDate *)theDayAfterTomorrow;
- (NSDate *)midnight;
- (NSDate *)midday;
- (NSDate *)dateBySettingHour:(NSInteger)hour;
- (NSDate *)dateByAddingDayInterval:(NSInteger)interval;
- (NSDate *)dateByAddingDayIntervalSinceNow:(NSInteger)interval;

- (NSInteger)thisYear;
- (NSInteger)thisMonth;
- (NSInteger)thisDay;
- (NSInteger)thisHour;
- (NSInteger)thisMinute;
- (NSInteger)thisSecond;
- (NSInteger)year;
- (NSInteger)month;
- (NSInteger)day;
- (NSInteger)hour;
- (NSInteger)minute;
- (NSInteger)second;

@end
