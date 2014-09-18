//
//  MettLocationServiceAuthorization.m
//  sunrise
//
//  Created by Jo Brunner on 09.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@import CoreLocation;

#import "LocationService.h"


@implementation LocationService


+ (BOOL)isEnabled
{
    BOOL isLocationService = [CLLocationManager locationServicesEnabled];
    
    if (isLocationService == YES) {
        
        // GPS exists and is enabled.
        NSLog(@"Location Service enabled.");

        return YES;
    } else {

        // No GPS service detected. Can be also an authorization restriction?!
        NSLog(@"Location Service not enabled.");
        
        return NO;
    }
}

+ (BOOL)isAuthorized
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (kCLAuthorizationStatusNotDetermined == authorizationStatus) {
        // User hat keine Angaben gemacht
        NSLog(@"authorizationStatus: kCLAuthorizationStatusNotDetermined");

        return YES;
        
    } else if (kCLAuthorizationStatusRestricted == authorizationStatus) {
        
        // User gibt keinen Zugriff auf *diese* App
        NSLog(@"authorizationStatus: kCLAuthorizationStatusRestricted");
        
    } else if (kCLAuthorizationStatusDenied == authorizationStatus) {
        
        // User gibt explizit keinen Zugriff auf die App
        NSLog(@"authorizationStatus: kCLAuthorizationStatusDenied");
        
    } else if (kCLAuthorizationStatusAuthorized == authorizationStatus) {
        
        // Zugriff authorisiert!
        NSLog(@"authorizationStatus: kCLAuthorizationStatusAuthorized");
        
        return YES;
    }
    
    return NO;
}


@end
