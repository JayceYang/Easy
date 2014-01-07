//
//  NSString+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/8/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import "NSString+Easy.h"

#import "NSDate+Easy.h"
#import "NSDateFormatter+Easy.h"
#import "ApplicationInfo.h"
#import "NSLocale+Easy.h"
#import "Constants.h"
#import "Macro.h"

@implementation NSString (Easy)

#pragma mark - Public

+ (NSString *)stringWithInteger:(NSInteger)value
{
    return [NSString stringWithFormat:@"%ld", (long)value];
}

- (NSNumber *)numberValue
{
    if ([self isKindOfClass:[NSString class]]) {
        NSNumberFormatter *numberFormatter = [[NSNumberFormatter alloc] init];
        [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        return [numberFormatter numberFromString:self];
    } else {
        return nil;
    }
}

- (NSString *)noneNullStringValue
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"(null)" withString:[NSString string]];
//    result = [self stringByReplacingOccurrencesOfString:@"null" withString:[NSString string]];
//    if ([result length] == 0) {
//        result = [NSString string];
//    }
    
    return result;
}

- (NSString *)clearNullStringValueOfServer
{
    NSString *result = [self stringByReplacingOccurrencesOfString:@"null" withString:[NSString string]];
    
    return result;
}

- (NSString *)clearPlaceholderStringValueOfServer
{
    NSString *result = [NSString string];
    if (self.length > 0) {
        NSString *pattern = @"<\\[<[\\w]*>\\]>";
        NSError *error = nil;
        NSRange range = NSMakeRange(0, self.length - 1);
        NSRegularExpression *regularExpression = [NSRegularExpression regularExpressionWithPattern:pattern options:NSRegularExpressionCaseInsensitive error:&error];
//        NSArray *maches = [regularExpression matchesInString:self options:NSMatchingReportProgress range:range];
//        for (NSTextCheckingResult *result in maches) {
//            DLog(@"%@",[self substringWithRange:result.range]);
//        }
        
        result = [regularExpression stringByReplacingMatchesInString:self options:NSMatchingReportProgress range:range withTemplate:[NSString string]];
    }
    
    return result;
}

- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withTheString:(NSString *)replacement
{
    NSString *string = nil;
    @try {
        string = [self stringByReplacingOccurrencesOfString:target withString:replacement];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
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

- (NSDate *)dateValue
{
    NSDate *date = [self dateValueFromDateFormat:kDefaultFromDateFormat];
    return date;
}

- (NSDate *)dateValueFromDateFormat:(NSString *)dateFormat
{
    NSDate *date = [NSDate date];
    if ([self isKindOfClass:[NSString class]]) {
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        dateFormatter.timeZone = [NSTimeZone defaultTimeZone];
        dateFormatter.locale = [NSLocale currentLocale];
        
        if ([dateFormat isKindOfClass:[NSString class]]) {
            [dateFormatter setDateFormat:dateFormat];
        } else {
            [dateFormatter setDateFormat:kDefaultFromDateFormat];
        }
        
        [dateFormatter localizeSymbols];
        
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
        DLog(@"%@", exception.reason);
        result = [NSDate date];
    }
    @finally {
        return result;
    }
}

- (BOOL)isValidNumber
{
    NSString *pattern = @"^[0-9]*$";
    return [self matchWithPattern:pattern];
}

- (BOOL)isValidEmail
{
    NSString *pattern = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    return [self matchWithPattern:pattern];
}

- (BOOL)empty
{
    return [[self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] length] == 0;
}

- (NSString *)UTF8EncodedURLString
{
    return encodedURLStringWithEncoding(self, NSUTF8StringEncoding);
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedToWidth:(CGFloat)width
{
    CGFloat result = 0;
    CGSize constraint = CGSizeMake(width, CGFLOAT_MAX);
//    CGSize size = [self sizeWithFont:font constrainedToSize:constraint];
//    CGSize size = [self sizeWithAttributes:@{NSFontAttributeName:font}];
    CGSize size = [self boundingRectWithSize:constraint options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size;
    result = size.height;
    return result;
}

- (CGFloat)heightWithFont:(UIFont *)font constrainedToSize:(CGSize)size
{
    CGFloat result = [self boundingRectWithSize:size options:NSStringDrawingTruncatesLastVisibleLine attributes:@{NSFontAttributeName:font} context:nil].size.height;
    return result;
}

#pragma mark - Private

- (BOOL)matchWithPattern:(NSString *)pattern
{
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", pattern];
    return [predicate evaluateWithObject:self];
}

static NSString * encodedURLStringWithEncoding(NSString *string, NSStringEncoding encoding)
{
    static NSString * const kAFCharactersToBeEscaped = @":/?&=;+!@#$()',*";
    static NSString * const kAFCharactersToLeaveUnescaped = @"[].";
    
	return (__bridge_transfer  NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (__bridge CFStringRef)string, (__bridge CFStringRef)kAFCharactersToLeaveUnescaped, (__bridge CFStringRef)kAFCharactersToBeEscaped, CFStringConvertNSStringEncodingToEncoding(encoding));
}

@end
