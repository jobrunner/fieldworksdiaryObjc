//
//  MettLocalityEditViewController.h
//  sunrise
//
//  Created by Jo Brunner on 05.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Conversion.h"
#import "Fieldtrip.h"
#import "StaticDataTableViewController.h"

// for subclassing of StaticDataTableViewController see https://github.com/xelvenone/StaticDataTableViewController

@interface SampleEditController : StaticDataTableViewController <
    UITextViewDelegate>

@property (strong, nonatomic) Fieldtrip * fieldtrip;

@end
