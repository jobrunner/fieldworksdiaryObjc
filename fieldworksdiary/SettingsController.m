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
#import "ActiveCollector.h"
#import "ActiveFieldtrip.h"
#import "RecordStatistics.h"
#import "Formatter.h"

@interface SettingsController ()

@property (weak, nonatomic) IBOutlet UITextField *activeCollectorTextField;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeFieldtripLabel;

- (IBAction)activeCollectorTextFieldEditingDidEnd:(UITextField *)sender;

@end

@implementation SettingsController

#pragma mark - UITableViewController Delegates

- (void)viewDidAppear:(BOOL)animated {
    
    Formatter *formatter = [Formatter new];
    
    NSUInteger fieldtripsCount = [RecordStatistics fieldtripCount];
    _fieldtripsCountLabel.text = [formatter counter:fieldtripsCount];
    _activeFieldtripLabel.text = [ActiveFieldtrip name];
    _activeCollectorTextField.text = [ActiveCollector name];
}

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - FieldtripPickerDelegate

- (void)fieldtripPicker:(ProjectTableViewController *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    [ActiveFieldtrip setActiveFieldtrip:fieldtrip];

    _activeFieldtripLabel.text = fieldtrip.name;
}

#pragma mark - IBActions

- (IBAction)activeCollectorTextFieldEditingDidEnd:(UITextField *)sender {
    
    [ActiveCollector setActiveCollector:sender.text];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FieldtripPickerSegue"]) {
        
        ProjectTableViewController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.fieldtripUsage = kFieldtripUsagePicker;
    }
    
    if ([[segue identifier] isEqualToString:@"FieldtripTableViewSegue"]) {
        
        ProjectTableViewController *controller = segue.destinationViewController;
        controller.delegate = nil;
        controller.fieldtripUsage = kFieldtripUsageDetails;
    }
}

@end
