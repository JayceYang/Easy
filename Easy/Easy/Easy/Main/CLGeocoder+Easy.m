//
//  CLGeocoder+Easy.m
//  iGuest
//
//  Created by Jayce Yang on 7/4/13.
//  Copyright (c) 2013 FCS Shenzhen. All rights reserved.
//

#import "CLGeocoder+Easy.h"

#import "NSArray+Easy.h"

@implementation CLGeocoder (Easy)

#pragma mark - Geocode

+ (void)geocodeAddressString:(NSString *)addressString completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray *placemarks, NSError *error) {
        completionHandler([placemarks theFirstObject], error);
    }];
}

#pragma mark - Reverse geocode

+ (void)reverseGeocodeLocation:(CLLocation *)location completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler
{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    [geocoder reverseGeocodeLocation:location completionHandler:^(NSArray *placemarks, NSError *error) {
        completionHandler([placemarks theFirstObject],error);
    }];
}

+ (void)reverseGeocodeCoordinate:(CLLocationCoordinate2D)coordinate completionHandler:(EasyCLGeocodeCompletionHandler)completionHandler
{
    [self reverseGeocodeLocation:[[CLLocation alloc] initWithLatitude:coordinate.latitude longitude:coordinate.longitude] completionHandler:completionHandler];
}

@end
