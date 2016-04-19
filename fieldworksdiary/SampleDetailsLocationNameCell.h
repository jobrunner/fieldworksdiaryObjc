@class Fieldtrip;

@interface SampleDetailsLocationNameCell : UITableViewCell <UITextFieldDelegate>

@property (strong, nonatomic) Fieldtrip *sample;

@property (weak, nonatomic) IBOutlet UITextField *locationNameTextField;

- (IBAction)locationNameTextFieldEditingDidEnd:(UITextField *)sender;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
