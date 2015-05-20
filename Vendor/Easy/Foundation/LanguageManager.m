//
//  LanguageManager.m
//  DJIExhibition
//
//  Created by Jayce Yang on 14-9-3.
//  Copyright (c) 2014年 DJI. All rights reserved.
//

#import "LanguageManager.h"

#import "Easy.h"

@interface LanguageManager ()

@property (strong, nonatomic) NSBundle *bundle;

@end

@implementation LanguageManager

- (id)init
{
    self = [super init];
    if (self) {        
        self.language = [NSLocale preferredLanguage];
    }
    return self;
}

+ (instancetype)sharedManager
{
    static id sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[self alloc] init];
    });
    
    return sharedInstance;
}

- (void)setLanguage:(NSString *)language
{
    _language = language;
    
    NSString *path = [[NSBundle mainBundle ] pathForResource:language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    if (self.bundle == nil) {
        _language = @"en";
        self.bundle = [NSBundle bundleWithPath:[[NSBundle mainBundle ] pathForResource:_language ofType:@"lproj"]];
        NSLog(@"Tried to set language to %@, but ended up with %@", language, _language);
    } else {
//        NSLog(@"Setted language to %@", language);
    }
}

- (NSString *)localizedStringForKey:(NSString *)key value:(NSString *)value
{
    return [self.bundle localizedStringForKey:key value:value table:nil];
}

@end
