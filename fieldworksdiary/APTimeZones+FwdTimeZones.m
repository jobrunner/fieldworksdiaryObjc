//
//  APTimeZones+FwdTimeZones.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 05.05.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "APTimeZones+FwdTimeZones.h"

@implementation APTimeZones (FwdTimeZones)

- (CLLocation *)approximateLocationFromeTimeZone:(NSTimeZone *)timeZone {

    NSDictionary *zoneInfo = [self zoneInfoWithTimeZone:timeZone
                                                 source:self.timeZonesDB];
    if (zoneInfo == nil) {

        return nil;
    }
    
    double latitude = [zoneInfo[@"latitude"] doubleValue];
    double longitude = [zoneInfo[@"longitude"] doubleValue];
    
    return [[CLLocation alloc] initWithLatitude:latitude
                                      longitude:longitude];
}

- (NSDictionary *)zoneInfoWithTimeZone:(NSTimeZone *)timeZone
                                      source:(NSArray *)source {
    
    for (NSDictionary *locationInfo in source) {
        if ([timeZone.name isEqualToString:locationInfo[@"zone"]]) {

            return locationInfo;
        }
    }

    return nil;
}

@end
