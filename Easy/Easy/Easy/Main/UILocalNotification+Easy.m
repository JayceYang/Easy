//
//  UILocalNotification+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 13-12-17.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import "UILocalNotification+Easy.h"

@implementation UILocalNotification (Easy)

+ (void)presentWithAlertBody:(NSString *)body
{
    UILocalNotification *localNotification = [[UILocalNotification alloc] init];
//    localNotification.fireDate = [NSDate dateWithTimeIntervalSinceNow:1];
//    localNotification.timeZone = [NSTimeZone localTimeZone];
    localNotification.alertBody = body;
    localNotification.soundName = UILocalNotificationDefaultSoundName;
    [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
//    [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
}

@end
