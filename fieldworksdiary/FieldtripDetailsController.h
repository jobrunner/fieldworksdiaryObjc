//
//  ProjectDetailsViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
//  -> FieldtripDetailsController

#import "AppDelegate.h"
#import "StaticDataTableViewController.h"
#import "Project.h"

@interface FieldtripDetailsController : StaticDataTableViewController <
    UIAlertViewDelegate,
    UITextFieldDelegate,
    UITextViewDelegate>

@property (strong, nonatomic) Project * fieldtrip;

@end
