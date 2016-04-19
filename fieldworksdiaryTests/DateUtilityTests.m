//
//  DateUtilityTests.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "DateUtility.h"

@interface DateUtilityTests : XCTestCase

@property (nonatomic, strong) NSCalendar *calendar;
@property (nonatomic, strong) NSDate *beginDate;

@end

@implementation DateUtilityTests

- (void)setUp {
    
    [super setUp];

    _calendar = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    
    NSDateComponents *beginDateComponent = [[NSDateComponents alloc] init];
    beginDateComponent.year = 2016;
    beginDateComponent.month = 3;
    beginDateComponent.day = 4;
    beginDateComponent.hour = 13;
    beginDateComponent.minute = 43;
    beginDateComponent.second = 53;
    
    _beginDate = [_calendar dateFromComponents:beginDateComponent];
}

- (void)tearDown {

    [super tearDown];
}

- (void)testEqualDateTime {

    NSDate *endDate = _beginDate.copy;

    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:NO];
    NSLog(@"%@", dateRangeString);
    
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016, 13:43");
}

- (void)testOneHourDateTime {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60];
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:NO];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016, 13:43–14:43");
}

- (void)testOneDayDateTime {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*25]; // +25 hours
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:NO];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016, 13:43 – Samstag, 5. März 2016, 14:43");
}

- (void)testOneMonthDateTime {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*24*32]; // +32 days
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:NO];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016, 13:43 – Dienstag, 5. April 2016, 14:43");
}

- (void)testOneYearDateTime {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*24*31*13]; // +13 Month
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:NO];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016, 13:43 – Dienstag, 11. April 2017, 14:43");
}

- (void)testEqualDate {
    
    NSDate *endDate = [_beginDate copy];
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:YES];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016");
}

- (void)testOneDayDate {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*25]; // + 25 hours
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:YES];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. – Samstag, 5. März 2016");
}

- (void)testOneMonthDate {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*24*32]; // + 32 Days
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:YES];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März – Dienstag, 5. April 2016");
}

- (void)testOneYearDate {
    
    NSDate *endDate = [_beginDate.copy dateByAddingTimeInterval:60*60*24*31*13]; // + 13 Months
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_beginDate
                                                        endDate:endDate
                                                         allday:YES];
    // Localized: DE
    XCTAssertEqualObjects(dateRangeString, @"Freitag, 4. März 2016 – Dienstag, 11. April 2017");
}

@end
