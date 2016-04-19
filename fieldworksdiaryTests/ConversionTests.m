//
//  ConversionTests.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 12.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@import CoreLocation;

#import <XCTest/XCTest.h>
#import "Conversion.h"
#import "CoordinateSystem.h"

@interface ConversionTests : XCTestCase

@end

@implementation ConversionTests {

    CLLocation *location;
    NSLocale *locale;
}

- (void)setUp {
    [super setUp];

    location = [[CLLocation alloc] initWithLatitude:43.638719444444
                                          longitude:70.639230555556];
    locale = [NSLocale localeWithLocaleIdentifier:@"de-DE"];
}

- (void)tearDown {
    [super tearDown];
}

- (void)testGeodeticDecimalSign {

    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDecimalSign
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];

    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];

    XCTAssertEqualObjects(result, @"+43,638719 +70,639231");
}

- (void)testGeodeticDecimalLeadingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDecimalDirection
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"N43,638719 E70,639231");
}

- (void)testGeodeticDecimalTrailingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDecimalDirection
                           localeForDecimals:locale
                           leadingHemisphere:NO
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"43,638719N 70,639231E");
}

- (void)testGeodeticDegreesSign {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesSign
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];

    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"+43,638719° +070,639231°");
}

- (void)testGeodeticDegreesTrialingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesDirection
                           localeForDecimals:locale
                           leadingHemisphere:NO
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"43,638719°N 070,639231°E");
}

- (void)testGeodeticDegreesLeadingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesDirection
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"N43,638719° E070,639231°");
}

- (void)testGeodeticDegreesMinutesSign {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesMinutesSign
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];

    XCTAssertEqualObjects(result, @"+43°38,32' +070°38,35'");
}

- (void)testGeodeticDegreesMinutesLeadingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesMinutesDirection
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"N43°38,32' E070°38,35'");
}

- (void)testGeodeticDegreesMinutesSecondsSign {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesMinutesSecondsSign
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"+43°38'19,4\" +070°38'21,2\"");
}

- (void)testGeodeticDegreesMinutesSecondsLeadingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesMinutesSecondsDirection
                           localeForDecimals:locale
                           leadingHemisphere:YES
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"N43°38'19,4\" E070°38'21,2\"");
}

- (void)testGeodeticDegreesMinutesSecondsTrailingDirection {
    
    Conversion *conversion = [Conversion new];
    CoordinateSystem *coordinateSystem =
    [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                       datum:kMapDatumWGS1984
                                      format:kCoordinateFormatGeodeticDegreesMinutesSecondsDirection
                           localeForDecimals:locale
                           leadingHemisphere:NO
                                   seperator:@" "];
    
    NSString *result = [conversion locationToCoordinates:location
                                        coordinateSystem:coordinateSystem];
    
    XCTAssertEqualObjects(result, @"43°38'19,4\"N 070°38'21,2\"E");
}

@end