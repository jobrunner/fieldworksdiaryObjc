//
//  TestDummyControllerViewTest.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 08.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "MockTextField.h"
#import "TestDummyViewController.h"

@interface TestDummyControllerViewTest : XCTestCase

@property (strong, nonatomic) MockTextField * celsiusTextField;
@property (strong, nonatomic) MockTextField * fahrenheitTextField;
@property (strong, nonatomic) TestDummyViewController * dummyController;

@end

@implementation TestDummyControllerViewTest

@synthesize celsiusTextField;
@synthesize fahrenheitTextField;
@synthesize dummyController;

- (void)setUp
{
    [super setUp];

    dummyController = [[TestDummyViewController alloc] init];

    celsiusTextField = [[MockTextField alloc] init];
    fahrenheitTextField = [[MockTextField alloc] init];
    
    dummyController.celciusTextField = (UITextField *)celsiusTextField;
    dummyController.fahrenheitTextField = (UITextField *)fahrenheitTextField;
}

- (void)tearDown
{
    [super tearDown];
}

- (void)testThatMinusFortyCelsiusIsMinusFortyFahrenheit
{
    celsiusTextField.text = @"-40";
    [dummyController textFieldShouldReturn:(UITextField *)celsiusTextField];

    XCTAssertEqualObjects(fahrenheitTextField.text, @"-40", @"In both Celsius and Fahrenheit -40 is the same temperature");
}

- (void)testThatOneHundredCelsiusIsTwoOneTwoFahrenheit
{
    celsiusTextField.text = @"100";
    [dummyController textFieldShouldReturn:(UITextField *)celsiusTextField];
    
    XCTAssertTrue([fahrenheitTextField.text isEqualToString: @"212"], @"100 Celsius is 212 Fahrenheit");
}

- (void)testThatTextFieldShouldReturnIsTrueForArbitraryInput
{
    celsiusTextField.text = @"0";
    
    XCTAssertTrue([dummyController textFieldShouldReturn:(UITextField *)celsiusTextField], @"This method should return YES to get standard celsiusTextField behaviour");
}

@end
