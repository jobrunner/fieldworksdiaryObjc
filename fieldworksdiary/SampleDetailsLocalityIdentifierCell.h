//
//  SampleDetailsLocalityIdentifierCell.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 15.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@class Fieldtrip;

@interface SampleDetailsLocalityIdentifierCell : UITableViewCell <
    UITextFieldDelegate>

@property (strong, nonatomic) Fieldtrip *sample;
@property (weak, nonatomic) IBOutlet UITextField *localityIdentifierTextField;

- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender;

@end
