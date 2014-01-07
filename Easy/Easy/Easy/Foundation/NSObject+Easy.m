//
//  NSObject+Easy.m
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <objc/runtime.h>

#import "NSObject+Easy.h"
#import "NSMutableDictionary+Easy.h"

#import "ApplicationInfo.h"
#import "NSManagedObjectContext+Easy.h"
#import "Macro.h"

static char SafeHandlerKey;
static char SafeHandlerDateKey;

inline NSString * valueWithFixedFractionDigits(CGFloat value, NSUInteger fractionDigits)
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumIntegerDigits:1];
    [formatter setMinimumFractionDigits:fractionDigits];
    [formatter setMaximumFractionDigits:fractionDigits];
    return [formatter stringFromNumber:[NSNumber numberWithFloat:value]];
}

inline BOOL systemVersionGreaterThan(CGFloat value)
{
    BOOL result = NO;
    NSString *version = [NSString stringWithFormat:@"%f", value];
    if ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] == NSOrderedDescending) {
        result = YES;
    }

    return result;
}

inline BOOL systemVersionGreaterThanOrEqualTo(CGFloat value)
{
    BOOL result = NO;
    NSString *version = [NSString stringWithFormat:@"%f", value];
    if ([[[UIDevice currentDevice] systemVersion] compare:version options:NSNumericSearch] != NSOrderedAscending) {
        result = YES;
    }
    
    return result;
}

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    return [NSString stringWithFormat:@"latitude:%lf\tlongitude:%lf",coordinate.latitude,coordinate.longitude];
}

NSString *NSStringFromMKCoordinateSpan(MKCoordinateSpan span)
{
    return [NSString stringWithFormat:@"latitudeDelta:%lf\tlongitudeDelta:%lf",span.latitudeDelta,span.longitudeDelta];
}

NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region)
{
    return [NSString stringWithFormat:@"center:%@\nspan:%@",NSStringFromCLLocationCoordinate2D(region.center),NSStringFromMKCoordinateSpan(region.span)];
}

NSString *NSStringFromCGSize(CGSize size)
{
    return [NSString stringWithFormat:@"width:%lf\theight:%lf",size.width,size.height];
}

@interface NSObject ()

@property (copy, nonatomic) void (^safeHandler)(void);
@property (copy, nonatomic) NSDate *safeHandlerDate;

@end

@implementation NSObject (Easy)

#pragma mark - Value

+ (NSInteger)integerValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    } else {
        return 0;
    }
}

+ (BOOL)boolValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

+ (NSString *)stringValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

+ (NSDictionary *)dictionaryValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return [NSDictionary dictionary];
    }
}

- (NSInteger)integerValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    } else {
        return 0;
    }
}

- (BOOL)boolValueFromValue:(id)value
{
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (NSString *)stringValueFromValue:(id)value
{
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

- (NSInteger)theIntegerValue
{
    id value = self;
    if ([value respondsToSelector:@selector(integerValue)]) {
        return [value integerValue];
    } else {
        return - 1;
    }
}

- (BOOL)theBoolValue
{
    id value = self;
    if ([value respondsToSelector:@selector(boolValue)]) {
        return [value boolValue];
    } else {
        return NO;
    }
}

- (CGFloat)theFloatValue
{
    id value = self;
    if ([value respondsToSelector:@selector(floatValue)]) {
        return [value floatValue];
    } else {
        return 0.f;
    }
}

- (double)theDoubleValue
{
    id value = self;
    if ([value respondsToSelector:@selector(doubleValue)]) {
        return [value doubleValue];
    } else {
        return 0.;
    }
}

- (NSString *)theStringValue
{
    id value = self;
    if ([value isKindOfClass:[NSString class]]) {
        return value;
    } else if ([value respondsToSelector:@selector(stringValue)]) {
        return [value stringValue];
    } else {
        return [NSString string];
    }
}

- (NSDictionary *)theDictionaryValue
{
    id value = self;
    if ([value isKindOfClass:[NSDictionary class]]) {
        return value;
    } else {
        return [NSDictionary dictionary];
    }
}

- (NSArray *)theArrayValue
{
    id value = self;
    if ([value isKindOfClass:[NSArray class]]) {
        return value;
    } else {
        return [NSArray array];
    }
}

#pragma mark - Directory

- (NSString *)cachePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSString *)documentsPath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths lastObject];
}

- (NSURL *)cacheURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSURL *)documentsURL
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

#pragma mark - Info

/*
 Recommended Keys for iOS Apps
 It is recommended that an iOS app include the following keys in its information property list file. Most are set by Xcode automatically when you create your project.
 
 CFBundleDevelopmentRegion
 CFBundleDisplayName
 CFBundleExecutable
 CFBundleIconFiles
 CFBundleIdentifier
 CFBundleInfoDictionaryVersion
 CFBundlePackageType
 CFBundleVersion
 LSRequiresIPhoneOS
 UIMainStoryboardFile
 In addition to these keys, there are several that are commonly included:
 
 UIRequiredDeviceCapabilities (required)
 UIStatusBarStyle
 UIInterfaceOrientation
 UIRequiresPersistentWiFi
 */

+ (NSString *)bundleVersion
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleVersionKey];
}

+ (NSString *)bundleName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleName"];
}

+ (NSString *)bundleDisplayName
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"];
}

+ (NSString *)bundleIdentifier
{
    return [[[NSBundle mainBundle] infoDictionary] objectForKey:(NSString *)kCFBundleIdentifierKey];
}

+ (NSString *)country
{
    NSString *country = [[NSLocale currentLocale] displayNameForKey:NSLocaleCountryCode value:[self countryCode]];
    return country;
}

+ (NSString *)countryCode
{
    NSString *countryCode = [[NSLocale currentLocale] objectForKey:NSLocaleCountryCode];
    return countryCode;
}

+ (NSString *)launchImageName
{
    NSString *launchImageName = [[[NSBundle mainBundle] infoDictionary] objectForKey:@"UILaunchImageFile"];
    NSMutableString *result = nil;
    if (launchImageName.length > 0) {
        if (CGRectGetHeight([UIScreen mainScreen].bounds) > 480) {
            result = [launchImageName mutableCopy];
            NSRange range = [result rangeOfString:@"." options:NSBackwardsSearch];
            NSUInteger length = range.length;
            NSUInteger location = range.location;
            if (length > 0 && location > 0 && location < result.length - 1) {
                [result insertString:@"-568h" atIndex:location];
            }
            return [result copy];
        } else {
            return launchImageName;
        }
    } else {
        return nil;
    }
}

- (NSString *)bundleVersion
{
    return [[self class] bundleVersion];
}

- (NSString *)bundleName
{
    return [[self class] bundleName];
}

- (NSString *)bundleDisplayName
{
    return [[self class] bundleDisplayName];
}

- (NSString *)bundleIdentifier
{
    return [[self class] bundleIdentifier];
}

- (NSString *)country
{
    return [[self class] country];
}

- (NSString *)countryCode
{
    return [[self class] countryCode];
}

- (NSString *)launchImageName
{
    return [[self class] launchImageName];
}

#pragma mark - Get

- (NSInteger)userDefaultsIntegerForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults integerForKey:key];
}

- (CGFloat)userDefaultsFloatForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults floatForKey:key];
}
- (double)userDefaultsDoubleForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults doubleForKey:key];
}

- (BOOL)userDefaultsBoolForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults boolForKey:key];
}

- (id)userDefaultsObjectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    return [userDefaults objectForKey:key];
}

#pragma mark - Set

- (void)userDefaultsSetInteger:(NSInteger)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setInteger:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetFloat:(CGFloat)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setFloat:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetDouble:(double)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setDouble:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetBool:(BOOL)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setBool:value forKey:key];
    [userDefaults synchronize];
}

- (void)userDefaultsSetValue:(id)value forKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults setValue:value forKey:key];
    [userDefaults synchronize];
}

#pragma mark - Remove

- (void)userDefaultsRemoveObjectForKey:(NSString *)key
{
    NSUserDefaults *userDefaults = [NSUserDefaults standardUserDefaults];
    [userDefaults removeObjectForKey:key];
    [userDefaults synchronize];
}

- (void)clearUserDefaults
{
    [self clearUserDefaultsExceptForKeysContainsTheString:nil];
}

- (void)clearUserDefaultsExceptForKeysContainsTheString:(NSString *)string
{
    NSString *domainName = [self bundleIdentifier];
    NSMutableDictionary *prefrences = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:domainName]];
    [prefrences removeObjectsExceptForKeysContainsTheString:string];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefrences forName:domainName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (void)clearUserDefaultsExceptForKeysInGroup:(NSArray *)group
{
    NSString *domainName = [self bundleIdentifier];
    NSMutableDictionary *prefrences = [NSMutableDictionary dictionaryWithDictionary:[[NSUserDefaults standardUserDefaults] persistentDomainForName:domainName]];
    [prefrences removeObjectsExceptForKeysInGroup:group];
    [[NSUserDefaults standardUserDefaults] setPersistentDomain:prefrences forName:domainName];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

+ (UINavigationController *)currentNavigationController
{
    UINavigationController *navigationController = nil;
    UIWindow *keyWindow = [[[UIApplication sharedApplication] delegate] window];
    UIViewController *rootViewController = keyWindow.rootViewController;
    if ([rootViewController isKindOfClass:[UINavigationController class]]) {
        navigationController = (UINavigationController *)rootViewController;
    }
    
    return navigationController;
}

- (UINavigationController *)currentNavigationController
{
    return [[self class] currentNavigationController];
}

- (void (^)(void))safeHandler
{
    return objc_getAssociatedObject(self, &SafeHandlerKey);
}

- (void)setSafeHandler:(void (^)(void))safeHandler
{
    [self willChangeValueForKey:@"safeHandler"];
    objc_setAssociatedObject(self, &SafeHandlerKey, safeHandler, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"safeHandler"];
}

- (NSDate *)safeHandlerDate
{
    return objc_getAssociatedObject(self, &SafeHandlerDateKey);
}

- (void)setSafeHandlerDate:(NSDate *)safeHandlerDate
{
    [self willChangeValueForKey:@"safeHandlerDate"];
    objc_setAssociatedObject(self, &SafeHandlerDateKey, safeHandlerDate, OBJC_ASSOCIATION_COPY_NONATOMIC);
    [self didChangeValueForKey:@"safeHandlerDate"];
}

- (void)performWithSafeHandler:(void (^)(void))handler
{
    [self performWithSafeHandler:handler duration:kSafeHandlerDefaultDuration];
}

- (void)performWithSafeHandler:(void (^)(void))handler duration:(NSTimeInterval)duration
{
    if (handler) {
        NSDate *now = [NSDate date];
        if (self.safeHandlerDate == nil || [now timeIntervalSinceDate:self.safeHandlerDate] > duration) {
            self.safeHandlerDate = now;
            handler();
        } else {
            DLog(@"You wanna me to die ? -> No way !");
        }
    }
}

- (void)removeObserver:(NSObject *)observer forTheKeyPath:(NSString *)keyPath
{
    @try {
        [self removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        DLog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

@end