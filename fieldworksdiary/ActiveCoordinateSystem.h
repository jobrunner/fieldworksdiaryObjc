//
//  ActiveCoordinateSystem.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@class CoordinateSystem;

#define kUserDefaultsKeyUnitOfLenght        @"unitOfLenght"
#define kUserDefaultsKeyCoordinateSystem    @"coordinateSystem"

@interface ActiveCoordinateSystem : NSObject

+ (UnitOfLength)unitOfLength;
+ (void)setUnitOfLength:(UnitOfLength)unitOfLength;

+ (CoordinateSystem *)coordinateSystem;
+ (void)setCoordinateSystem:(CoordinateSystem *)coordinateSystem;

@end
