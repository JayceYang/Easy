//
//  NSDateFormatter+Easy.h
//  iGuest
//
//  Created by Jayce Yang on 13-9-2.
//  Copyright (c) 2013年 FCS Shenzhen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDateFormatter (Easy)

- (NSDateFormatter *)englishLocaleDateFormatter;
- (void)localizeSymbols;

@end
