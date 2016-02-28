//
//  ProjectDetailsViewController.m
//

#import "ProjectDetailsViewController.h"


@interface ProjectDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationPrefixTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isActiveSwitch;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateCaptionLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *beginDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *endDateCaptionLabel;

- (IBAction)nameEditingDidEnd:(UITextField *)sender;
- (IBAction)nameEditingChanged:(UITextField *)sender;
- (IBAction)locationPrefixEditingDidEnd:(UITextField *)sender;
- (IBAction)locationPrefixEditingChanged:(UITextField *)sender;
- (IBAction)isActiveSwitchDidChanged:(UISwitch *)sender;


@property (strong, nonatomic) UIAlertView *errorAlert;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end

@implementation ProjectDetailsViewController

#pragma mark - UIViewControllerDelegate

- (void)viewDidLoad {

    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    self.notesTextView.delegate = self;
    
    if (self.fieldtrip == nil) {
        // create a new locality model
        [self createNewModelForEditing];
    } else {
        // show or edit a locality model
        [self showExistingModelForEditing];
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

#pragma mark - Form Data

- (void)showExistingModelForEditing {

    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem.title = @"Save";
    self.navigationItem.rightBarButtonItem.enabled = false;

    // wenn ein Wert verändert wurde: enablen.
    
    [self loadFormData];
}

- (void)createNewModelForEditing {
    
    self.fieldtrip = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                   inManagedObjectContext:self.managedObjectContext];
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem.title = @"Hinzufügen";
    self.navigationItem.rightBarButtonItem.enabled = false;

    // move to model logic:
    [self setModelWithDefaults];
    
    [self loadFormData];
}

#pragma mark - Form Data handling

- (void)loadFormData {
    
    NSLog(@"model: %@", self.fieldtrip.isActive);
    NSLog(@"control: %@", [NSNumber numberWithBool:self.isActiveSwitch.on]);
    
    
    self.nameTextField.text = self.fieldtrip.name;
    self.locationPrefixTextField.text = self.fieldtrip.locationPrefix;
    self.isActiveSwitch.on = (BOOL)self.fieldtrip.isActive;
    self.notesTextView.text = self.fieldtrip.notes;
    
    
    
}

- (void)saveFormToModel {

    // set model data
    self.fieldtrip.name = self.nameTextField.text;
    self.fieldtrip.locationPrefix = self.locationPrefixTextField.text;
    self.fieldtrip.isActive = 0; // [NSNumber numberWithBool:self.isActiveSwitch.on];
    self.fieldtrip.notes = self.notesTextView.text;


    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

// Standard Data for new Model
- (void)setModelWithDefaults {

    self.fieldtrip.name = nil; // @"Name of new fieldtrip";
    self.fieldtrip.beginDate = [NSDate date];
    
    // Eine Stunde als Standard-Endzeit
    self.fieldtrip.endDate = [[NSDate date] dateByAddingTimeInterval:60.0 * 60.0];
}

#pragma mark - UI Actions

- (void)formDidChanged:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (IBAction)nameEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)nameEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)locationPrefixEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)locationPrefixEditingChanged:(UITextField *)sender {

    [self formDidChanged:sender];
}

- (IBAction)isActiveSwitchDidChanged:(UISwitch *)sender {

    [self formDidChanged:sender];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {

    [self saveFormToModel];
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

@end
