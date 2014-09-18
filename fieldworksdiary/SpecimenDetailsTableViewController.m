//
//  SpecimenDetailsTableViewController.m
//  sunrise
//
//  Created by Jo Brunner on 18.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "SpecimenDetailsTableViewController.h"

@interface SpecimenDetailsTableViewController ()

@property (weak, nonatomic) IBOutlet UILabel *localityNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *specimenNotesTextView;
@property (weak, nonatomic) IBOutlet UITextField *specimenIdentifierTextField;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end

@implementation SpecimenDetailsTableViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    self.specimenNotesTextView.delegate = self;
    
    if (self.specimen == nil) {
        // create a new locality model
        [self createNewModelForEditing];
    } else {
        // show or edit a locality model
        [self showExistingModelForEditing];
    }
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
//    self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Form Data


- (void)showExistingModelForEditing
{
    self.navigationItem.title = @""; // self.specimen.specimenIdentifier;
    
    [self drawSpecimenFromModel];
}


- (void)createNewModelForEditing
{
    self.specimen = [NSEntityDescription insertNewObjectForEntityForName:@"Specimen"
                                                 inManagedObjectContext:self.managedObjectContext];
    [self.navigationItem setTitle:@"New"];
    
    [self setModelWithDefaults];
    
    [self drawSpecimenFromModel];
}

#pragma mark - Form Data to Model


- (void)saveFormToModel
{
    // set model data
    self.specimen.specimenIdentifier = self.specimenIdentifierTextField.text;
    self.specimen.specimenNotes = self.specimenNotesTextView.text;
    
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
    // Konvention: das aktuelle Datum von Sonnenaufgang
    self.specimen.specimenIdentifier = @"New project name";
    self.specimen.specimenNotes = @"";

//    self.project.beginDate = [NSDate date];
    
    // Eine Stunde als Standard-Endzeit => konfigurieren!!!
//    self.project.endDate = [[NSDate date] dateByAddingTimeInterval:60.0 * 60.0];
    
    // Standard: Keine Zeitintervall (anzeigen).
    //    self.fieldtrip.isFullTime = NO;
    
    //    self.fieldtrip.timeZoneName = [[NSTimeZone systemTimeZone] name];
    
    // ...
}


#pragma mark - Model to UI

// am liebsten wäre es mir, wenn ein Feld immer dann (autom.) gezeichnet wird
// wenn sich am Model etwas ändert. Diese Lösung ist jetzt erst mal good enough
- (void)drawSpecimenFromModel
{
    self.specimenIdentifierTextField.text = self.specimen.specimenIdentifier;
    self.specimenNotesTextView.text = self.specimen.specimenNotes;
    //    self.projectIdTextField.text = self.project.projectId;
    //    self.projectPrefixIdTextField.text = self.project.projectPrefixId;
    //    self.beginDateLabel.text = [self.project.beginDate description];
    //    self.endDateLabel.text = [self.project.endDate description];
    
    // ...
}
















#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 0;
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
