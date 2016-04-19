//
//  MettConversion.m
//  sunrise
//
//  Created by Jo Brunner on 10.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@import CoreLocation;

#import "Conversion.h"
#import "CoordinateSystem.h"
#import "GTWConversionManager.h"

@implementation Conversion

- (NSString *)locationToAltitude:(CLLocation *)location
                withUnitOfLength:(UnitOfLength)unitOfLength {
    
    return [self altitude:location.altitude
         withUnitOfLength:unitOfLength];
}

- (NSString *)locationToHorizontalAccuracy:(CLLocation *)location
                          withUnitOfLength:(UnitOfLength)unitOfLength {
    
    return [self accuracy:location.horizontalAccuracy
         withUnitOfLength:unitOfLength];
}

- (NSString *)locationToVerticalAccuracy:(CLLocation *)location
                        withUnitOfLength:(UnitOfLength)unitOfLength {

    return [self accuracy:location.verticalAccuracy
         withUnitOfLength:unitOfLength];
}

- (NSString *)altitude:(CLLocationDistance)altitude
      withUnitOfLength:(UnitOfLength)unitOfLength {
    
    NSString *symbol;
    
    switch (unitOfLength) {
        case kUnitOfLengthFoot:
            altitude = altitude * 3.2808399;
            symbol = @"ft";
            break;
            
        case kUnitOfLengthMeter:
        default:
            symbol = @"m";
            break;
    }
    
    return [NSString stringWithFormat:@"%i %@", (int)(altitude + 0.5), symbol];
}

- (NSString *)accuracy:(CLLocationAccuracy)accuracy
      withUnitOfLength:(UnitOfLength)unitOfLength {
    
    NSString *symbol;
    
    switch (unitOfLength) {
        case kUnitOfLengthFoot:
            accuracy = accuracy * 3.2808399;
            symbol = @"ft";
            break;
            
        case kUnitOfLengthMeter:
        default:
            symbol = @"m";
            break;
    }
    
    return [NSString stringWithFormat:@"±%i %@", (int)(accuracy + 0.5), symbol];
}

// Kartendatum wird aktuell noch nicht unterstützt. Das Source-Datum ist immer WGS84.
- (NSString *)locationToCoordinates:(CLLocation *)location
                   coordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    switch (coordinateSystem.system) {
        case kCoordinateSystemGeodetic:
            return [self geodeticWithLocation:location
                             coordinateSystem:coordinateSystem];
            
        case kCoordinateSystemMGRS:
            return [self mgrsWithLocation:location
                         coordinateSystem:coordinateSystem];

        case kCoordinateSystemUTM:
            return [self utmWithLocation:location
                        coordinateSystem:coordinateSystem];

        default:
            NSLog(@"NSError here");
            break;
    }

    return @"";
}


- (NSString *)utmWithLocation:(CLLocation *)location
             coordinateSystem:(CoordinateSystem *)coordinateSystem {

    GTWConversionManager *coordConverter = [GTWConversionManager new];
    
    NSError *error = nil;

    // must support grid zones vs. heading
    
    switch (coordinateSystem.format) {
        case kCoordinateFormatUTMWithDirection:
            return [coordConverter utmWithLocationCoordinates:location.coordinate
                                           formatWithGridZone:NO
                                                        error:&error];
        case kCoordinateFormatUTMWithGridZone:
        default:
            return [coordConverter utmWithLocationCoordinates:location.coordinate
                                           formatWithGridZone:YES
                                                        error:&error];
    }
}

- (NSString *)mgrsWithLocation:(CLLocation *)location
              coordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    GTWConversionManager *coordConverter = GTWConversionManager.new;
    
    NSError *error = nil;

    switch (coordinateSystem.format) {
        case kCoordinateFormatMGRSDefault:
            return [coordConverter mgrsWithLocationCoordinates:location.coordinate
                                                     precision:5
                                              formatWithSpaces:NO
                                                         error:&error];
        case kCoordinateFormatMGRSWithSpaces:
        default:
            return [coordConverter mgrsWithLocationCoordinates:location.coordinate
                                                     precision:5
                                              formatWithSpaces:YES
                                                         error:&error];
    }
    
//    if (error != nil) {
//        NSLog(@"%@", error.userInfo);
//        return @"";
//    }
//    
//    return mgrsString;
}

- (NSString *)degreesMinutesSeconds:(CLLocation *)location
                    withhemisphere:(BOOL)hemisphere
                          seperator:(NSString *)seperator
                          andLocale:(NSLocale *)locale
               andLeadingHemisphere:(BOOL)leadingHemisphere {
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *lat;
    NSString *lng;
    
    int hours;
    int minutes;
    float seconds;
    
    hours   = floor(fabs(latitude));
    minutes = floor((fabs(latitude) - hours) * 60);
    seconds = ((fabs(latitude) - hours - minutes / 60) * 60 - minutes) * 60;

    if (hemisphere) {
        NSString *latHemisphere = (latitude < 0 ) ? @"S" : @"N";

        if (leadingHemisphere) {
            lat = [[NSString alloc] initWithFormat:@"%@%u°%u'%01.1f\""
                                            locale:locale,
                   latHemisphere,
                   hours,
                   minutes,
                   seconds];
        }
        else {
            lat = [[NSString alloc] initWithFormat:@"%u°%u'%01.1f\"%@"
                                            locale:locale,
                   hours,
                   minutes,
                   seconds,
                   latHemisphere];
        }
    }
    else {
        lat = [[NSString alloc] initWithFormat:@"%@%u°%u\'%.1f\""
                                        locale:locale,
               [self signumString:(float)latitude],
               hours,
               minutes,
               seconds];
    }
    
    // +070°38'21,2
    hours   = floor(fabs(longitude));
    minutes = floor((fabs(longitude) - hours) * 60);
    seconds = ((fabs(longitude) - hours - minutes / 60) * 60 - minutes) * 60;
    
    if (hemisphere) {
        NSString *lnghemisphere = (longitude < 0 ) ? @"W" : @"E";
        if (leadingHemisphere) {
            lng = [[NSString alloc] initWithFormat:@"%@%03u°%02u\'%02.1f\""
                                            locale:locale,
                   lnghemisphere,
                   hours,
                   minutes,
                   seconds];
        }
        else {
            lng = [[NSString alloc] initWithFormat:@"%03u°%02u\'%02.1f\"%@"
                                            locale:locale,
                   hours,
                   minutes,
                   seconds,
                   lnghemisphere];
        }
    }
    else {
        lng = [[NSString alloc] initWithFormat:@"%@%03u°%02u\'%02.1f\""
                                        locale:locale,
               [self signumString:(float)longitude],
               hours,
               minutes,
               seconds];
    }

    return [NSString stringWithFormat:@"%@%@%@", lat, seperator, lng];
}

- (NSString *)degreesMinutes:(CLLocation *)location
             withhemisphere:(BOOL)hemisphere
                   seperator:(NSString *)seperator
                   andLocale:(NSLocale *)locale
        andLeadingHemisphere:(BOOL)leadingHemisphere {
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *lat;
    NSString *lng;
    
    int hours;
    float minutes;
    
    hours   = floor(fabs(latitude));
    minutes = (latitude - hours) * 60;
    
    if (hemisphere) {
        NSString *latHemisphere = (latitude < 0 ) ? @"S" : @"N";

        if (leadingHemisphere) {
            lat = [[NSString alloc] initWithFormat:@"%@%02u°%02.2f'"
                                            locale:locale,
                   latHemisphere,
                   hours,
                   minutes];
        }
        else {
            lat = [[NSString alloc] initWithFormat:@"%02u°%02.2f'%@"
                                            locale:locale,
                   hours,
                   minutes,
                   latHemisphere];
        }
    }
    else {
        lat = [[NSString alloc] initWithFormat:@"%@%02u°%02.2f'"
                                        locale:locale,
               [self signumString:(float)latitude],
               hours,
               minutes];
    }
    
    hours   = floor(fabs(longitude));
    minutes = (longitude - hours) * 60;
    
    if (hemisphere) {
        NSString *lnghemisphere = (longitude < 0 ) ? @"W" : @"E";
        if (leadingHemisphere) {
            lng = [[NSString alloc] initWithFormat:@"%@%03u°%02.2f'"
                                            locale:locale,
                   lnghemisphere,
                   hours,
                   minutes];
        }
        else {
            lng = [[NSString alloc] initWithFormat:@"%03u°%02.2f'%@"
                                            locale:locale,
                   hours,
                   minutes,
                   lnghemisphere];
        }
    }
    else {
        lng = [[NSString alloc] initWithFormat:@"%@%03u°%02.2f'"
                                        locale:locale,
               [self signumString:(float)latitude],
               hours,
               minutes];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", lat, seperator, lng];
}

- (NSString *)decimal:(CLLocation *)location
      withhemisphere:(BOOL)hemisphere
            seperator:(NSString *)seperator
            andLocale:(NSLocale *)locale
 andLeadingHemisphere:(BOOL)leadingHemisphere {
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *lat;
    NSString *lng;
    
    if (hemisphere) {
        NSString *latHemisphere = (latitude < 0 ) ? @"S" : @"N";

        if (leadingHemisphere) {
            lat = [[NSString alloc] initWithFormat:@"%@%.6f"
                                            locale:locale,
                   latHemisphere,
                   fabs(latitude)];
        }
        else {
            lat = [[NSString alloc] initWithFormat:@"%.6f%@"
                                            locale:locale,
                   fabs(latitude),
                   latHemisphere];
        }
    }
    else {
        lat = [[NSString alloc] initWithFormat:@"%@%.6f"
                                        locale:locale,
               [self signumString:(float)latitude],
               fabs(latitude)];
    }
    
    if (hemisphere) {

        NSString *lnghemisphere = (longitude < 0 ) ? @"W" : @"E";
        if (leadingHemisphere) {
            lng = [NSString localizedStringWithFormat:@"%@%.6f",
                   lnghemisphere,
                   fabs(longitude)];
        }
        else {
            lng = [NSString localizedStringWithFormat:@"%0.6f%@",
                   fabs(longitude),
                   lnghemisphere];
        }
    }
    else {
        lng = [NSString localizedStringWithFormat:@"%@%.6f",
               [self signumString:(float)longitude],
               fabs(longitude)];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", lat, seperator, lng];
}

- (NSString *)degrees:(CLLocation *)location
      withhemisphere:(BOOL)hemisphere
            seperator:(NSString *)seperator
            andLocale:(NSLocale *)locale
 andLeadingHemisphere:(BOOL)leadingHemisphere {
    
    CLLocationDegrees latitude = location.coordinate.latitude;
    CLLocationDegrees longitude = location.coordinate.longitude;
    NSString *lat;
    NSString *lng;
    
    if (hemisphere) {
        NSString *latHemisphere = (latitude < 0 ) ? @"S" : @"N";

        if (leadingHemisphere) {
            lat = [NSString localizedStringWithFormat:@"%@%.6f°",
                   latHemisphere,
                   fabs(latitude)];
        }
        else {
            lat = [NSString localizedStringWithFormat:@"%.6f°%@",
                   fabs(latitude),
                   latHemisphere];
        }
    }
    else {
        lat = [NSString localizedStringWithFormat:@"%@%.6f°",
               [self signumString:(float)latitude],
               fabs(latitude)];
    }
    
    if (hemisphere) {
        NSString *lnghemisphere = (longitude < 0 ) ? @"W" : @"E";
        if (leadingHemisphere) {
            lng = [NSString localizedStringWithFormat:@"%@%010.6f°",
                   lnghemisphere,
                   fabs(longitude)];
        }
        else {
            lng = [NSString localizedStringWithFormat:@"%010.6f°%@",
                   fabs(longitude),
                   lnghemisphere];
        }
    }
    else {
        lng = [NSString localizedStringWithFormat:@"%@%010.6f°",
               [self signumString:(float)longitude],
               fabs(longitude)];
    }
    
    return [NSString stringWithFormat:@"%@%@%@", lat, seperator, lng];
}

- (NSString *)geodeticWithLocation:(CLLocation *)location
                  coordinateSystem:(CoordinateSystem *)coordinateSystem {

    switch (coordinateSystem.format) {
        case kCoordinateFormatGeodeticDegreesMinutesSecondsDirection:
            return [self degreesMinutesSeconds:location
                               withhemisphere:YES
                                     seperator:coordinateSystem.seperator
                                     andLocale:coordinateSystem.localeForDecimals
                          andLeadingHemisphere:coordinateSystem.leadingHemisphere];
            
        case kCoordinateFormatGeodeticDegreesMinutesSecondsSign:
            return [self degreesMinutesSeconds:location
                               withhemisphere:NO
                                     seperator:coordinateSystem.seperator
                                     andLocale:coordinateSystem.localeForDecimals
                          andLeadingHemisphere:coordinateSystem.leadingHemisphere];
            
        case kCoordinateFormatGeodeticDegreesMinutesDirection:
            return [self degreesMinutes:location
                        withhemisphere:YES
                              seperator:coordinateSystem.seperator
                              andLocale:coordinateSystem.localeForDecimals
                   andLeadingHemisphere:coordinateSystem.leadingHemisphere];

        case kCoordinateFormatGeodeticDegreesMinutesSign:
            return [self degreesMinutes:location
                        withhemisphere:NO
                              seperator:coordinateSystem.seperator
                              andLocale:coordinateSystem.localeForDecimals
                   andLeadingHemisphere:coordinateSystem.leadingHemisphere];
            
        case kCoordinateFormatGeodeticDegreesDirection:
            return [self degrees:location
                 withhemisphere:YES
                       seperator:coordinateSystem.seperator
                       andLocale:coordinateSystem.localeForDecimals
            andLeadingHemisphere:coordinateSystem.leadingHemisphere];

        case kCoordinateFormatGeodeticDegreesSign:
            return [self degrees:location
                 withhemisphere:NO
                       seperator:coordinateSystem.seperator
                       andLocale:coordinateSystem.localeForDecimals
            andLeadingHemisphere:coordinateSystem.leadingHemisphere];

        case kCoordinateFormatGeodeticDecimalDirection:
            return [self decimal:location
                 withhemisphere:YES
                       seperator:coordinateSystem.seperator
                       andLocale:coordinateSystem.localeForDecimals
            andLeadingHemisphere:coordinateSystem.leadingHemisphere];

        case kCoordinateFormatGeodeticDecimalSign:
        default:
            return [self decimal:location
                 withhemisphere:NO
                       seperator:coordinateSystem.seperator
                       andLocale:coordinateSystem.localeForDecimals
            andLeadingHemisphere:coordinateSystem.leadingHemisphere];
    }
}

#pragma mark - Format Helpers

- (NSString *)signumString:(float)value {
    
    if (value < 0) {
        return @"-";
    } else {
        return @"+";
    }
}

- (NSString *)signumStringWithNumber:(NSNumber *)value {

    if ([value floatValue] < 0.0) {
        return @"-";
    } else {
        return @"+";
    }
}

@end
