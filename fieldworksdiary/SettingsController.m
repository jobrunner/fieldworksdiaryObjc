//
//  SettingsController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsController.h"
#import "Project.h"
#import "ActiveFieldtrip.h"
#import "RecordStatistics.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidAppear:(BOOL)animated {
    
    _fieldtripsCountLabel.text = [NSString stringWithFormat:@"%ld", [RecordStatistics fieldtripCount]];
    _activeFieldtripLabel.text = [ActiveFieldtrip name];
}

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - ProjectTableViewController FieldtripPickerDelegate

- (void)fieldtripPicker:(ProjectTableViewController *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    [ActiveFieldtrip setActiveFieldtrip:fieldtrip];

    _activeFieldtripLabel.text = fieldtrip.name;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"FieldtripPickerSegue"]) {

        ProjectTableViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.useAsPicker = YES;
    }

    if ([[segue identifier] isEqualToString:@"FieldtripTableViewSegue"]) {
        
        ProjectTableViewController *controller = segue.destinationViewController;
        controller.delegate = nil;
        controller.useAsPicker = NO;
    }
}

- (IBAction)locationIdentifierPrefixTextFieldEditingDidEnd:(UITextField *)sender {
        
}

@end
