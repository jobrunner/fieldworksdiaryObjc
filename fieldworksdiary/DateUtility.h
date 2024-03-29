//
//  DateUtility.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DateUtility : NSObject

+ (BOOL)isDateSameDay:(NSDate *)firstDate
               asDate:(NSDate *)secondDate;

+ (BOOL)isDateSameMonth:(NSDate *)firstDate
                 asDate:(NSDate *)secondDate;

+ (BOOL)isDateSameYear:(NSDate *)firstDate
                asDate:(NSDate *)secondDate;

+ (BOOL)isDateSameMinute:(NSDate *)firstDate
                  asDate:(NSDate *)secondDate;

+ (NSDate *)dateWithZeroSeconds:(NSDate *)date;

+ (NSDateFormatter *)dateFormatterWithAllday:(BOOL)isAllday
                          isEqualDayOmitting:(BOOL)isEqualDayOmitting;

+ (NSDateFormatter *)timeFormatterWithAllday:(BOOL)isAllday;

+ (NSString *)formattedBeginDate:(NSDate *)beginDate
                         endDate:(NSDate *)endDate
                          allday:(BOOL)isAllday;

@end
