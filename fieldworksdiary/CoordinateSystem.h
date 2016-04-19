//
//  CoordinateSystem.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#define kCoordinateSystemKey                @"system"
#define kCoordinateMapDatumKey              @"datum"
#define kCoordinateFormatKey                @"format"
#define kCoordinateSeperatorKey             @"seperator"
#define kCoordinateLeadingHemisphereKey     @"leadingHemisphere"
#define kCoordinateLocaleForDecimalsKey     @"localeForDecimals"

@interface CoordinateSystem : NSObject <NSCoding>

@property (nonatomic, readonly) CoordinateSystems system;
@property (nonatomic, readwrite) CoordinateFormats format;
@property (nonatomic, readwrite) MapDatums datum;
@property (nonatomic, readwrite, copy) NSLocale *localeForDecimals;
@property (nonatomic, readwrite) BOOL leadingHemisphere;
@property (nonatomic, readwrite, copy) NSString *seperator;

- (instancetype)initWithSystem:(CoordinateSystems)system
                         datum:(MapDatums)datum
                        format:(CoordinateFormats)format
             localeForDecimals:(NSLocale *)locale
            leadingHemisphere:(BOOL)leadingHemisphere
                     seperator:(NSString *)seperator;

- (NSString *)localizedSystemName;
- (NSString *)localizedSystemDescription;
- (NSString *)localizedDatumName;
- (NSString *)localizedFormatName;
- (NSString *)localizedFormatExample;

- (NSArray *)systems;
- (NSArray *)datumsWithSystem:(CoordinateSystems)system;
- (NSArray *)formatsWithSystem:(CoordinateSystems)system;

@end
