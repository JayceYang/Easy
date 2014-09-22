//
//  NSLocale+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (Easy)

+ (NSString *)preferredLanguage;

+ (NSString *)currentCountry;
+ (NSString *)currentCountryCode;

+ (NSString *)currentCurrencySymbol;
+ (NSString *)currentCurrencyCode;
+ (NSString *)currentCountryCodeLowercaseString;
+ (NSString *)currentLanguageCode;
+ (NSString *)currencySymbolFromCurrencyCode:(NSString *)code;
+ (BOOL)inChina;

+ (NSArray *)countryNames;

- (NSString *)country;
- (NSString *)countryCode;

@end
