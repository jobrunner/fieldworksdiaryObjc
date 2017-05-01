//
//  FieldtripDetailsLocationIdentifierCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 15.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//
#import "SampleDetailsLocalityIdentifierCell.h"
#import "Fieldtrip.h"

@implementation SampleDetailsLocalityIdentifierCell

@synthesize sample = _sample;


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style
//                reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    
//    return self;
//}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _localityIdentifierTextField.delegate = self;
}

#pragma mark - FieldtripDetailsCellProtocol -

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}

- (Fieldtrip *)sample {
    
    return _sample;
}

- (void)updateUserInterface {
    
    _localityIdentifierTextField.text = _sample.localityIdentifier;
}

#pragma mark - IBActions -

- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender {

    _sample.localityIdentifier = _localityIdentifierTextField.text;
}

#pragma mark - UITextFieldDelegate -

- (BOOL)textFieldShouldReturn:(UITextField*)textField {
    
    [textField resignFirstResponder];
    
    return YES;
}

@end
