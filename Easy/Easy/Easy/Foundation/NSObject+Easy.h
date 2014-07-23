//
//  NSObject+Easy.h
//  Easy
//
//  Created by Jayce Yang on 6/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

static CGFloat const kSafeHandlerDefaultDuration = 3.f;

static NSUInteger const kFractionDigitsDefault = 2;
NSString * valueWithFixedFractionDigits(CGFloat value, NSUInteger fractionDigits);
BOOL systemVersionGreaterThan(CGFloat value);
BOOL systemVersionGreaterThanOrEqualTo(CGFloat value);

BOOL floatEqualToFloat(float float1, float float2);
BOOL floatEqualToFloatWithAccuracyExponent(float float1, float float2 ,int accuracyExponent);
BOOL doubleEqualToDouble(double double1, double double2);
BOOL doubleEqualToDoubleWithAccuracyExponent(double double1, double double2 ,int accuracyExponent);

NSString *NSStringFromCLLocationCoordinate2D(CLLocationCoordinate2D coordinate);
NSString *NSStringFromMKCoordinateSpan(MKCoordinateSpan span);
NSString *NSStringFromMKCoordinateRegion(MKCoordinateRegion region);
NSString *NSStringFromCGSize(CGSize size);

@interface NSObject (Easy)

@property (strong, nonatomic) id extraUserInfo;

/*
 Value
 */

- (NSInteger)theIntegerValue;   //Return - 1 if cann't respond
- (BOOL)theBoolValue;   //Return NO if cann't respond
- (CGFloat)theFloatValue;   //Return 0 if cann't respond
- (double)theDoubleValue;   //Return 0 if cann't respond
- (NSString *)theStringValue;   //Return [NSString string] if cann't respond
- (NSDictionary *)theDictionaryValue;   //Return [NSDictionary dictionary] if cann't respond
- (NSArray *)theArrayValue;   //Return [NSArray array] if cann't respond

/*
 Directory
 */
- (NSString *)cachePath;
- (NSString *)documentsPath;
- (NSURL *)cacheURL;
- (NSURL *)documentsURL;

/*
 info
 */

+ (NSString *)bundleVersion;
+ (NSString *)bundleName;
+ (NSString *)bundleDisplayName;
+ (NSString *)bundleIdentifier;
+ (NSString *)currentCountry;
+ (NSString *)currentCountryCode;
+ (NSString *)launchImageName;

- (NSString *)bundleVersion;
- (NSString *)bundleName;
- (NSString *)bundleDisplayName;
- (NSString *)bundleIdentifier;
- (NSString *)currentCountry;
- (NSString *)currentCountryCode;
- (NSString *)launchImageName;

/*
 get
 */
- (NSInteger)userDefaultsIntegerForKey:(NSString *)key;
- (CGFloat)userDefaultsFloatForKey:(NSString *)key;
- (double)userDefaultsDoubleForKey:(NSString *)key;
- (BOOL)userDefaultsBoolForKey:(NSString *)key;
- (id)userDefaultsObjectForKey:(NSString *)key;

/*
 set
 */
- (void)userDefaultsSetInteger:(NSInteger)value forKey:(NSString *)key;
- (void)userDefaultsSetFloat:(CGFloat)value forKey:(NSString *)key;
- (void)userDefaultsSetDouble:(double)value forKey:(NSString *)key;
- (void)userDefaultsSetBool:(BOOL)value forKey:(NSString *)key;
- (void)userDefaultsSetValue:(id)value forKey:(NSString *)key;

/*
 remove
 */
- (void)userDefaultsRemoveObjectForKey:(NSString *)key;
- (void)clearUserDefaults;
- (void)clearUserDefaultsExceptForKeysContainsTheString:(NSString *)string;
- (void)clearUserDefaultsExceptForKeysInGroup:(NSArray *)group;

+ (UINavigationController *)currentNavigationController;
- (UINavigationController *)currentNavigationController;

- (void)performWithSafeHandler:(void (^)(void))handler;
- (void)performWithSafeHandler:(void (^)(void))handler duration:(NSTimeInterval)duration;

- (void)removeObserver:(NSObject *)observer forTheKeyPath:(NSString *)keyPath;

/*
 Content Size Change
 */

- (void)addPreferredContentSizeChangedObservingWithHandler:(void (^)(void))handler;
- (void)removePreferredContentSizeChangedObserving;

@end
