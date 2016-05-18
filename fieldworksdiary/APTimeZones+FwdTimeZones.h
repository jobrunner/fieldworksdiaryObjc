//
//  APTimeZones+FwdTimeZones.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 05.05.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "APTimeZones.h"

@interface APTimeZones (FwdTimeZones)

// Realy bad Idea. But it is an experiment.
@property (nonatomic, strong, readonly) NSArray *timeZonesDB;

- (NSArray *)timeZonesDB;

/**
 * Returns a location from APTimeZones. This should be only used to approximate something
 * sunrise/sunset or that.
 */
- (CLLocation *)approximateLocationFromeTimeZone:(NSTimeZone *)timeZone;

@end
