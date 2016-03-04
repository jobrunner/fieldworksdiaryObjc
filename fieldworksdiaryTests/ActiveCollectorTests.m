//
//  ActiveCollectorsTests.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ActiveCollector.h"

@interface ActiveCollectorTests : XCTestCase

@end

@implementation ActiveCollectorTests {
    NSString * testCollector;;
}

- (void)setUp {
    [super setUp];
    
    testCollector = @"X. Täst";
    [[NSUserDefaults standardUserDefaults] setObject:testCollector
                                              forKey:kActiveCollectorUserDefaultsKey];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

    [[NSUserDefaults standardUserDefaults] setObject:nil
                                              forKey:kActiveCollectorUserDefaultsKey];
}

- (void)testReadActiveCollector {
    
    NSString * name = [ActiveCollector name];
    XCTAssertEqualObjects(name, testCollector);
}

- (void)testWriteActiveCollector {

    NSString *collector = @"Täst, X.";
    [ActiveCollector setActiveCollector:collector];

    NSString * name = [ActiveCollector name];
    XCTAssertEqualObjects(name, collector);
}

- (void)testIsActiveCollecor {
    
    BOOL isActive = [ActiveCollector isActive:testCollector];
    XCTAssertTrue(isActive);

    NSString *collector = @"Täst, Y.";
    [ActiveCollector setActiveCollector:collector];

    isActive = [ActiveCollector isActive:collector];
    XCTAssertTrue(isActive);
}

@end
