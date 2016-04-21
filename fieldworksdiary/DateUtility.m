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

+ (NSString *)alldayFormattedBeginDate:(NSDate *)beginDate
                               endDate:(NSDate *)endDate {

    NSDateIntervalFormatter *intervallFormatter = [NSDateIntervalFormatter new];
    intervallFormatter.dateStyle = NSDateIntervalFormatterFullStyle;
    intervallFormatter.timeStyle = NSDateIntervalFormatterNoStyle;
    
    return [intervallFormatter stringFromDate:beginDate
                                       toDate:endDate];
}

+ (NSString *)timeFormattedBeginDate:(NSDate *)beginDate
                             endDate:(NSDate *)endDate {
    
    NSDateIntervalFormatter *intervallFormatter = [NSDateIntervalFormatter new];
    intervallFormatter.dateStyle = NSDateIntervalFormatterFullStyle;
    intervallFormatter.timeStyle = NSDateIntervalFormatterShortStyle;

    return [intervallFormatter stringFromDate:beginDate
                                       toDate:endDate];
}

+ (NSString *)formattedBeginDate:(NSDate *)beginDate
                         endDate:(NSDate *)endDate
                          allday:(BOOL)isAllday {

    if (isAllday) {
        return [DateUtility alldayFormattedBeginDate:beginDate
                                             endDate:endDate];
    }
    else {
        return [DateUtility timeFormattedBeginDate:beginDate
                                           endDate:endDate];
    }
}

+ (BOOL)isDateSameDay:(NSDate *)firstDate
               asDate:(NSDate *)secondDate {
    
    NSCalendarUnit compareFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComponent = [calendar components:compareFlags
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:compareFlags
                                                        fromDate:secondDate];
    
    return ([firstDateComponent isEqual:secondDateComponent]);
}

+ (BOOL)isDateSameMonth:(NSDate *)firstDate
                 asDate:(NSDate *)secondDate {
    
    NSCalendarUnit compareFlags = NSMonthCalendarUnit|NSYearCalendarUnit;

    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComponent = [calendar components:compareFlags
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:compareFlags
                                                        fromDate:secondDate];
    
    return ([firstDateComponent isEqual:secondDateComponent]);
}

+ (BOOL)isDateSameYear:(NSDate *)firstDate
                asDate:(NSDate *)secondDate {
    
    NSCalendarUnit compareFlags = NSYearCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComponent = [calendar components:compareFlags
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:compareFlags
                                                        fromDate:secondDate];
    
    return ([firstDateComponent isEqual:secondDateComponent]);
}

+ (BOOL)isDateSameMinute:(NSDate *)firstDate
                asDate:(NSDate *)secondDate {
 
    NSCalendarUnit compareFlags = NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit|NSHourCalendarUnit|NSMinuteCalendarUnit;
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *firstDateComponent = [calendar components:compareFlags
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:compareFlags
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
        // exception for endDate:
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
        timeFormatter.timeStyle = NSDateFormatterNoStyle;
    }
    else {
        timeFormatter.timeStyle = NSDateFormatterShortStyle;
    }
    
    return timeFormatter;
}

@end
