//
//  CoordinateSystem.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "CoordinateSystem.h"

@implementation CoordinateSystem

- (instancetype)initWithSystem:(CoordinateSystems)system
                         datum:(MapDatums)datum
                        format:(CoordinateFormats)format
             localeForDecimals:(NSLocale *)locale
            leadingHemisphere:(BOOL)leadingHemisphere
                     seperator:(NSString *)seperator {

    if (self = [super init]) {
    }

    if (![self validateSystem:system
                 withMapDatum:datum
                    andFormat:format]) {
        // throw exception
        NSLog(@"No valid coordinate system.");

        return self;
    }
    
    _system = system;
    _format = format;
    _datum  = datum;
    _localeForDecimals = locale;
    _leadingHemisphere = leadingHemisphere;
    _seperator = seperator;
    
    return self;
}

- (BOOL)validateMapDatum:(MapDatums)mapDatum {

    switch (mapDatum) {
        case kMapDatumWGS1984:
            return YES;
        default:
            return NO;
    }
}

- (BOOL)validateSystem:(CoordinateSystems)system
          withMapDatum:(MapDatums)mapDatum
             andFormat:(CoordinateFormats)format {
    
    switch (format) {
        case kCoordinateFormatGeodeticDecimalSign:
        case kCoordinateFormatGeodeticDecimalDirection:
        case kCoordinateFormatGeodeticDegreesSign:
        case kCoordinateFormatGeodeticDegreesDirection:
        case kCoordinateFormatGeodeticDegreesMinutesSign:
        case kCoordinateFormatGeodeticDegreesMinutesDirection:
        case kCoordinateFormatGeodeticDegreesMinutesSecondsSign:
        case kCoordinateFormatGeodeticDegreesMinutesSecondsDirection:
            return (system == kCoordinateSystemGeodetic && [self validateMapDatum:mapDatum]);
            
        case kCoordinateFormatMGRSDefault:
        case kCoordinateFormatMGRSWithSpaces:
            return ((system == kCoordinateSystemMGRS) && (mapDatum == kMapDatumWGS1984));
            
        case kCoordinateFormatUTMWithGridZone:
        case kCoordinateFormatUTMWithDirection:
            return ((system == kCoordinateSystemUTM)  && (mapDatum == kMapDatumWGS1984));

        default: NO;
    }
}

- (NSString *)localizedSystemName {

    switch (_system) {
        case kCoordinateSystemGeodetic:
            return NSLocalizedString(@"Geodetic", @"Name of geodetic coordinate system");

        case kCoordinateSystemMGRS:
            return NSLocalizedString(@"MGRS", @"Name of MGRS coordinate system");
            
        case kCoordinateSystemUTM:
            return NSLocalizedString(@"UTM", @"Name of UTM coordinate system");

        default:
            return NSLocalizedString(@"Undefined", @"Name of undefined coordinate system");
    }
}

- (NSString *)localizedSystemDescription {

    switch (_system) {
        case kCoordinateSystemGeodetic:
            return NSLocalizedString(@"Latitude, Longitude", @"Description of geodetic coordinate system");
            
        case kCoordinateSystemMGRS:
            return NSLocalizedString(@"Military Grid Reference System", @"Description of MGRS coordinate system");
            
        case kCoordinateSystemUTM:
            return NSLocalizedString(@"Universal Transverse Mercator", @"Description of UTM coordinate system");
            
        default:
            return NSLocalizedString(@"Undefined coordinate system", @"Name of undefined coordinate system");
    }
}

- (NSString *)localizedDatumName {

    switch (_datum) {
        case kMapDatumWGS1984:
            return NSLocalizedString(@"WGS84", @"World Geodetic System 1984");
        default:
            return NSLocalizedString(@"Undefined Datum", @"Name of undefined map datum");
    }
}

- (NSString *)localizedFormatName {

    switch (_format) {
        case kCoordinateFormatGeodeticDecimalSign:
            return NSLocalizedString(@"decimal sign", @"Name of coordinate format");

        case kCoordinateFormatGeodeticDecimalDirection:
            return NSLocalizedString(@"decimal direction", @"Name of coordinate format");

        case kCoordinateFormatGeodeticDegreesSign:
            return NSLocalizedString(@"degrees sign", @"Name of coordinate format");
            
        case kCoordinateFormatGeodeticDegreesDirection:
            return NSLocalizedString(@"degrees direction", @"Name of coordinate format");
            
        case kCoordinateFormatGeodeticDegreesMinutesSign:
            return NSLocalizedString(@"degrees minutes sign", @"Name of coordinate format");

        case kCoordinateFormatGeodeticDegreesMinutesDirection:
            return NSLocalizedString(@"degrees minutes direction", @"Name of coordinate format");

        case kCoordinateFormatGeodeticDegreesMinutesSecondsSign:
            return NSLocalizedString(@"degrees minutes seconds sign", @"Name of coordinate format");

        case kCoordinateFormatGeodeticDegreesMinutesSecondsDirection:
            return NSLocalizedString(@"degrees minutes seconds direction", @"Name of coordinate format");

        case kCoordinateFormatUTMWithGridZone:
            return NSLocalizedString(@"grid zone", @"Name of coordinate format");
            
        case kCoordinateFormatUTMWithDirection:
            return NSLocalizedString(@"direction", @"Name of coordinate format");

        case kCoordinateFormatMGRSDefault:
            return NSLocalizedString(@"without spaces", @"Name of coordinate format");
            
        case kCoordinateFormatMGRSWithSpaces:
            return NSLocalizedString(@"with spaces", @"Name of coordinate format");

        default:
            return NSLocalizedString(@"Undefined format", @"Name of undefined coordinates format");
    }
}

- (NSString *)localizedFormatExample {

    // number formates according to current locale...
    switch (_format) {
        case kCoordinateFormatGeodeticDecimalSign:
            return NSLocalizedString(@"+12.234 -40.123", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDecimalDirection:
            return NSLocalizedString(@"N12.234 W40.123", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesSign:
            return NSLocalizedString(@"+12.234° -40.123°", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesDirection:
            return NSLocalizedString(@"N12.234° W40.123°", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesMinutesSign:
            return NSLocalizedString(@"+12°23.4' -40°12.3'", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesMinutesDirection:
            return NSLocalizedString(@"N12°23.4' W40°12.3'", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesMinutesSecondsSign:
            return NSLocalizedString(@"+12°23'4.5\" -40°12'3.4\"", @"coordinates format example");
            
        case kCoordinateFormatGeodeticDegreesMinutesSecondsDirection:
            return NSLocalizedString(@"N12°23'4.5\" W40°12'3.4\"", @"coordinates format example");
            
        case kCoordinateFormatUTMWithGridZone:
            return NSLocalizedString(@"32U 1234.567 9878.1234", @"Name of coordinate format");
            
        case kCoordinateFormatUTMWithDirection:
            return NSLocalizedString(@"32 North 1234.567 9878.1234", @"Name of coordinate format");
            
        case kCoordinateFormatMGRSDefault:
            return NSLocalizedString(@"32UNA1234567890", @"Name of coordinate format");
            
        case kCoordinateFormatMGRSWithSpaces:
            return NSLocalizedString(@"32U NA 12345 67890", @"Name of coordinate format");
            
        default:
            return NSLocalizedString(@"Undefined format", @"Name of undefined coordinates format");
    }
}

#pragma mark - NSCoder

- (void) encodeWithCoder:(NSCoder *)encoder {
    
    [encoder encodeInteger:_system
                    forKey:kCoordinateSystemKey];
    
    [encoder encodeInteger:_datum
                    forKey:kCoordinateMapDatumKey];
    
    [encoder encodeInteger:_format
                    forKey:kCoordinateFormatKey];
    
    [encoder encodeBool:_leadingHemisphere
                 forKey:kCoordinateLeadingHemisphereKey];

    [encoder encodeObject:_seperator
                 forKey:kCoordinateSeperatorKey];

    [encoder encodeObject:_localeForDecimals.localeIdentifier
                   forKey:kCoordinateLocaleForDecimalsKey];
}

- (id)initWithCoder:(NSCoder *)decoder {
    
    CoordinateSystems coordSystem = [decoder decodeIntegerForKey:kCoordinateSystemKey];
    MapDatums mapDatum = [decoder decodeIntegerForKey:kCoordinateMapDatumKey];
    CoordinateFormats format = [decoder decodeIntegerForKey:kCoordinateFormatKey];
    BOOL leadingHemisphere = [decoder decodeBoolForKey:kCoordinateLeadingHemisphereKey];
    NSString *seperator = [decoder decodeObjectForKey:kCoordinateSeperatorKey];
    NSString *localeIdentifier = [decoder decodeObjectForKey:kCoordinateLocaleForDecimalsKey];
    NSLocale *locale = [NSLocale localeWithLocaleIdentifier:localeIdentifier];
    
    return [self initWithSystem:coordSystem
                          datum:mapDatum
                         format:format
              localeForDecimals:locale
             leadingHemisphere:leadingHemisphere
                      seperator:seperator];
}

- (NSArray *)systems {
    
    return self.supportedSystems;
}

- (NSArray *)datumsWithSystem:(CoordinateSystems)system {

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"system = %@", @(system)];

    NSArray *currentSystem = [self.supportedSystems filteredArrayUsingPredicate:predicate];

    NSDictionary *datums = [currentSystem firstObject];

    return [datums objectForKey:@"datums"];
}

- (NSArray *)formatsWithSystem:(CoordinateSystems)system {
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"system = %@", @(system)];
    
    NSArray *currentSystem = [self.supportedSystems filteredArrayUsingPredicate:predicate];
    
    NSDictionary *formats = [currentSystem firstObject];
    
    return [formats objectForKey:@"formats"];
}

- (NSArray *)supportedSystems {

    return @[
             @{
                @"system":@(kCoordinateSystemGeodetic),
                @"label":@"Geodetic",
                @"description":@"Latitude, Longitude",
                @"example":@"",
                @"datums":@[@{
                    @"datum":@(kMapDatumWGS1984),
                    @"label":@"WGS84",
                    @"description":@"World Geodetic System 1984"
                    }],
                @"formats":@[@{
                    @"format":  @(kCoordinateFormatGeodeticDecimalSign),
                    @"label":   @"decimal sign",
                    @"example": @"+10,234 -49,234",
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDecimalDirection),
                    @"label":   @"decimal direction",
                    @"example": @"N10,1234 W49,234"
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesSign),
                    @"label":   @"degrees sign",
                    @"example": @"N10,1234 W49,234"
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesDirection),
                    @"label":   @"degrees direction",
                    @"example": @"N10,1234 W49,234"
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesMinutesSign),
                    @"label":   @"degrees minutes sign",
                    @"example": @"+10°12,34' -49°23,4'"
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesMinutesDirection),
                    @"label":   @"degrees minutes direction",
                    @"example": @"N10°12,34' W49°23,4'"
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesMinutesSecondsSign),
                    @"label":   @"degrees minutes seconds sign",
                    @"example": @"+10°12'34,12\" -49°23'40,98\""
                }, @{
                    @"format":  @(kCoordinateFormatGeodeticDegreesMinutesSecondsDirection),
                    @"label":   @"degrees minutes seconds direction",
                    @"example": @"N10°12'34,12\" W49°23'40,98\""
                }]},
             @{
                 @"system":      @(kCoordinateSystemMGRS),
                 @"label":       @"MGRS",
                 @"description": @"Military Grid Reference System",
                 @"example":     @"",
                 @"datums":@[@{
                    @"datum":@(kMapDatumWGS1984),
                    @"label":@"WGS84",
                    @"description":@"World Geodetic System 1984",
                 }],
                 @"formats":@[@{
                    @"format":  @(kCoordinateFormatMGRSDefault),
                    @"label":   @"without spaces",
                    @"example": @"32UNA1234512345"
                 }, @{
                    @"format":  @(kCoordinateFormatMGRSWithSpaces),
                    @"label":   @"with spaces",
                    @"example": @"32U NA 12345 12345"
             }]}, @{
                 @"system":      @(kCoordinateSystemUTM),
                 @"label":       @"UTM",
                 @"description": @"Universal Transversal Mercator",
                 @"example":     @"",
                 @"datums":      @[@{
                    @"datum":@(kMapDatumWGS1984),
                    @"label":@"WGS 84",
                    @"description":@"World Geodetic System 1984",
                 }],
                 @"formats":@[@{
                    @"format":  @(kCoordinateFormatUTMWithGridZone),
                    @"label":   @"with grid zones",
                    @"example": @"32U 12345 1234567"
                 }, @{
                    @"format":  @(kCoordinateFormatUTMWithDirection),
                    @"label":   @"with direction",
                    @"example": @"32North 12345 1234567"
                 }]
            }];
    }

@end
