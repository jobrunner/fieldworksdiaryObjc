//
//  RecordStatistics.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 02.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//
@class Fieldtrip;

@interface RecordStatistics : NSObject

+ (Fieldtrip *)recentSample;
+ (NSUInteger)sampleCount;
+ (NSUInteger)fieldtripCount;

@end
