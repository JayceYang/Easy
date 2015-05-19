//
//  NSLocale+Easy.m
//  Easy
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "NSLocale+Easy.h"

#import "NSObject+Easy.h"
#import "NSArray+Easy.h"
#import "NSString+Easy.h"
#import "ApplicationInfo.h"

@implementation NSLocale (Easy)

+ (NSString *)preferredLanguage
{
    NSString *language = [[self preferredLanguages] theFirstObject];
    if (language.length == 0) {
        language = @"en";
    }
    
    return language;
}

+ (NSString *)currentCountry
{
    return [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:[self currentCountryCode]];
}

+ (NSString *)currentCountryCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
}

+ (NSString *)currentCountryCodeLowercaseString
{
    return [[self currentCountryCode] lowercaseString];
}

+ (NSString *)currentLanguageCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleLanguageCode];
}

+ (NSString *)currentCurrencyCode
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencyCode];
}

+ (NSString *)currentCurrencySymbol
{
    return [[NSLocale currentLocale] objectForKey:NSLocaleCurrencySymbol];
}

+ (NSString *)currencySymbolFromCurrencyCode:(NSString *)code
{
    NSString *currencySymbol = nil;
    NSArray *availableLocaleIdentifiers = [self availableLocaleIdentifiers];
    for (NSString *identifier in availableLocaleIdentifiers) {
        NSLocale *locale = [NSLocale localeWithLocaleIdentifier:identifier];
        if ([[locale objectForKey:NSLocaleCurrencyCode] isEqualToString:code]) {
            currencySymbol = [locale objectForKey:NSLocaleCurrencySymbol];
            break;
        }
    }
    return [currencySymbol nonAlphaStringValue];
}

+ (NSString *)displayNameFromCountryCode:(NSString *)code {
    NSString *country = nil;
    NSString *countryCode = [code theStringValue];
    if (countryCode.length == 0) {
        country = [self currentCountry];
    } else {
        country = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
    }
    return country;
}

+ (BOOL)inChina
{
    return [[[self currentCountryCode] uppercaseString] isEqualToString:@"CN"];
}

/*
 Use [countries sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)] if needed
 */

+ (NSArray *)countryNames
{
    NSArray *countryCodes = [NSLocale ISOCountryCodes];
    NSUInteger count = countryCodes.count;
    NSMutableArray *countries = [NSMutableArray arrayWithCapacity:count];
    for (NSString *countryCode in countryCodes) {
        NSString *country = [[NSLocale systemLocale] displayNameForKey:NSLocaleCountryCode value:countryCode];
        if (country) {
            [countries addObject:country];
        }
        NSLog(@"%@\t%@", countryCode, country);
    }
    return [countries copy];
}

- (NSString *)country
{
    return [self displayNameForKey:NSLocaleCountryCode value:[self countryCode]];
}

- (NSString *)countryCode
{
    return [self objectForKey:NSLocaleCountryCode];
}

@end
