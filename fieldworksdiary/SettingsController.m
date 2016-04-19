//
//  SettingsController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsController.h"
#import "CoordinateSystemPickerController.h"
#import "Project.h"
#import "ActiveCollector.h"
#import "ActiveFieldtrip.h"
#import "ActiveDateSetting.h"
#import "ActiveCoordinateSystem.h"
#import "CoordinateSystem.h"
#import "RecordStatistics.h"
#import "Formatter.h"

@interface SettingsController ()

@property (nonatomic, retain) NSIndexPath* checkedUnitOfLengthIndexPath;

@property (nonatomic, weak) IBOutlet UITextField *activeCollectorTextField;
@property (nonatomic, weak) IBOutlet UILabel *fieldtripsCountLabel;
@property (nonatomic, weak) IBOutlet UILabel *activeFieldtripLabel;
@property (nonatomic, weak) IBOutlet UISwitch *alldayDefaultSwitch;
@property (nonatomic, weak) IBOutlet UITableViewCell *unitOfLengthMeterCell;
@property (nonatomic, weak) IBOutlet UITableViewCell *unitOfLengthFootCell;
@property (weak, nonatomic) IBOutlet UILabel *coordinateSystemLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinateMapDatumLabel;

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

    if ([ActiveCoordinateSystem unitOfLength] == kUnitOfLengthFoot) {
        _unitOfLengthMeterCell.accessoryType = UITableViewCellAccessoryNone;
        _unitOfLengthFootCell.accessoryType = UITableViewCellAccessoryCheckmark;
    } else {
        _unitOfLengthMeterCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _unitOfLengthFootCell.accessoryType = UITableViewCellAccessoryNone;
    }
    
    CoordinateSystem *coordinateSystem = [ActiveCoordinateSystem coordinateSystem];
    
    [self updateCoordinateSystem:coordinateSystem];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - View helper

- (void)updateCoordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    _coordinateSystemLabel.text = [NSString stringWithFormat:@"%@ %@",
                                   coordinateSystem.localizedSystemName,
                                   coordinateSystem.localizedFormatName];
    
    _coordinateMapDatumLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                                     coordinateSystem.localizedDatumName,
                                     coordinateSystem.localizedFormatExample];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];

    if ([cell isEqual:_unitOfLengthMeterCell]) {
        _unitOfLengthMeterCell.accessoryType = UITableViewCellAccessoryCheckmark;
        _unitOfLengthFootCell.accessoryType = UITableViewCellAccessoryNone;
        [ActiveCoordinateSystem setUnitOfLength:kUnitOfLengthMeter];
    }
    else if ([cell isEqual:_unitOfLengthFootCell]) {
        _unitOfLengthMeterCell.accessoryType = UITableViewCellAccessoryNone;
        _unitOfLengthFootCell.accessoryType = UITableViewCellAccessoryCheckmark;
        [ActiveCoordinateSystem setUnitOfLength:kUnitOfLengthFoot];
    }
}

#pragma mark - FieldtripPickerDelegate

- (void)fieldtripPicker:(FieldtripsController *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    [ActiveFieldtrip setActiveFieldtrip:fieldtrip];

    _activeFieldtripLabel.text = fieldtrip.name;
}

#pragma mark - CoordinateSystemsPickerDelegate

- (void)coordinateSystemPicker:(CoordinateSystemPickerController *)picker
     didSelectCoordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    [ActiveCoordinateSystem setCoordinateSystem:coordinateSystem];
    
    [self updateCoordinateSystem:coordinateSystem];
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
    
    if ([[segue identifier] isEqualToString:@"CoordinateSystemSegue"]) {
        CoordinateSystemPickerController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.coordinateSystem = [ActiveCoordinateSystem coordinateSystem];
    }
}

@end
