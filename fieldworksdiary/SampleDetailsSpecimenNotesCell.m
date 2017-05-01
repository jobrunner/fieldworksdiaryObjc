#import "SampleDetailsSpecimenNotesCell.h"
#import "Fieldtrip.h"

@implementation SampleDetailsSpecimenNotesCell

@synthesize sample = _sample;

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _specimenNotesTextView.delegate = self;
}

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;

    [self updateUserInterface];
}

- (Fieldtrip *)sample {
    
    return _sample;
}

- (void)updateUserInterface {
    
    _specimenNotesTextView.text = _sample.specimenNotes;
}

#pragma mark - IBActions -

- (IBAction)specimenNotesTextViewEditingDidEnd:(UITextField *)sender {
    
    _sample.specimenNotes = _specimenNotesTextView.text;
}


#pragma mark - UITextViewDelegate -

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];

    _sample.specimenNotes = _specimenNotesTextView.text;
}

//- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
//{
//    NSLog(@"touchesBegan:withEvent:");
//
//    [self endEditing:YES];
//    [super touchesBegan:touches
//              withEvent:event];
//}

- (BOOL)textFieldShouldReturn:(UITextView*)textView {
    
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
