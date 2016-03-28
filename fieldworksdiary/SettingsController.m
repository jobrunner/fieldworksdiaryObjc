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
#import "ActiveDateSetting.h"
#import "RecordStatistics.h"
#import "Formatter.h"

@interface SettingsController ()

@property (weak, nonatomic) IBOutlet UITextField *activeCollectorTextField;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeFieldtripLabel;
@property (weak, nonatomic) IBOutlet UISwitch *alldayDefaultSwitch;

- (IBAction)activeCollectorTextFieldEditingDidEnd:(UITextField *)sender;
- (IBAction)alldayDefaultSwitchValueChanged:(UISwitch *)sender;

@end

@implementation SettingsController

#pragma mark - UITableViewController Delegates

- (void)viewDidAppear:(BOOL)animated {
    
    Formatter *formatter = [Formatter new];
    
    NSUInteger fieldtripsCount = [RecordStatistics fieldtripCount];
    _fieldtripsCountLabel.text = [formatter counter:fieldtripsCount];
    _activeFieldtripLabel.text = [ActiveFieldtrip name];
    _activeCollectorTextField.text = [ActiveCollector name];
    _alldayDefaultSwitch.on = [ActiveDateSetting isActiveAllday];
}

- (void)viewDidLoad {

    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - FieldtripPickerDelegate

- (void)fieldtripPicker:(FieldtripsController *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    [ActiveFieldtrip setActiveFieldtrip:fieldtrip];

    _activeFieldtripLabel.text = fieldtrip.name;
}

#pragma mark - IBActions

- (IBAction)activeCollectorTextFieldEditingDidEnd:(UITextField *)sender {
    
    [ActiveCollector setActiveCollector:sender.text];
}

- (IBAction)alldayDefaultSwitchValueChanged:(UISwitch *)sender {

    [ActiveDateSetting setActiveAllday:sender.on];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FieldtripPickerSegue"]) {
        
        FieldtripsController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.fieldtripUsage = kFieldtripUsagePicker;
    }
    
    if ([[segue identifier] isEqualToString:@"FieldtripTableViewSegue"]) {
        
        FieldtripsController *controller = segue.destinationViewController;
        controller.delegate = nil;
        controller.fieldtripUsage = kFieldtripUsageDetails;
    }
}

@end
