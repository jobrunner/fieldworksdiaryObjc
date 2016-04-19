//
//  TimeZonePicker.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "TimeZonePickerController.h"
#import "TimeZonePickerCell.h"

@interface TimeZonePickerController ()

- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

@implementation TimeZonePickerController

#pragma mark - UITableView Delegates

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _timezoneNames = [[NSTimeZone knownTimeZoneNames] sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - UITableViewController delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return [_timezoneNames count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"TimeZonePickerCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellId
                                              bundle:nil]
        forCellReuseIdentifier:cellId];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(TimeZonePickerCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *timeZoneName = [_timezoneNames objectAtIndex:indexPath.item];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];

    // Die cell muss nun wissen, ob sie einen Eintrag bereits markiert...

    BOOL selected = ([timeZoneName isEqualToString:self.timeZone.name]);
    
    [cell configureWithTimeZone:timeZone
                    atIndexPath:indexPath
                       selected:selected];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if ([self.delegate respondsToSelector:@selector(timeZonePicker:didSelectTimeZone:)]) {
    
        NSString *timeZoneName = [_timezoneNames objectAtIndex:indexPath.item];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];

        // call delegate method to inform about the change
        [self.delegate timeZonePicker:self
                    didSelectTimeZone:timeZone];
    }
        
    [self.navigationController popViewControllerAnimated:YES];
}

// Dosn't support native editing of table view cells.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

// Dosn't support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - IBActions

- (IBAction)cancelButton:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

@end
