//
//  ProjectDetailsViewController.h
//  sunrise
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "StaticDataTableViewController.h"
#import "Project.h"


@interface ProjectDetailsViewController : StaticDataTableViewController <UIAlertViewDelegate, UITextFieldDelegate, UITextViewDelegate>

@property (strong, nonatomic) Project * fieldtrip;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end
