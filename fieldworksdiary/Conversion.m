//
//  MettConversion.m
//  sunrise
//
//  Created by Jo Brunner on 10.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@import CoreLocation;

#import "Conversion.h"

@implementation Conversion

- (NSString *)locationToAltitude:(CLLocation *)location
                withUnitOfLength:(UnitOfLength)unitOfLength
{
    if (unitOfLength == kUnitOfLengthMeter) {
        // no conversion needed.
    } else {
        // convert as needed.
    }
    
    NSString *altitude = [NSString stringWithFormat:@"%im", (int)(location.altitude + 0.5)];
    
    return altitude;
}


- (NSString *)locationToHorizontalAccuracy:(CLLocation *)location
                          withUnitOfLength:(UnitOfLength)unitOfLength
{
    if (unitOfLength == kUnitOfLengthMeter) {
        // no conversion needed.
    } else {
        // convert as needed.
    }
    
    NSString *accuracy = [NSString stringWithFormat:@"±%im", (int)(location.horizontalAccuracy + 0.5)];
    
    return accuracy;
}


- (NSString *)locationToVerticalAccuracy:(CLLocation *)location
                        withUnitOfLength:(UnitOfLength)unitOfLength
{
    if (unitOfLength == kUnitOfLengthMeter) {
        // no conversion needed.
    } else {
        // convert as needed.
    }
    
    NSString *accuracy = [NSString stringWithFormat:@"±%im", (int)(location.verticalAccuracy + 0.5)];
    
    return accuracy;
}


// Kartendatum wird aktuell noch nicht unterstützt. Das Source-Datum ist immer WGS84.
- (NSString *)locationToCoordinates:(CLLocation *)location
                             format:(CoordinateFormat)format
                           mapDatum:(MapDatum)mapDatum
{
    if (mapDatum == kMapDatumWGS1984) {
        // nothing to do
    } else {
        // convert coordinates from WGS84 to target map datum.
        NSLog(@"mapDatum not implemented yet.");
    }
    
    if (format == kCoordinateFormatGeodeticDecimal) {
        // nothing to do
    } else {
        // convert decimal degrees into format needed
        NSLog(@"CoordinateFormat not implemented yet.");
    }

    NSString *lat = [NSString localizedStringWithFormat:@"%@%.6f",
                     [self signumString:(float)location.coordinate.latitude],
                     fabs(location.coordinate.latitude)];
    
    NSString *lng = [NSString localizedStringWithFormat:@"%@%.6f",
                     [self signumString:(float)location.coordinate.longitude],
                     fabs(location.coordinate.longitude)];
    
    NSString *coords = [NSString stringWithFormat:@"%@;%@", lat, lng];
    
    return coords;
}

//
//// Kartendatum wird aktuell noch nicht unterstützt. Das Source-Datum ist immer WGS84.
//- (NSString *)localityToCoordinates:(Locality *)locality format:(MettCoordinateFormat)format mapDatum:(MettMapDatum)mapDatum
//{
//    if (mapDatum == kMettMapDatumWGS1984) {
//        // nothing to do
//    } else {
//        // convert coordinates from WGS84 to target map datum.
//    }
//    
//    if (format == kMettCoordinateFormatGeodeticDecimal) {
//        // nothing to do
//    } else {
//        // convert decimal degrees into format needed
//    }
//    
//    NSString *lat = [NSString localizedStringWithFormat:@"%@%f.6",
//                     [self signumString:locality.latitude],
//                     fabs(locality.latitude)];
//    
//    NSString *lng = [NSString localizedStringWithFormat:@"%@%.6f",
//                     [self signumString:locality.longitude],
//                     fabs(locality.longitude)];
//    
//    NSString *coords = [NSString stringWithFormat:@"%@,%@", lat, lng];
//    
//    return coords;
//}



#pragma mark - Format Helpers -

// ??? find a better place!!!
- (NSString *)signumString:(float)value
{
    if (value < 0) {
        return @"-";
    } else {
        return @"+";
    }
}


// ??? find a better place!!!
- (NSString *)signumStringWithNumber:(NSNumber *)value
{
//    float v = [value floatValue];
    if ([value floatValue] < 0.0) {
        return @"-";
    } else {
        return @"+";
    }
}


@end
