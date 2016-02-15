//
//  UnitPlacemarkTests.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 15.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "Placemark.h"

@interface UnitPlacemarkTests : XCTestCase

@end

@implementation UnitPlacemarkTests


- (void)testPlacemarkStringFromGoogleLocationDict
{
    NSDictionary *dict = @{
        @"country":@"España",
        @"countryCodeIso":@"ES",
        @"administrative_area_level_1":@"Canarias",
        @"administrative_area_level_2":@"Santa Cruz de Tenerife",
        @"administrative_area_level_3":@"Isla de la Palma",
        @"administrative_area_level_4":@"Breña Alta"
    };
    
    Placemark *placemark      = [[Placemark alloc] initWithGoogleLocationDict:dict];
    NSString *placemarkString = [Placemark stringFromPlacemark:placemark];
    NSString *shouldbe        = @"España, Canarias\nSanta Cruz de Tenerife, Isla de la Palma, Breña Alta";

    XCTAssertEqualObjects(placemarkString, shouldbe);
}

@end
