//
//  Placemark.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 17.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@import CoreLocation;

#import "Placemark.h"

@implementation Placemark

- (id)initWithPlacemark:(CLPlacemark *)placemark {

    self = [super init];

    if (self) {
        self.country                = placemark.country;
        self.ISOcountryCode         = placemark.ISOcountryCode;
        self.administrativeArea     = placemark.administrativeArea;
        self.subAdministrativeArea  = placemark.subAdministrativeArea;
        self.locality               = placemark.locality;
        self.subLocality            = placemark.subLocality;
        self.ocean                  = placemark.ocean;
        self.inlandWater            = placemark.inlandWater;
    }
    
    return self;
}

- (id)initWithGoogleLocationDict:(NSDictionary *)location {
    
    self = [super init];
    if (self) {
        self.country                = [location valueForKey:@"country"];
        self.ISOcountryCode         = [location valueForKey:@"countryCodeIso"];
        self.administrativeArea     = [location valueForKey:@"administrative_area_level_1"];
        self.subAdministrativeArea  = [location valueForKey:@"administrative_area_level_2"];
        self.locality               = [location valueForKey:@"administrative_area_level_3"];
        self.subLocality            = [location valueForKey:@"administrative_area_level_4"];
//        self.locality               = [location valueForKey:@"locality"];
//        self.subLocality            = [location valueForKey:@"sublocality"];
        self.ocean                  = nil;
        self.inlandWater            = nil;
    }
    
    return self;
}

+ (NSString *)stringFromPlacemark:(Placemark *)placemark {

    if (placemark == nil) {
        
        return @"";
    }
    
    NSMutableArray *lineQueue = NSMutableArray.new;

    NSArray *firstLineFields = @[placemark.country,
                                 placemark.administrativeArea];

    for (NSString *value in firstLineFields) {
        if (value == nil || [value isEqualToString:@""]) {

            continue;
        }
        
        if (![lineQueue containsObject:value]) {
            [lineQueue addObject:value];
        }
    }
    
    NSString *resultingFirstLine = [lineQueue componentsJoinedByString:@", "];

    [lineQueue removeAllObjects];
    
    NSArray *secondLineFields = @[placemark.subAdministrativeArea,
                                  placemark.locality,
                                  placemark.subLocality];

    for (NSString *value in secondLineFields) {
        if (value == nil || [value isEqualToString:@""]) {
            
            continue;
        }

        if (![lineQueue containsObject:value]) {
            [lineQueue addObject:value];
        }
    }

    NSString *resultingSecondLine = [lineQueue componentsJoinedByString:@", "];
    
    return [@[resultingFirstLine, resultingSecondLine] componentsJoinedByString:@"\n"];
}

@end
