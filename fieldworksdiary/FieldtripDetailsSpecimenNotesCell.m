//
//  FieldtripDetailsNotesCell.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 20.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "FieldtripDetailsSpecimenNotesCell.h"
#import "Fieldtrip.h"

@interface FieldtripDetailsSpecimenNotesCell()



@end

@implementation FieldtripDetailsSpecimenNotesCell

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
    _specimenNotesTextView.delegate = self;
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
    _specimenNotesTextView.text = _fieldtrip.specimenNotes;
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsSpecimenNotesCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsSpecimenNotesCell";
    
    return identifier;
}


#pragma mark - IBActions -


- (IBAction)specimenNotesTextViewEditingDidEnd:(UITextField *)sender
{
    _fieldtrip.specimenNotes = _specimenNotesTextView.text;
}


#pragma mark - UITextViewDelegate -

- (void)textViewDidEndEditing:(UITextView *)textView
{
    NSLog(@"textViewDidEndEditing:");
    
    [textView resignFirstResponder];
    _fieldtrip.specimenNotes = _specimenNotesTextView.text;
}



//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touchesBegan:withEvent:");
//
//    [self endEditing:YES];
//    [super touchesBegan:touches
//              withEvent:event];
//}

- (BOOL)textFieldShouldReturn:(UITextView*)textView
{
    [textView resignFirstResponder];
    
    return YES;
}


//- (BOOL)textViewShouldBeginEditing:(UITextView *)textView
//{
//    NSLog(@"textViewShouldBeginEditing:");
//
//    return YES;
//}

//- (void)textViewDidBeginEditing:(UITextView *)textView
//{
//    NSLog(@"textViewDidBeginEditing:");
//
//    textView.backgroundColor = [UIColor greenColor];
//}

@end
