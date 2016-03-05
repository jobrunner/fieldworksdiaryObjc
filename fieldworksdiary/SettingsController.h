//
//  SettingsController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "ProjectTableViewController.h"

@interface SettingsController : UITableViewController <FieldtripPickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *locationIdentifierPrefixTextField;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripsCountLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeCollectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeFieldtripLabel;

- (IBAction)locationIdentifierPrefixTextFieldEditingDidEnd:(UITextField *)sender;

@end
