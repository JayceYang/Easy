//
//  NSString+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <CommonCrypto/CommonDigest.h>

#import "NSString+Easy.h"

#import "NSDate+Easy.h"
#import "NSDateFormatter+Easy.h"
#import "ApplicationInfo.h"
#import "NSLocale+Easy.h"
#import "Macro.h"

@implementation NSString (Easy)

#pragma mark - Public

+ (NSString *)stringWithUnsignedInteger:(NSUInteger)value {
    return [NSString stringWithFormat:@"%ld", (unsigned long)value];
}

+ (NSString *)stringWithInteger:(NSInteger)value {
    return [NSString stringWithFormat:@"%ld", (long)value];
}

+ (NSString *)stringWithFloat:(float)value {
    return [NSString stringWithFormat:@"%.0f", value];
}

+ (NSString *)stringWithDouble:(double)value {
    return [NSString stringWithFormat:@"%.0lf", value];
}

- (NSNumber *)numberValue
{
    if ([self isKindOfClass:[NSString class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterNoStyle];
        [numberFormatter setDecimalSeparator:@"."];
        return [numberFormatter numberFromString:self];
    } else {
        return nil;
    }
}

- (NSString *)noneNullStringValue
{
    NSString *pattern = @"(?:\\(null\\))|(?:null)";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRange range = NSMakeRange(0, self.length);
    NSString *string = [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:range withTemplate:@"$1"];
    
    return string;
}

- (NSString *)nonAlphaStringValue {
    NSString *pattern = @"(?:[a-z])";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRange range = NSMakeRange(0, self.length);
    NSString *string = [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:range withTemplate:@"$1"];
    
    return string;
}

- (NSString *)stringByTrimmingLeadingAndTrailingWhiteSpaces
{
    NSString *pattern = @"(?:^\\s+)|(?:\\s+$)";
    NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:NULL];
    NSRange range = NSMakeRange(0, self.length);
    NSString *string = [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:range withTemplate:@"$1"];
    
    return string;
}

- (NSString *)stringByAppendingTheString:(NSString *)string
{
    NSString *result = nil;
    @try {
        result = [self stringByAppendingString:string];
    }
    @catch (NSException *exception) {
//        NSLog(@"%@", exception.reason);
        result = self;
    }
    @finally {
        return result;
    }
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement
{
    NSString *string = nil;
    @try {
        string = [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
//        NSLog(@"%@", exception.reason);
        string = self;
    }
    @finally {
        return string;
    }
}

/*
 @"yyyy-MM-dd HH:mm:ss"
 @"HH:mm:ss"
 */

- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat
{
    NSDate *date = [NSDate date];
    if ([self isKindOfClass:[NSString class]]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        dateFormatter.locale = [NSLocale currentLocale];
        
        if ([dateFormat isKindOfClass:[NSString class]]) {
            [dateFormatter setDateFormat:dateFormat];
        }
        date = [dateFormatter dateFromString:self];
//        NSTimeInterval daylightSavingTimeOffset = [dateFormatter.timeZone daylightSavingTimeOffsetForDate:[NSDate date]];
//        date = [date dateByAddingTimeInterval:daylightSavingTimeOffset];
    }
    
    return date;
}

- (NSDate *)dateValueWithDateFormatStyle:(NSDateFormatterStyle)style
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = style;
    dateFormatter.timeStyle = style;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateValueWithStyleShort
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSDate *)dateValueWithStyleMedium
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterMediumStyle];
}

- (NSDate *)dateValueWithStyleLong
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterLongStyle];
}

- (NSDate *)dateValueWithStyleFull
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterFullStyle];
}

- (NSDate *)dateValueWithStylePrefered
{
    return [self dateValueWithDateFormatStyle:NSDateFormatterShortStyle];
}

- (NSDate *)dateValueWithStylePreferedDateOnly
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateStyle = NSDateFormatterShortStyle;
    dateFormatter.locale = [NSLocale currentLocale];
    return [dateFormatter dateFromString:self];
}

- (NSDate *)dateValueWithStylePreferedTimeOnly
{
    NSDate *result = nil;
    @try {
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.locale = [NSLocale currentLocale];
        result = [dateFormatter dateFromString:self];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
        result = [NSDate date];
    }
    @finally {
        return result;
    }
}

- (NSDate *)timeStampDate {
    return [NSDate dateWithTimeIntervalSince1970:self.doubleValue];
}

- (BOOL)isValidNumber
{
    NSString *pattern = @"^[0-9]*$";
    return [self matchWithPattern:pattern];
}

- (BOOL)isValidEmail
{
//    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9]+\\.[A-Za-z]{2,}";
    /*
     1.以非@、非空字符打头，重复至少1次
     2.@
     3.以组合“-、英文字母、数字重复至少1次，.，英文字母重复至少2次”结尾
     */
    NSString *pattern = @"^([^@\\s]+)@((?:[-a-z0-9]+\\.)+[a-z]{2,})$";
    return [self matchWithPattern:pattern caseInsensitive:YES];
}

- (BOOL)isValidPhoneNumber
{
    NSString *pattern = @".*\\d+.*";
    return [self matchWithPattern:pattern];
}

- (BOOL)matchWithPattern:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

- (BOOL)matchWithPattern:(NSString *)pattern caseInsensitive:(BOOL)caseInsensitive
{
    if (caseInsensitive) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES[c] %@", pattern];
        return [predicate evaluateWithObject:self];
    } else {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
        return [predicate evaluateWithObject:self];
    }
}

- (BOOL)empty
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

- (NSString *)UTF8EncodedURLString
{
    return encodedURLStringWithEncoding(self, NSUTF8StringEncoding);
}
- (NSString *)stringByReplacingPercentEscapesUsingUTF8Encoding
{
    return [self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)stringByReplacingPercentEscapesUsingUTF8EncodingAndClearNull
{
    return [[self stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding] noneNullStringValue];
}

#pragma mark - Hash

- (NSString *)MD5String {
    unsigned int outputLength = CC_MD5_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_MD5(self.UTF8String, [self UTF8Length], output);
    return [self hexStringFromData:output length:outputLength];
}

- (NSString *)SHA1String {
    unsigned int outputLength = CC_SHA1_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA1(self.UTF8String, [self UTF8Length], output);
    return [self hexStringFromData:output length:outputLength];
}

- (NSString *)SHA256String {
    unsigned int outputLength = CC_SHA256_DIGEST_LENGTH;
    unsigned char output[outputLength];
    
    CC_SHA256(self.UTF8String, [self UTF8Length], output);
    return [self hexStringFromData:output length:outputLength];
}

- (unsigned int)UTF8Length {
    return (unsigned int)[self lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString *)hexStringFromData:(unsigned char *)data length:(unsigned int)length {
    NSMutableString *hash = [NSMutableString stringWithCapacity:length * 2];
    for (unsigned int i = 0; i < length; i++) {
        [hash appendFormat:@"%02x", data[i]];
        data[i] = 0;
    }
    return hash;
}

#pragma mark - Private

static NSString * encodedURLStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',*";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
