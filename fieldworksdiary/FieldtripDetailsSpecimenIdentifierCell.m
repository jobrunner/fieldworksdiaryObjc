#import "FieldtripDetailsSpecimenIdentifierCell.h"
#import "Fieldtrip.h"

@implementation FieldtripDetailsSpecimenIdentifierCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

//

- (void)awakeFromNib
{
    _specimenIdentifierTextField.delegate = self;
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
    _specimenIdentifierTextField.text = @"140910#2"; // _fieldtrip.localityName;
}

- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsSpecimenIdentifierCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsSpecimenIdentifierCell";
    
    return identifier;
}


#pragma mark - IBActions -


- (IBAction)specimenIdentifierTextFieldEditingDidEnd:(UITextField *)sender
{
    // noch nicht im Model verfügbar
//    _fieldtrip.specimenIdentifier = _specimenIdentifierTextField.text;
}


#pragma mark - UITextFieldDelegate -


- (BOOL)textFieldShouldReturn:(UITextField*)aTextField
{
    [aTextField resignFirstResponder];
    
    return YES;
}

@end
