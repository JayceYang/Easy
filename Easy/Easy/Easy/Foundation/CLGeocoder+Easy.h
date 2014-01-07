//
//  CLGeocoder+Easy.h
//  Easy
//
//  Created by Jayce Yang on 7/4/13.
//  Copyright (c) 2013 Easy. All rights reserved.
//

#import <CoreLocation/CoreLocation.h>

typedef void(^EasyCLGeocodeCompletionHandler)(CLPlacemark *placemark, NSError *error);

@interface CLGeocoder (Easy)

+ (void)geocodeAddressString:(NSString *)addressString completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler;

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler;
+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler;

@end
