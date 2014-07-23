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
#import "ApplicationInfo.h"

@implementation NSLocale (Easy)

+ (NSString *)localeIdentifierFromOldLanguage:(NSString *)language
{
//    NSLog(@"%@", [NSLocale availableLocaleIdentifiers]);
    NSString *result = @"en";
    if ([language isEqualToString:@"zh-CN"]) {
        result = @"zh-Hans";
    }
    
//    if ([language isEqualToString:@"en_US"]) {
//        result = @"en";
//    } else if ([language isEqualToString:@"es_ES"]) {
//        result = @"en-ES";
//    } else if ([language isEqualToString:@"zh_CN"]) {
//        result = @"zh-Hans";
//    } else if ([language isEqualToString:@"zh_TW"]) {
//        result = @"zh-Hant";
//    } else if ([language isEqualToString:@"ja_JP"]) {
//        result = @"ja-JP";
//    } else if ([language isEqualToString:@"ko_KR"]) {
//        result = @"ko-KR";
//    } else if ([language isEqualToString:@"pt_PT"]) {
//        result = @"pt-PT";
//    } else if ([language isEqualToString:@"th_TH"]) {
//        result = @"th-TH";
//    } else if ([language isEqualToString:@"vi_VN"]) {
//        result = @"vi-VN";
//    }
    
    return result;
}

+ (NSString *)oldLanguageFromLocaleIdentifier:(NSString *)identifier
{
//    NSString *result = @"en_US";
    NSString *result = @"en";
    if ([identifier isEqualToString:@"zh-Hans"]) {
        result = @"zh-CN";
    }
    
//    if ([identifier isEqualToString:@"en"]) {
//        result = @"en_US";
//    } else if ([identifier isEqualToString:@"en-ES"]) {
//        result = @"es_ES";
//    } else if ([identifier isEqualToString:@"zh-Hans"]) {
//        result = @"zh_CN";
//    } else if ([identifier isEqualToString:@"zh-Hant"]) {
//        result = @"zh_TW";
//    } else if ([identifier isEqualToString:@"ja-JP"]) {
//        result = @"ja_JP";
//    } else if ([identifier isEqualToString:@"ko-KR"]) {
//        result = @"ko_KR";
//    } else if ([identifier isEqualToString:@"pt-PT"]) {
//        result = @"pt_PT";
//    } else if ([identifier isEqualToString:@"th-TH"]) {
//        result = @"th_TH";
//    } else if ([identifier isEqualToString:@"vi-VN"]) {
//        result = @"vi_VN";
//    }
    
    return result;
}

+ (NSString *)preferredLanguage
{
    NSString *language = [[self preferredLanguages] theFirstObject];
    if (language.length == 0) {
        language = @"en";
    }
    
    return language;
}

+ (NSString *)preferredLanguageOld
{
    return [self oldLanguageFromLocaleIdentifier:[self preferredLanguage]];
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

+ (BOOL)inChina
{
    return [[[self currentCountryCode] uppercaseString] isEqualToString:@"CN"];
}

@end
