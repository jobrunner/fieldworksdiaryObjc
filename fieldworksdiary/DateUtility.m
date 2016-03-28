//
//  DateUtility.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "DateUtility.h"

@implementation DateUtility

#pragma mark - Date Utility

+ (BOOL)isDateSameDay:(NSDate *)firstDate
               asDate:(NSDate *)secondDate {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate:secondDate];
    
    return ([firstDateComponent isEqual:secondDateComponent]);
}

+ (NSDate *)dateWithZeroSeconds:(NSDate *)date {
    
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}

+ (NSDateFormatter *)dateFormatterWithAllday:(BOOL)isAllday
                          isEqualDayOmitting:(BOOL)isEqualDayOmitting {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if (isAllday == YES) {
        dateFormatter.dateFormat = @"E, dd. MMMM Y";
    }
    else {
        // Ausnahme für endDate:
        if (isEqualDayOmitting == YES) {
            dateFormatter.dateFormat = @"";
        } else {
            dateFormatter.dateFormat = @"dd. MMMM Y";
        }
    }
    
    return dateFormatter;
}

+ (NSDateFormatter *)timeFormatterWithAllday:(BOOL)isAllday {
    
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    
    if (isAllday == YES) {
        timeFormatter.dateFormat = @"";
    }
    else {
        timeFormatter.dateFormat = @"HH:mm";
    }
    
    return timeFormatter;
}

@end
