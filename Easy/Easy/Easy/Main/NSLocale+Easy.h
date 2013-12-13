//
//  NSLocale+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-7-17.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSLocale (Easy)

+ (NSString *)localeIdentifierFromOldLanguage:(NSString *)language;
+ (NSString *)oldLanguageFromLocaleIdentifier:(NSString *)identifier;
+ (NSString *)preferredLanguage;

@end
