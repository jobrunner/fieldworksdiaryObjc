//
//  Placemark.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 17.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@class CLPlacemark;

@interface Placemark : NSObject

@property (nonatomic, strong) NSString *country;
@property (nonatomic, strong) NSString *ISOcountryCode;
@property (nonatomic, strong) NSString *administrativeArea;
@property (nonatomic, strong) NSString *subAdministrativeArea;
@property (nonatomic, strong) NSString *locality;
@property (nonatomic, strong) NSString *subLocality;
@property (nonatomic, strong) NSString *ocean;
@property (nonatomic, strong) NSString *inlandWater;

+ (NSString *)stringFromPlacemark:(Placemark *)placemark;

- (id)initWithPlacemark:(CLPlacemark *)placemark;
- (id)initWithGoogleLocationDict:(NSDictionary *)location;

@end
