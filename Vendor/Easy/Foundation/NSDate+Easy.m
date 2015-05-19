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
#import "LanguageManager.h"

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
    NSDate *result = [calendar dateByAddingComponents:timeComponents toDate:date options:0];
    
    return result;
}

/* 
 Specifies a long style, typically with full text, such as “November 23, 1937” or “3:30:32 PM PST”.
 */

- (NSString *)stringValuePrefered {
    return [self stringValueWithDateFormat:LocalizedString(@"MMM dd, yyyy, hh:mm:ss a", nil)];
}

- (NSString *)stringValuePreferedDateOnly {
    return [self stringValueWithDateFormat:LocalizedString(@"MMM dd, yyyy", nil)];
}

- (NSString *)stringValuePreferedTimeOnly {
    return [self stringValueWithDateFormat:LocalizedString(@"hh:mm:ss a", nil)];
}

- (NSString *)stringValueWithDateFormat:(NSString *)dateFormat {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [NSLocale localeWithLocaleIdentifier:@"en_US_POSIX"];
    dateFormatter.dateFormat = dateFormat;
    
//    if ([dateFormat isKindOfClass:[NSString class]]) {
//        [dateFormatter setDateFormat:dateFormat];
//    }
//    
//    [dateFormatter localizeSymbols];
    
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
    return [self stringValueWithDateFormatStyle:NSDateFormatterLongStyle];
}

- (NSString *)stringValueWithStylePreferedDateOnly
{
    return [self stringValueForDateOnlyWithDateStyle:NSDateFormatterLongStyle];
}

- (NSString *)stringValueWithStylePreferedTimeOnly
{
    return [self stringValueForTimeOnlyWithTimeStyle:NSDateFormatterLongStyle];
}

- (NSString *)timeStampString {
    return [NSString stringWithFormat:@"%ld", (long)[self timeIntervalSince1970]];
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
        NSString *dateString = [self stringValueWithDateFormat:dateFormat];
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
    return [self dateBySetHour:@(hour) minute:nil second:nil];
}

- (NSDate *)dateBySetHour:(NSNumber *)hour minute:(NSNumber *)minute second:(NSNumber *)second {
    if (!hour && !minute && !second) {
        return self;
    }
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *dateComponents = [calendar components:(NSYearCalendarUnit | NSMonthCalendarUnit | NSDayCalendarUnit) fromDate:self];
    if (hour) {
        [dateComponents setHour:hour.integerValue];
    }
    if (minute) {
        [dateComponents setMinute:minute.integerValue];
    }
    if (second) {
        [dateComponents setSecond:second.integerValue];
    }
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
    NSDate *date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:0];

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
    NSDate *date = date = [calendar dateByAddingComponents:componentsToSubtract toDate:midnight options:0];
    
    return date;
}

- (NSDate *)startOfTheDate {
    return [self dateBySetHour:@(0) minute:@(0) second:@(0)];
}

- (NSDate *)endOfTheDate {
    return [self dateBySetHour:@(23) minute:@(59) second:@(59)];
}

- (NSDate *)startOfTheWeek {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDate *start;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&start interval:&interval forDate:self];
    //start holds now the first day of the week, according to locale (monday vs. sunday)
    
    return start;
}

- (NSDate *)endOfTheWeek {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDate *start;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSWeekCalendarUnit startDate:&start interval:&interval forDate:self];
    //start holds now the first day of the week, according to locale (monday vs. sunday)
    
    return [start dateByAddingTimeInterval:interval - 1];
}

- (NSDate *)startOfTheMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDate *start;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&start interval:&interval forDate:self];
    //start holds now the first day of the month
    
    return start;
}

- (NSDate *)endOfTheMonth {
    NSCalendar *calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSCalendarIdentifierISO8601];
    NSDate *start;
    NSTimeInterval interval;
    [calendar rangeOfUnit:NSMonthCalendarUnit startDate:&start interval:&interval forDate:self];
    //start holds now the first day of the month
    
    return [start dateByAddingTimeInterval:interval - 1];
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
