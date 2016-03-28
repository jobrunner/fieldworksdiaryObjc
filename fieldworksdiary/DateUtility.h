//
//  DateUtility.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (BOOL)isDateSameDay:(NSDate *)firstDate asDate:(NSDate *)secondDate;
+ (NSDate *)dateWithZeroSeconds:(NSDate *)date;
+ (NSDateFormatter *)dateFormatterWithAllday:(BOOL)isAllday
                          isEqualDayOmitting:(BOOL)isEqualDayOmitting;
+ (NSDateFormatter *)timeFormatterWithAllday:(BOOL)isAllday;

@end
