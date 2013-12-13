//
//  NSTimeZone+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-9-23.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "NSTimeZone+Easy.h"

@implementation NSTimeZone (Easy)

+ (NSTimeZone *)noneDaylightSavingTimeTimeZone
{
    NSTimeZone *timeZone = [NSTimeZone defaultTimeZone];
    if ([timeZone isDaylightSavingTime]) {
        NSTimeInterval secondsFromGMT = [timeZone secondsFromGMT] - [timeZone daylightSavingTimeOffset];
        return [NSTimeZone timeZoneForSecondsFromGMT:secondsFromGMT];
    } else {
        return timeZone;
    }
}

@end
