//
//  MettLocalityEditViewController.h
//  sunrise
//
//  Created by Jo Brunner on 05.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@class Fieldtrip;

#import "FieldtripsController.h"
#import "StaticDataTableViewController.h"
#import "TimeZonePickerController.h"

// for subclassing of StaticDataTableViewController see https://github.com/xelvenone/StaticDataTableViewController

@interface SampleEditController : StaticDataTableViewController <
    UITextViewDelegate,
    FieldtripPickerDelegate,
    TimeZonePickerDelegate>

@property (strong, nonatomic) Fieldtrip * sample;

@end
