//
//  ApplicationInfo.m
//  Easy
//
//  Created by Jayce Yang on 13-9-13.
//  Copyright (c) 2013年 Easy. All rights reserved.
//

#import "ApplicationInfo.h"

#import "Macro.h"
#import "UIDevice+Easy.h"
#import "NSObject+Easy.h"

@interface ApplicationInfo ()

@end

@implementation ApplicationInfo

#pragma mark - NSCoding

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.UUID forKey:@"UUID"];
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self.UUID = [aDecoder decodeObjectForKey:@"UUID"];
    return self;
}

#pragma mark - NSCopying

- (id)copyWithZone:(NSZone *)zone
{
    ApplicationInfo *value = [[[self class] allocWithZone:zone] init];
    value.UUID = [self.UUID copyWithZone:zone];
    return value;
}

- (id)init
{
    self = [super init];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)dealloc
{
    
}

#pragma mark - Public

+ (instancetype)sharedInfo
{
    static ApplicationInfo *sharedInstance = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        
        ApplicationInfo *userInfo = [[self alloc] init];
        if ([[NSFileManager defaultManager] fileExistsAtPath:[userInfo filePath]]) {
            sharedInstance = [userInfo read];
        } else {
            // Make UUID when launch first time
            NSString *UUID = [[UIDevice currentDevice] UUIDString];
            DLog(@"Make UUID %@ first time.", UUID);
            userInfo.UUID = UUID;
            [userInfo clear];
            sharedInstance = userInfo;
        }
    });
    
    return sharedInstance;
}

- (void)write
{
    NSMutableData *data = [NSMutableData data];
    NSKeyedArchiver *keyedArchiver = [[NSKeyedArchiver alloc] initForWritingWithMutableData:data];
    [keyedArchiver encodeObject:self forKey:NSStringFromClass([self class])];
    [keyedArchiver finishEncoding];
    NSString *filePath = [self filePath];
    [data writeToFile:filePath atomically:YES];
}

- (void)clear
{
//    NSError *error = nil;
//    [[NSFileManager defaultManager] removeItemAtPath:[self filePath] error:&error];
//    if (error) {
//        DLog(@"%@", error.localizedDescription);
//    }
    
    // Clear any data you want
    
    [self write];
}

#pragma mark - Private

- (id)read
{
    NSString *filePath = [self filePath];
    NSData *data = [NSData dataWithContentsOfFile:filePath];
    NSKeyedUnarchiver *keyedUnarchiver = [[NSKeyedUnarchiver alloc] initForReadingWithData:data];
    ApplicationInfo *value = [keyedUnarchiver decodeObjectForKey:NSStringFromClass([self class])];
    [keyedUnarchiver finishDecoding];
    DLog(@"\nUUID:%@", value.UUID);
    
    return value;
}

- (NSString *)filePath
{
    NSString *directory = [self documentsPath];
    NSString *fileName = NSStringFromClass([self class]);
    NSString *extension = @"applicationInfo";
    return [[directory stringByAppendingPathComponent:fileName] stringByAppendingPathExtension:extension];
}

@end