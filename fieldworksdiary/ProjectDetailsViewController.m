//
//  ProjectDetailsViewController.m
//

#import "ProjectDetailsViewController.h"


@interface ProjectDetailsViewController ()

@property (weak, nonatomic) IBOutlet UITextField *projectShortNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectLongNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectIdTextField;
@property (weak, nonatomic) IBOutlet UITextField *projectPrefixIdTextField;
@property (weak, nonatomic) IBOutlet UITextView *projectNotesTextView;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *isDefaultProjectSwitch;
@property (weak, nonatomic) IBOutlet UISwitch *isFavoritSwitch;
@property (weak, nonatomic) IBOutlet UILabel *collectorLabel;

- (IBAction)isDefaultProjectSwitchDidChanged:(UISwitch *)sender;
- (IBAction)isFavoritSwitchDidChanged:(UISwitch *)sender;

@property (strong, nonatomic) UIAlertView *errorAlert;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end

@implementation ProjectDetailsViewController

#pragma mark - UIViewControllerDelegate

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    self.projectNotesTextView.delegate = self;
    
    if (self.project == nil) {
        // create a new locality model
        [self createNewModelForEditing];
    } else {
        // show or edit a locality model
        [self showExistingModelForEditing];
    }
}


- (void)viewDidAppear:(BOOL)animated
{
    
}


- (void)viewDidDisappear:(BOOL)animated
{
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    NSLog(@"didMoveToParentViewController");
    
    if (![parent isEqual:self.parentViewController]) {

        NSLog(@"trigger saveFormToModel");
        [self saveFormToModel];
    }
}


#pragma mark - Form Data


- (void)showExistingModelForEditing
{
    self.navigationItem.title = self.project.projectShortName;
    
    [self drawProjectFromModel];
}


- (void)createNewModelForEditing
{
    self.project = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                   inManagedObjectContext:self.managedObjectContext];
    [self.navigationItem setTitle:@"New"];
    
    [self setModelWithDefaults];
    
    [self drawProjectFromModel];
}

#pragma mark - Form Data to Model


- (void)saveFormToModel
{
    // set model data
    self.project.projectShortName = self.projectShortNameTextField.text;
    self.project.projectLongName = self.projectLongNameTextField.text;


    // beginDate, endDate, isFavorit, isDefaultProject, collector (muss defaultCollector heißen!) 
    // werden direkt nach User-Aktion ins Model geschrieben
    

    //    self.project.beginDate = self.beginDate
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}


// Standard Data for new Model
- (void)setModelWithDefaults
{
    self.project.projectShortName = @"New project name";
    
    self.project.beginDate = [NSDate date];
    
    // Eine Stunde als Standard-Endzeit => konfigurieren!!!
    self.project.endDate = [[NSDate date] dateByAddingTimeInterval:60.0 * 60.0];
    
    // Standard: Keine Zeitintervall (anzeigen).
//    self.fieldtrip.isFullTime = NO;
    
//    self.fieldtrip.timeZoneName = [[NSTimeZone systemTimeZone] name];
    
    // ...
}


#pragma mark - Model to UI

// am liebsten wäre es mir, wenn ein Feld immer dann (autom.) gezeichnet wird
// wenn sich am Model etwas ändert. Diese Lösung ist jetzt erst mal good enough
- (void)drawProjectFromModel
{
    self.projectShortNameTextField.text = self.project.projectShortName;
    self.projectLongNameTextField.text = self.project.projectLongName;
//    self.projectIdTextField.text = self.project.projectId;
//    self.projectPrefixIdTextField.text = self.project.projectPrefixId;
//    self.beginDateLabel.text = [self.project.beginDate description];
//    self.endDateLabel.text = [self.project.endDate description];
    
    // ...
}




#pragma mark - UI Actions


- (IBAction)isFavoritSwitchDidChanged:(UISwitch *)sender
{
}

- (IBAction)isDefaultProjectSwitchDidChanged:(UISwitch *)sender
{
}

@end
