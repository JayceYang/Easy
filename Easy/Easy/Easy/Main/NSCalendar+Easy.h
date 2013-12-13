//
//  NSCalendar+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-9-23.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSCalendar (Easy)

- (NSDateComponents *)dayComponentsFromDate:(NSDate *)date;
- (NSDateComponents *)timeComponentsFromDate:(NSDate *)date;

@end
