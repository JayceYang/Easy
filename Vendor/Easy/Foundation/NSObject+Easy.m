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

static char ExtraUserInfoKey;
static char SafeHandlerKey;
static char SafeHandlerDateKey;

inline NSString * valueWithDefaultFractionDigits(NSNumber *value)
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumIntegerDigits:1];
    [formatter setMinimumFractionDigits:kFractionDigitsDefault];
    [formatter setMaximumFractionDigits:kFractionDigitsDefault];
    return [formatter stringFromNumber:value];
}

inline NSString * valueWithFixedFractionDigits(NSNumber *value, NSUInteger fractionDigits)
{
    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setMinimumIntegerDigits:1];
    [formatter setMinimumFractionDigits:fractionDigits];
    [formatter setMaximumFractionDigits:fractionDigits];
    return [formatter stringFromNumber:value];
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

inline BOOL floatEqualToFloat(float float1, float float2)
{
    return fabsf(float1 - float2) <= pow(10, - 6);
}

inline BOOL floatEqualToFloatWithAccuracyExponent(float float1, float float2 ,int accuracyExponent)
{
    return fabsf(float1 - float2) <= pow(10, - accuracyExponent);
}

inline BOOL doubleEqualToDouble(double double1, double double2)
{
    return fabs(double1 - double2) <= pow(10, - 6);
}

inline BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent)
{
    return fabs(double1 - double2) <= pow(10, - accuracyExponent);
}

inline NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate)
{
    return [NSString stringWithFormat:@"latitude:%lf\tlongitude:%lf",coordinate.latitude,coordinate.longitude];
}

inline NSString *NSStringFromMKCoordinateSpan(MKCoordinateSpan span)
{
    return [NSString stringWithFormat:@"latitudeDelta:%lf\tlongitudeDelta:%lf",span.latitudeDelta,span.longitudeDelta];
}

inline NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region)
{
    return [NSString stringWithFormat:@"center:%@\nspan:%@",NSStringFromCLLocationCoordinate2D(region.center),NSStringFromMKCoordinateSpan(region.span)];
}

inline NSString *NSStringFromCGSize(CGSize size)
{
    return [NSString stringWithFormat:@"width:%lf\theight:%lf",size.width,size.height];
}

@interface NSObject ()

@property (copy, nonatomic) void (^safeHandler)(void);
@property (copy, nonatomic) NSDate *safeHandlerDate;

@end

@implementation NSObject (Easy)

- (id)extraUserInfo
{
    return objc_getAssociatedObject(self, &ExtraUserInfoKey);
}

- (void)setExtraUserInfo:(id)extraUserInfo
{
    [self willChangeValueForKey:@"extraUserInfo"];
    objc_setAssociatedObject(self, &ExtraUserInfoKey, extraUserInfo, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
    [self didChangeValueForKey:@"extraUserInfo"];
}

#pragma mark - Value

+ (NSInteger)integerValueFromValue:(id)value
{
    return [value theIntegerValue];
}

+ (BOOL)boolValueFromValue:(id)value
{
    return [value theBoolValue];
}

+ (NSString *)stringValueFromValue:(id)value
{
    return [value theStringValue];
}

+ (NSDictionary *)dictionaryValueFromValue:(id)value
{
    return [value theDictionaryValue];
}

- (NSInteger)integerValueFromValue:(id)value
{
    return [value theIntegerValue];
}

- (BOOL)boolValueFromValue:(id)value
{
    return [value theBoolValue];
}

- (NSString *)stringValueFromValue:(id)value
{
    return [value theStringValue];
}

- (NSInteger)theIntegerValue
{
    return [self theIntegerValueWithDefaultValue:0];
}

- (BOOL)theBoolValue
{
    return [self theBoolValueWithDefaultValue:NO];
}

- (float)theFloatValue
{
    return [self theFloatValueWithDefaultValue:0.0f];
}

- (double)theDoubleValue
{
    return [self theDoubleValueWithDefaultValue:0.0];
}

- (NSString *)theStringValue
{
    return [self theStringValueWithDefaultValue:[NSString string]];
}

- (NSDictionary *)theDictionaryValue
{
    return [self theDictionaryValueWithDefaultValue:nil];
}

- (NSArray *)theArrayValue
{
    return [self theArrayValueWithDefaultValue:nil];
}

- (NSInteger)theIntegerValueWithDefaultValue:(NSInteger)value
{
    id sourceValue = self;
    if ([sourceValue respondsToSelector:@selector(integerValue)]) {
        return [sourceValue integerValue];
    } else {
        return value;
    }
}

- (BOOL)theBoolValueWithDefaultValue:(BOOL)value
{
    id sourceValue = self;
    if ([sourceValue respondsToSelector:@selector(boolValue)]) {
        return [sourceValue boolValue];
    } else {
        return value;
    }
}

- (float)theFloatValueWithDefaultValue:(CGFloat)value
{
    id sourceValue = self;
    if ([sourceValue respondsToSelector:@selector(floatValue)]) {
        return [sourceValue floatValue];
    } else {
        return value;
    }
}

- (double)theDoubleValueWithDefaultValue:(double)value
{
    id sourceValue = self;
    if ([sourceValue respondsToSelector:@selector(doubleValue)]) {
        return [sourceValue doubleValue];
    } else {
        return value;
    }
}

- (NSString *)theStringValueWithDefaultValue:(NSString *)value
{
    id sourceValue = self;
    if ([sourceValue respondsToSelector:@selector(stringValue)]) {
        return [sourceValue stringValue];
    } else {
        return value;
    }
}

- (NSDictionary *)theDictionaryValueWithDefaultValue:(NSDictionary *)value
{
    id sourceValue = self;
    if ([sourceValue isKindOfClass:[NSDictionary class]]) {
        return sourceValue;
    } else {
        return value;
    }
}

- (NSArray *)theArrayValueWithDefaultValue:(NSArray *)value
{
    id sourceValue = self;
    if ([sourceValue isKindOfClass:[NSArray class]]) {
        return sourceValue;
    } else {
        return value;
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

- (void)performBlockOnMainThread:(void (^)(void))handler
{
    if ([NSThread isMainThread]) {
        if (handler) {
            handler();
        }
    } else {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (handler) {
                handler();
            }
        });
    }
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
            ELog(@"You wanna me to die ? -> No way !");
        }
    }
}

- (void)removeObserver:(NSObject *)observer forTheKeyPath:(NSString *)keyPath
{
    @try {
        [self removeObserver:observer forKeyPath:keyPath];
    }
    @catch (NSException *exception) {
        ELog(@"%@", exception.reason);
    }
    @finally {
        
    }
}

- (void)addPreferredContentSizeChangedObservingWithHandler:(void (^)(void))handler
{
    [[NSNotificationCenter defaultCenter] addObserverForName:UIContentSizeCategoryDidChangeNotification object:nil queue:[NSOperationQueue mainQueue] usingBlock:^(NSNotification *note) {
        if (handler) {
            handler();
        }
    }];
}

- (void)removePreferredContentSizeChangedObserving
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIContentSizeCategoryDidChangeNotification object:nil];
}

+ (void)runInMainLoopUsingBlock:(void (^)(BOOL *completed))block
{
    __block BOOL completed = NO;
    block(&completed);
    while (!completed) {
        [[NSRunLoop mainRunLoop] runUntilDate:[NSDate dateWithTimeIntervalSinceNow:.1]];
    }
    
//    dispatch_semaphore_t sem = dispatch_semaphore_create(0);
//    doSomethingAsynchronouslyWithBlock(^{
//        //...
//        dispatch_semaphore_signal(sem);
//    });
//    
//    dispatch_semaphore_wait(sem, DISPATCH_TIME_FOREVER);
}

- (void)runInMainLoopUsingBlock:(void (^)(BOOL *completed))block
{
    [[self class] runInMainLoopUsingBlock:block];
}

- (NSString *)userAgent
{
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectZero];
    return [webView stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
}

@end