//
//  NSString+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Easy)

+ (NSString *)stringWithInteger:(NSInteger)value;

- (NSNumber *)numberValue;
- (NSString *)noneNullStringValue;
- (NSString *)clearNullStringValueOfServer;
- (NSString *)clearPlaceholderStringValueOfServer;
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement;

/* return [NSDate date] when the date is invalid */
- (NSDate *)dateValue;
- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat;

- (NSDate *)dateValueWithStyleShort;
- (NSDate *)dateValueWithStyleMedium;
- (NSDate *)dateValueWithStyleLong;
- (NSDate *)dateValueWithStyleFull;
- (NSDate *)dateValueWithStylePrefered;
- (NSDate *)dateValueWithStylePreferedDateOnly;
- (NSDate *)dateValueWithStylePreferedTimeOnly;

- (BOOL)isValidNumber;
- (BOOL)isValidEmail;

- (BOOL)empty;

- (NSString *)UTF8EncodedURLString;

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width;
- (CGFloat)heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size;

@end
