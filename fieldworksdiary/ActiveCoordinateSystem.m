//
//  ActiveCoordinateSystem.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "ActiveCoordinateSystem.h"
#import "CoordinateSystem.h"

@implementation ActiveCoordinateSystem

+ (UnitOfLength)unitOfLength {
    
    // getting the setting
    return [[NSUserDefaults standardUserDefaults] integerForKey:kUserDefaultsKeyUnitOfLenght];
}

+ (void)setUnitOfLength:(UnitOfLength)unitOfLength {
    
    [[NSUserDefaults standardUserDefaults] setInteger:unitOfLength
                                               forKey:kUserDefaultsKeyUnitOfLenght];
}

+ (CoordinateSystem *)coordinateSystem {
  
    NSData *encodedCoordinateSystem =
    [[NSUserDefaults standardUserDefaults] objectForKey:kUserDefaultsKeyCoordinateSystem];

    CoordinateSystem *coordinateSystem =
    (CoordinateSystem *)[NSKeyedUnarchiver unarchiveObjectWithData: encodedCoordinateSystem];
    
    if (coordinateSystem == nil) {
        coordinateSystem = [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                                              datum:kMapDatumWGS1984
                                                             format:kCoordinateFormatGeodeticDecimalSign
                                                  localeForDecimals:[NSLocale currentLocale]
                                                 leadingHemisphere:YES
                                                          seperator:@" "];
        [self setCoordinateSystem:coordinateSystem];
    }
    
    return coordinateSystem;
}

+ (void)setCoordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    NSData *encodedCordinateSystem = [NSKeyedArchiver archivedDataWithRootObject:coordinateSystem];

    [[NSUserDefaults standardUserDefaults] setObject:encodedCordinateSystem
                                              forKey:kUserDefaultsKeyCoordinateSystem];
}

@end
