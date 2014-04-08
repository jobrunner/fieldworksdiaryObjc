//
//  TestDummyViewController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 08.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "TestDummyViewController.h"

@interface TestDummyViewController ()

@end

@implementation TestDummyViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // delegate behaviour
    _celciusTextField.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)textFieldShouldReturn: (UITextField *)textField
{
    double celsius = [[_celciusTextField text] doubleValue];
    double fahrenheit = celsius * (9.0 / 5.0) + 32.0;
    _fahrenheitTextField.text = [NSString stringWithFormat: @"%.0f", fahrenheit];

    return YES;
}


@end
