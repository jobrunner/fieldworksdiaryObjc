#import <XCTest/XCTest.h>
#import "GTWConversionManager.h"

@interface GTWConversionManagerTests : XCTestCase

@end

@implementation GTWConversionManagerTests {

    CLLocation *location;
}

- (void)setUp {

    [super setUp];
    
    location = [[CLLocation alloc] initWithLatitude:43.638719444444
                                          longitude:70.639230555556];
}

- (void)tearDown {

    [super tearDown];
}

- (void)testLocationToUTMWithHemisphere {

    GTWConversionManager *manager = [GTWConversionManager new];
    
    NSError *error;
    
    NSString *result = [manager utmWithLocationCoordinates:location.coordinate
                                        formatWithGridZone:NO
                                                     error:&error];
    XCTAssertEqualObjects(result, @"42North 632219 4833052");
}

- (void)testLocationToUTMWithGridZone {
    
    GTWConversionManager *manager = [GTWConversionManager new];
    
    NSError *error;
    
    NSString *result = [manager utmWithLocationCoordinates:location.coordinate
                                        formatWithGridZone:YES
                                                     error:&error];
    XCTAssertEqualObjects(result, @"42T 632219 4833052");
}

- (void)testLocationToMGRSWithSpaces {
    
    GTWConversionManager *manager = [GTWConversionManager new];
    
    NSError *error;
    
    NSString *result = [manager mgrsWithLocationCoordinates:location.coordinate
                                                  precision:5
                                           formatWithSpaces:YES
                                                      error:&error];
    XCTAssertEqualObjects(result, @"42T XP 32220 33053");
}

@end