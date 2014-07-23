//
//  NSLocale+Easy.h
//  Easy
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (Easy)

+ (NSString *)localeIdentifierFromOldLanguage:(NSString *)language;
+ (NSString *)oldLanguageFromLocaleIdentifier:(NSString *)identifier;
+ (NSString *)preferredLanguage;
+ (NSString *)preferredLanguageOld;

+ (NSString *)currentCountryCode;
+ (NSString *)currentCountryCodeLowercaseString;
+ (NSString *)currentLanguageCode;
+ (NSString *)currentCurrencyCode;
+ (BOOL)inChina;

@end
