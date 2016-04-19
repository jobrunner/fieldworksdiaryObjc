//
//  CoordinateSettingsController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "CoordinateSystemPickerController.h"
#import "CoordinateSystem.h"
#import "CoordinateSystemPickerSystemCell.h"
#import "CoordinateSystemPickerDatumCell.h"
#import "CoordinateSystemPickerFormatCell.h"

@interface CoordinateSystemPickerController () {

//    NSArray *systems;
    NSIndexPath *datumIndexPath;
    NSIndexPath *formatIndexPath;
}

@end

@implementation CoordinateSystemPickerController

- (void)viewDidLoad {

    [super viewDidLoad];

    _saveButton.enabled = NO;

//    NSLog(@"mal sehen:\n%@", [_coordinateSystem datumsWithSystem:kCoordinateSystemGeodetic]);

//    NSLog(@"mal sehen:\n%@", [_coordinateSystem formatsWithSystem:kCoordinateSystemMGRS]);
//    NSLog(@"mal sehen:\n%@", [_coordinateSystem systems]);
    
    
    
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    // section 0: System
    // section 1: Datum
    // section 2: Format
    return 3;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    switch (section) {
        // section 0: System
        case 0:
            return 1;
            
        // section 1: Datum
        case 1:
            return [[_coordinateSystem datumsWithSystem:_coordinateSystem.system] count];
            
        // section 2: Format
        case 2:
            return [[_coordinateSystem formatsWithSystem:_coordinateSystem.system] count];

        default:
            return 0;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
 
    if (indexPath.section == 0) {

        static NSString *cellId = @"CoordinateSystemPickerSystemCell";

        CoordinateSystemPickerSystemCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:cellId
                                                  bundle:nil]
            forCellReuseIdentifier:cellId];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        }
        cell.tag = _coordinateSystem.system;
        cell.systemLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                                 _coordinateSystem.localizedSystemName,
                                 _coordinateSystem.localizedSystemDescription];
        
        return cell;
    }

    if (indexPath.section == 1) {

        static NSString * cellId = @"CoordinateSystemPickerDatumCell";
        
        CoordinateSystemPickerDatumCell *cell =
        [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:cellId
                                                  bundle:nil]
            forCellReuseIdentifier:cellId];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        }

//        NSDictionary * datum = [[_coordinateSystem datumsWithSystem:_coordinateSystem.system] objectAtIndex:indexPath.item];
//        
//        cell.tag = [[datum objectForKey:@"datum"] integerValue];
//        cell.datumLabel.text = [datum objectForKey:@"label"];
//        cell.datumDescriptionLabel.text = [datum objectForKey:@"description"];
//        
//        if (_coordinateSystem.datum == [[datum objectForKey:@"datum"] integerValue]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        
        return cell;
    }

    if (indexPath.section == 2) {
        
        static NSString * cellId = @"CoordinateSystemPickerFormatCell";

        CoordinateSystemPickerFormatCell *cell;
        [tableView dequeueReusableCellWithIdentifier:cellId];
        
        if (!cell) {
            [tableView registerNib:[UINib nibWithNibName:cellId
                                                  bundle:nil]
            forCellReuseIdentifier:cellId];
            
            cell = [tableView dequeueReusableCellWithIdentifier:cellId];
        }
        
//        NSDictionary *format = [[_coordinateSystem formatsWithSystem:_coordinateSystem.system] objectAtIndex:indexPath.item];
//        
//        cell.tag = [[format objectForKey:@"format"] integerValue];
//        cell.formatNameLabel.text = [format objectForKey:@"label"];
//        cell.formatExampleLabel.text = [format objectForKey:@"example"];
//        
//        if (_coordinateSystem.format == [[format objectForKey:@"format"] integerValue]) {
//            cell.accessoryType = UITableViewCellAccessoryCheckmark;
//        }
//        else {
//            cell.accessoryType = UITableViewCellAccessoryNone;
//        }
        
        return cell;
    }

    // should never raise - crashes the app...
    UITableViewCell *cell;
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(UITableViewCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0) {
        CoordinateSystemPickerSystemCell *systemCell = (CoordinateSystemPickerSystemCell *)cell;
        systemCell.systemLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                                       _coordinateSystem.localizedSystemName,
                                       _coordinateSystem.localizedSystemDescription];
    }
    
    if (indexPath.section == 1) {
        NSDictionary * datum = [[_coordinateSystem datumsWithSystem:_coordinateSystem.system] objectAtIndex:indexPath.item];
        CoordinateSystemPickerDatumCell *datumCell = (CoordinateSystemPickerDatumCell *)cell;
        
        datumCell.tag = [[datum objectForKey:@"datum"] integerValue];
        datumCell.datumLabel.text = [datum objectForKey:@"label"];
        datumCell.datumDescriptionLabel.text = [datum objectForKey:@"description"];
        
        if (_coordinateSystem.datum == [[datum objectForKey:@"datum"] integerValue]) {
            datumCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            datumCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }

    if (indexPath.section == 2) {
        NSDictionary *format = [[_coordinateSystem formatsWithSystem:_coordinateSystem.system] objectAtIndex:indexPath.item];

        CoordinateSystemPickerFormatCell *formatCell = (CoordinateSystemPickerFormatCell *)cell;
        
        formatCell.tag = [[format objectForKey:@"format"] integerValue];
        formatCell.formatNameLabel.text = [format objectForKey:@"label"];
        formatCell.formatExampleLabel.text = [format objectForKey:@"example"];
        
        if (_coordinateSystem.format == [[format objectForKey:@"format"] integerValue]) {
            formatCell.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            formatCell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (indexPath.section == 0 && indexPath.item == 0) {
        id sender = [tableView cellForRowAtIndexPath:indexPath];
        [self performSegueWithIdentifier:@"CoordinateSystemListSegue"
                                  sender:sender];
        return ;
    }

    // check datum
    if (indexPath.section == 1) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        _coordinateSystem.datum = cell.tag;
        _saveButton.enabled = YES;
        [self.tableView reloadData];
        
        return;
    }
    
    // check format
    if (indexPath.section == 2) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
        _coordinateSystem.format = cell.tag;
        _saveButton.enabled = YES;
        [self.tableView reloadData];

        return;
    }
}


// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    
    switch (section) {
        case 0:
            return NSLocalizedString(@"System", @"Section header");
            
        case 1:
            return NSLocalizedString(@"Datum", @"Section header");
            
        case 2:
            return NSLocalizedString(@"Format", @"Section header");
            
        default:
            return @"";
    }
}

#pragma mark - CoordinateSystemListDelegate

- (void)coordinateSystemsList:(CoordinateSystemsListController *)controller
    didSelectCoordinateSystem:(CoordinateSystem *)coordinateSystem {
    
    _saveButton.enabled = YES;
    _coordinateSystem = coordinateSystem;
    [self.tableView reloadData];
}

#pragma mark - IBActions

- (IBAction)saveButton:(UIBarButtonItem *)sender {
    
    if ([self.delegate respondsToSelector:@selector(coordinateSystemPicker:didSelectCoordinateSystem:)]) {
    
        [self.delegate coordinateSystemPicker:self
                    didSelectCoordinateSystem:_coordinateSystem];
    }
    
//    [self saveFormToModel];
    [self goToSettingsViewController];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {
    
    [self goToSettingsViewController];
}

#pragma mark - Navigation

- (void)goToSettingsViewController {
    
    UINavigationController *navigationController = self.navigationController;

    [navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"CoordinateSystemListSegue"]) {
        CoordinateSystemsListController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

@end
