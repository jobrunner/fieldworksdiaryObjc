//
//  HomeTableViewController.m
//  sunrise
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "HomeController.h"

@interface HomeController ()


@property (weak, nonatomic) IBOutlet UIButton *addFieldtripButton;
@property (weak, nonatomic) IBOutlet UIButton *addFieldtripWithCameraButton;

@property (weak, nonatomic) IBOutlet UILabel *countOfFieldtripsCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfSpecimensCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfFindingsCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfPhotosCaptionLabel;


@property (weak, nonatomic) IBOutlet UILabel *countOfFieldtripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfSpecimensLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfFindingsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfPhotosLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfProjectsLabel;


@property (weak, nonatomic) IBOutlet UITableViewCell *recentFieldtripCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fieldtripsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *projectsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *peopleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *aboutCell;

@end

@implementation HomeController

#pragma mark - ViewController -

- (void)viewDidLoad
{
    [super viewDidLoad];

    
    // Besser wäre eine Übersetzung im StoryBoard.
    _countOfFieldtripsCaptionLabel.text = @"EXKURSIONEN";
    _countOfSpecimensCaptionLabel.text = @"PROBEN";
    _countOfFindingsCaptionLabel.text = @"FUNDE";
    _countOfPhotosCaptionLabel.text = @"FOTOS";
    
    _recentFieldtripCell.textLabel.text = @"Letzte Exkursion";
    _fieldtripsCell.textLabel.text = @"Exkursionen";
    _projectsCell.textLabel.text = @"Projekte/Expeditionen";
    _aboutCell.textLabel.text = @"Über Fieldworksdiary";
    

    // Nicht holen, sondern setzten.
    // AppDelegate hat den Context ausserdem bereits gesetzt!
    
    // get managed object context from Application
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // get delegate methods from navigationController
    [self navigationController].delegate = self;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;

}

- (void)viewDidAppear:(BOOL)animated
{
    NSEntityDescription *entity;
    NSError *error = nil;
    NSUInteger count = 0;
    
    // fieldtrips
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // {{{ Amount of fieldtrips in the request...
    entity = [NSEntityDescription entityForName:@"Fieldtrip"
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];
    
    count = [self.managedObjectContext countForFetchRequest:request
                                                      error:&error];
    
    self.recentFieldtripCell.userInteractionEnabled = (count > 0);
    
    self.countOfFieldtripsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    // }}}

    // {{{ Specimen count
    entity = [NSEntityDescription entityForName:@"Specimen"
                         inManagedObjectContext:self.managedObjectContext];

    [request setEntity:entity];
    
    count = [self.managedObjectContext countForFetchRequest:request
                                                      error:&error];
    
    self.countOfSpecimensLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    // }}}
    
    
    // {{{ Project count
    entity = [NSEntityDescription entityForName:@"Project"
                         inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    count = [self.managedObjectContext countForFetchRequest:request
                                                      error:&error];
    
    self.countOfProjectsLabel.text = [NSString stringWithFormat:@"%lu", (unsigned long)count];
    // }}}
    
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSLog(@"prepareForSegue: %@", [segue identifier]);
    
    // open fieldtrips
    if ([[segue identifier] isEqualToString:@"openFieldtripsSegue"]) {
        //        FieldtripTableViewController * controller = segue.destinationViewController;
        //
        //        controller.managedObjectContext = self.managedObjectContext;
    }
    
    // open projects
    if ([[segue identifier] isEqualToString:@"openProjectsSegue"]) {
        //        ProjectTableViewController * controller = segue.destinationViewController;
        //
        //        controller.managedObjectContext = self.managedObjectContext;
    }
    
    //    if ([[segue identifier] isEqualToString:@"createLocalitySegue"]) {
    //
    //        FieldtripDetailsViewController * controller = segue.destinationViewController;
    //
    //        NSInteger section = 0;
    //        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
    //
    //        controller.fieldtripCount = [sectionInfo numberOfObjects];
    //        controller.fieldtrip = nil;
    //    }

    
    if ([[segue identifier] isEqualToString:@"createFieldtripSegue"]) {
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
    }
    
    
    if ([[segue identifier] isEqualToString:@"createFieldtripWithPhotoSegue"]) {
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
        controller.startWithTakePicture = YES;
    }
    
    
    // Show the most recent fieldtrip
    if ([[segue identifier] isEqualToString:@"openRecentFieldtrip"]) {

        NSError *error = nil;

        // fieldtrips
        NSFetchRequest *request = [[NSFetchRequest alloc] init];
        
        // count of all fieldtrips
        NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Fieldtrip"
                                                       inManagedObjectContext:self.managedObjectContext];
        [request setEntity:entityDesc];

        NSUInteger count = [self.managedObjectContext countForFetchRequest:request
                                                                     error:&error];
        // limit the fetch request to one object
        [request setFetchLimit:1];

        // and set got through offset to the last object
        [request setFetchOffset:(count - 1)];
        
        NSArray *results = [self.managedObjectContext executeFetchRequest:request
                                                                    error:&error];
        NSManagedObject *latestFieldtrip = [results firstObject];

        // pass the most recent fieldtrip object (the last in the fetch request)
        // to FieldtripDetailsViewController
        // If there is still no object, nil will be passed and a new object will be created.
        // Thus, the "recent fildtrip" item should be disabled when no objecs
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = (Fieldtrip *)latestFieldtrip;
    }
}


#pragma mark - NavigationControllerDelegates -


// delegate method before navigation and view did load
// This implementation is not well seperated by concern
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if (viewController == self) {
        if (![self navigationController].navigationBarHidden) {
            [[self navigationController] setNavigationBarHidden:YES
                                                       animated:NO];
        }
    } else {
        if ([self navigationController].navigationBarHidden) {
            [[self navigationController] setNavigationBarHidden:NO
                                                       animated:NO];
        }
    }
}


#pragma mark - Table view data source -

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

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


@end