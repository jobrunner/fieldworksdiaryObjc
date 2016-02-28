//
//  SettingsController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsController : UITableViewController

@property (weak, nonatomic) IBOutlet UITableViewCell *activeCollectorCell;
@property (weak, nonatomic) IBOutlet UITextField *locationIdentifierPrefixTextField;
@property (weak, nonatomic) IBOutlet UITableViewCell *activeFieldtripCell;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripsCountLabel;


- (IBAction)locationIdentifierPrefixTextFieldEditingDidEnd:(UITextField *)sender;

@end
