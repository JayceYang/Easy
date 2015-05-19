//
//  LanguageManager.h
//  DJIExhibition
//
//  Created by Jayce Yang on 14-9-3.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LocalizedString(key, comment) \
[[LanguageManager sharedManager] localizedStringForKey:key value:@""]
//#define LocalizedStringForKey(NSString *key) [[LanguageManager sharedManager] localizedStringForKey:key value:nil];

@interface LanguageManager : NSObject

@property (copy, nonatomic) NSString *language;

+ (instancetype)sharedManager;
- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value;

@end
