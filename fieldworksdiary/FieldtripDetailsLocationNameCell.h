#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsLocationNameCell : UITableViewCell <FieldtripDetailsCellProtocol, UITextFieldDelegate>

@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;

- (IBAction)locationNameTextFieldEditingDidEnd:(UITextField *)sender;

@end
