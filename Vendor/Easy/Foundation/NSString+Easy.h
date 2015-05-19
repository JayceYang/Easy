//
//  NSString+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Easy)

+ (NSString *)stringWithUnsignedInteger:(NSUInteger)value;
+ (NSString *)stringWithInteger:(NSInteger)value;
+ (NSString *)stringWithFloat:(float)value;
+ (NSString *)stringWithDouble:(double)value;

- (NSNumber *)numberValue;

/* Replace all "null" and (null), and return the result
 */
- (NSString *)noneNullStringValue;

- (NSString *)nonAlphaStringValue;

/* Trim the input string by removing leading and trailing white spaces, and return the result
 */
- (NSString *)stringByTrimmingLeadingAndTrailingWhiteSpaces;

- (NSString *)stringByAppendingTheString:(NSString *)string;
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement;

/* return [NSDate date] when the date is invalid */
- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat;

- (NSDate *)dateValueWithStyleShort;
- (NSDate *)dateValueWithStyleMedium;
- (NSDate *)dateValueWithStyleLong;
- (NSDate *)dateValueWithStyleFull;
- (NSDate *)dateValueWithStylePrefered;
- (NSDate *)dateValueWithStylePreferedDateOnly;
- (NSDate *)dateValueWithStylePreferedTimeOnly;

- (NSDate *)timeStampDate;

- (BOOL)isValidNumber;
- (BOOL)isValidEmail;
- (BOOL)isValidPhoneNumber;   //Contains one number at least
- (BOOL)matchWithPattern:(NSString *)pattern;

- (BOOL)empty;

- (NSString *)UTF8EncodedURLString;
- (NSString *)stringByReplacingPercentEscapesUsingUTF8Encoding;
- (NSString *)stringByReplacingPercentEscapesUsingUTF8EncodingAndClearNull;

- (NSString *)MD5String;
- (NSString *)SHA1String;
- (NSString *)SHA256String;

@end
