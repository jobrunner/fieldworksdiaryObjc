//
//  FieldtripDetailsLocationNameCellTableViewCell.m
//  sunrise
//
//  Created by Jo Brunner on 12.07.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "FieldtripDetailsLocationNameCell.h"
#import "Fieldtrip.h"


@implementation FieldtripDetailsLocationNameCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    _locationNameTextField.delegate = self;
}

#pragma mark - FieldtripDetailsCellProtocol -

- (void)setFieldtrip:(Fieldtrip *)fieldtrip
{
    _fieldtrip = fieldtrip;
    
    [self updateUserInterface];
}


- (Fieldtrip *)fieldtrip
{
    return _fieldtrip;
}


- (void)updateUserInterface
{
    _locationNameTextField.text = _fieldtrip.localityName;
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsLocationNameCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsLocationNameCell";
    
    return identifier;
}


#pragma mark - IBActions -


- (IBAction)locationNameTextFieldEditingDidEnd:(UITextField *)sender
{
    _fieldtrip.localityName = _locationNameTextField.text;
}


#pragma mark - UITextFieldDelegate -


- (BOOL)textFieldShouldReturn:(UITextField*)textField
{
    [textField resignFirstResponder];
    
    return YES;
}

@end
