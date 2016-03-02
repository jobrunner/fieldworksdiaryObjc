//
//  FieldtripDetailsLocationIdentifierCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 15.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//
#import "FieldtripDetailsLocalityIdentifierCell.h"
#import "Fieldtrip.h"

@implementation FieldtripDetailsLocalityIdentifierCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    
    return self;
}

- (void)awakeFromNib {
    
    _localityIdentifierTextField.delegate = self;
}

#pragma mark - FieldtripDetailsCellProtocol -

- (void)setFieldtrip:(Fieldtrip *)fieldtrip {
    
    _fieldtrip = fieldtrip;
    
    [self updateUserInterface];
}

- (Fieldtrip *)fieldtrip {
    
    return _fieldtrip;
}

- (void)updateUserInterface {
    
    _localityIdentifierTextField.text = _fieldtrip.localityIdentifier;
}

- (NSString *)reuseIdentifier {
    
    return [FieldtripDetailsLocalityIdentifierCell reuseIdentifier];
}

+ (NSString *)reuseIdentifier {
    
    static NSString *identifier = @"FieldtripDetailsLocalityIdentifierCell";
    
    return identifier;
}

#pragma mark - IBActions -

- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender {

    _fieldtrip.localityIdentifier = _localityIdentifierTextField.text;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
