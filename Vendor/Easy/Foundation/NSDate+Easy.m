//
//  NSDate+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/3/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import "NSDate+Easy.h"

#import "NSString+Easy.h"
#import "NSDateFormatter+Easy.h"
#import "NSLocale+Easy.h"
#import "NSTimeZone+Easy.h"
#import "NSCalendar+Easy.h"
#import "NSObject+Easy.h"
#import "Macro.h"

#import "ApplicationInfo.h"

@implementation NSDate (Easy)

+ (id)dateWithDate:(NSDate *)date time:(NSDate *)time
{
    NSTimeZone *timeZone = [NSTimeZone noneDaylightSavingTimeTimeZone];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
//    NSDateComponents *dayComponents = [calendar dayComponentsFromDate:day];
//    dayComponents.timeZone = timeZone;
//    NSDate *day = [calendar dateFromComponents:dayComponents];
    
    NSDateComponents *timeComponents = [calendar timeComponentsFromDate:time];
    timeComponents.timeZone = timeZone;
    NSDate *result = [calendar dateByAddingComponents:timeComponents toDate:date options:NSCalendarWrapComponents];
    
    return result;
}

- (NSString *)stringValueFromDateFormat:(NSString *)dateFormat
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale currentLocale];
    
    if ([dateFormat isKindOfClass:[NSString class]]) {
        [dateFormatter setDateFormat:dateFormat];
    }
    
    [dateFormatter localizeSymbols];
    
//    NSString *result = [NSString string];
//    
//    if ([dateFormatter.timeZone isDaylightSavingTimeForDate:[NSDate date]]) {
//        NSTimeInterval daylightSavingTimeOffset = [dateFormatter.timeZone daylightSavingTimeOffsetForDate:[NSDate date]];
//        result = [dateFormatter stringFromDate:[self dateByAddingTimeInterval:daylightSavingTimeOffset]];
//    } else {
//        result = [dateFormatter stringFromDate:self];
//    }
    
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueWithDateFormatStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    dateFormatter.timeStyle = style;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueForDateOnlyWithDateStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueForTimeOnlyWithTimeStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeStyle = style;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter stringFromDate:self];
}

- (NSString *)stringValueWithStyleShort
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSString *)stringValueWithStyleMedium
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterMediumStyle];
}

- (NSString *)stringValueWithStyleLong
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterLongStyle];
}

- (NSString *)stringValueWithStyleFull
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterFullStyle];
}

- (NSString *)stringValueWithStylePrefered
{
    return [self stringValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSString *)stringValueWithStylePreferedDateOnly
{
    return [self stringValueForDateOnlyWithDateStyle:NSDateFormatterShortStyle];
}

- (NSString *)stringValueWithStylePreferedTimeOnly
{
    return [self stringValueForTimeOnlyWithTimeStyle:NSDateFormatterShortStyle];
}

- (NSDate *)noneDaylightSavingTimeDate
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval daylightSavingTimeOffset = [timeZone daylightSavingTimeOffset];
    return [self dateByAddingTimeInterval:- daylightSavingTimeOffset];
}

- (NSDate *)noneDaylightSavingTimeDateForDateComponents
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    NSTimeInterval daylightSavingTimeOffset = [timeZone daylightSavingTimeOffset];
    return [self dateByAddingTimeInterval:daylightSavingTimeOffset];
}

- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat
{    
    if ([dateFormat isKindOfClass:[NSString class]]) {
        NSString *dateString = [self stringValueFromDateFormat:dateFormat];
        return [dateString dateValueFromDateFormat:dateFormat];
    } else {
        return [NSDate date];
    }
}

/*
 If:
 The receiver and anotherDate are exactly equal to each other, NSOrderedSame
 The receiver is later in time than anotherDate, NSOrderedDescending
 The receiver is earlier in time than anotherDate, NSOrderedAscending.
 */
- (BOOL)earlierThanDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] == NSOrderedAscending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)laterThanDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] == NSOrderedDescending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)earlierThanOrEqualToDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] != NSOrderedDescending) {
            result = YES;
        }
    }
    
    return result;
}

- (BOOL)laterThanOrEqualToDate:(NSDate *)anotherDate
{
    BOOL result = NO;
    if ([anotherDate isKindOfClass:[NSDate class]]) {
        if ([self compare:anotherDate] != NSOrderedAscending) {
            result = YES;
        }
    }
    
    return result;
}

- (NSDate *)theDayBeforeYesterday
{
    return [self dateByAddingDayIntervalSinceNow:-2];
}

- (NSDate *)yesterday
{
    return [self dateByAddingDayIntervalSinceNow:-1];
}

- (NSDate *)today
{
    return [self dateByAddingDayIntervalSinceNow:0];
}

- (NSDate *)tomorrow
{
    return [self dateByAddingDayIntervalSinceNow:1];
}

- (NSDate *)theDayAfterTomorrow
{
    return [self dateByAddingDayIntervalSinceNow:2];
}

- (NSDate *)midnight
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
	NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)midday
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [dateComponents setHour:12];
	NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)dateBySettingHour:(NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    [dateComponents setHour:hour];
	NSDate *date = [calendar dateFromComponents:dateComponents];
    return date;
}

- (NSDate *)dateByAddingDayInterval:(NSInteger)interval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *offsetComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit | NSHourCalendarUnit | NSMinuteCalendarUnit | NSSecondCalendarUnit) fromDate:self];
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:interval];
    NSDate *date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:NSCalendarWrapComponents];

    return date;
}

- (NSDate *)dateByAddingDayIntervalSinceNow:(NSInteger)interval
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDate *now = [NSDate date];
    NSDateComponents *offsetComponents = [calendar components:(NSEraCalendarUnit | NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:now];
	NSDate *midnight = [calendar dateFromComponents:offsetComponents];
    NSDateComponents *componentsToSubtract = [[NSDateComponents alloc] init];
    [componentsToSubtract setDay:interval];
    NSDate *date = date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:NSCalendarWrapComponents];
    
    return date;
}

- (NSInteger)thisYear
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:[NSDate date]];
    return [dateComponents year];
}

- (NSInteger)thisMonth
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:[NSDate date]];
    return [dateComponents month];
}

- (NSInteger)thisDay
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:[NSDate date]];
    return [dateComponents day];
}

- (NSInteger)thisHour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:[NSDate date]];
    return [dateComponents hour];
}

- (NSInteger)thisMinute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:[NSDate date]];
    return [dateComponents minute];
}

- (NSInteger)thisSecond
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:[NSDate date]];
    return [dateComponents second];
}

- (NSInteger)year
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSYearCalendarUnit fromDate:self];
    return [dateComponents year];
}

- (NSInteger)month
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMonthCalendarUnit fromDate:self];
    return [dateComponents month];
}

- (NSInteger)day
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSDayCalendarUnit fromDate:self];
    return [dateComponents day];
}

- (NSInteger)hour
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSHourCalendarUnit fromDate:self];
    return [dateComponents hour];
}

- (NSInteger)minute
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSMinuteCalendarUnit fromDate:self];
    return [dateComponents minute];
}

- (NSInteger)second
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:NSSecondCalendarUnit fromDate:self];
    return [dateComponents second];
}

@end
