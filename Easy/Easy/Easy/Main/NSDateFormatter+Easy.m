//
//  NSDateFormatter+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-9-2.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "NSDateFormatter+Easy.h"

@implementation NSDateFormatter (Easy)

- (NSDateFormatter *)englishLocaleDateFormatter
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US"];
    return dateFormatter;
}

- (void)localizeSymbols
{    
    // long month style
    if ([self.dateFormat rangeOfString:@"MMM"].location != NSNotFound) {
        NSArray *shortMonthSymbols = [self englishLocaleDateFormatter].shortMonthSymbols;
        NSMutableArray *shortMonthSymbolsLocalized = [NSMutableArray array];
        for (NSString *shortMonthSymbol in shortMonthSymbols) {
            [shortMonthSymbolsLocalized addObject:NSLocalizedString(shortMonthSymbol, nil)];
        }
        self.shortMonthSymbols = shortMonthSymbolsLocalized;
    }
    
    // long weekday style
    if ([self.dateFormat rangeOfString:@"E"].location != NSNotFound) {
        NSArray *shortWeekdaySymbols = [self englishLocaleDateFormatter].shortWeekdaySymbols;
        NSMutableArray *shortWeekdaySymbolsLocalized = [NSMutableArray array];
        for (NSString *shortWeekdaySymbol in shortWeekdaySymbols) {
            [shortWeekdaySymbolsLocalized addObject:NSLocalizedString(shortWeekdaySymbol, nil)];
        }
        self.shortWeekdaySymbols = shortWeekdaySymbolsLocalized;
    }
    
    // 12 hour style
    if ([self.dateFormat rangeOfString:@"a"].location != NSNotFound) {
        NSDateFormatter *dateFormatterForAMPM = [self englishLocaleDateFormatter];
        self.AMSymbol = NSLocalizedString(dateFormatterForAMPM.AMSymbol, nil);
        self.PMSymbol = NSLocalizedString(dateFormatterForAMPM.PMSymbol, nil);
    }
    
    
}

@end
