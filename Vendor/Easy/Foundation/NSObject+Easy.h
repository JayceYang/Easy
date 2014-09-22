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
NSString * valueWithDefaultFractionDigits(NSNumber *value);
NSString * valueWithFixedFractionDigits(NSNumber *value, NSUInteger fractionDigits);
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

- (NSInteger)theIntegerValue;   //Return 0 if can't respond
- (BOOL)theBoolValue;   //Return NO if can't respond
- (float)theFloatValue;   //Return 0.0f if can't respond
- (double)theDoubleValue;   //Return 0.0 if can't respond
- (NSString *)theStringValue;   //Return [NSString string] if can't respond
- (NSDictionary *)theDictionaryValue;   //Return nil if can't respond
- (NSArray *)theArrayValue;   //Return nil if can't respond

- (NSInteger)theIntegerValueWithDefaultValue:(NSInteger)value;   //Return the default value if can't respond
- (BOOL)theBoolValueWithDefaultValue:(BOOL)value;   //Return the default value if can't respond
- (float)theFloatValueWithDefaultValue:(CGFloat)value;   //Return the default value if can't respond
- (double)theDoubleValueWithDefaultValue:(double)value;   //Return the default value if can't respond
- (NSString *)theStringValueWithDefaultValue:(NSString *)value;   //Return the default value if can't respond
- (NSDictionary *)theDictionaryValueWithDefaultValue:(NSDictionary *)value;   //Return the default value if can't respond
- (NSArray *)theArrayValueWithDefaultValue:(NSArray *)value;   //Return the default value if can't respond

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
+ (NSString *)launchImageName;

- (NSString *)bundleVersion;
- (NSString *)bundleName;
- (NSString *)bundleDisplayName;
- (NSString *)bundleIdentifier;
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

- (void)performBlockOnMainThread:(void (^)(void))handler;
- (void)performWithSafeHandler:(void (^)(void))handler;
- (void)performWithSafeHandler:(void (^)(void))handler duration:(NSTimeInterval)duration;

- (void)removeObserver:(NSObject *)observer forTheKeyPath:(NSString *)keyPath;

/*
 Content Size Change
 */

- (void)addPreferredContentSizeChangedObservingWithHandler:(void (^)(void))handler;
- (void)removePreferredContentSizeChangedObserving;

/*
 Run Loop
 */
+ (void)runInMainLoopUsingBlock:(void (^)(BOOL *completed))block;
- (void)runInMainLoopUsingBlock:(void (^)(BOOL *completed))block;

- (NSString *)userAgent;

@end
