#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsSpecimenIdentifierCell : UITableViewCell <FieldtripDetailsCellProtocol, UITextFieldDelegate>

@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property (weak, nonatomic) IBOutlet UITextField *specimenIdentifierTextField;

- (IBAction)specimenIdentifierTextFieldEditingDidEnd:(UITextField *)sender;

+ (NSString *)reuseIdentifier;
//- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
//- (Fieldtrip *)fieldtrip;

@end
