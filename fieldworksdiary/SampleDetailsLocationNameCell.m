//
//  FieldtripDetailsLocationNameCellTableViewCell.m
//  sunrise
//
//  Created by Jo Brunner on 12.07.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "SampleDetailsLocationNameCell.h"
#import "Fieldtrip.h"


@implementation SampleDetailsLocationNameCell

@synthesize sample = _sample;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _locationNameTextField.delegate = self;
}

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}


- (Fieldtrip *)sample {
    
    return _sample;
}


- (void)updateUserInterface {
    
    _locationNameTextField.text = _sample.localityName;
}


#pragma mark - IBActions -


- (IBAction)locationNameTextFieldEditingDidEnd:(UITextField *)sender {
    
    _sample.localityName = _locationNameTextField.text;
}


#pragma mark - UITextFieldDelegate -


- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
