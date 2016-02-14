//
//  FieldtripDetailsViewController.m
//  Fieldtrip
//
//  Created by Jo Brunner on 11.02.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
// crete new Locality object
// Locality defined the WHERE, WHEN, WHO
// WHERE:
//   - Position (lat, lng, alt, accuracies)
//   - Political (Country, State, County, City, Locality, Sublocality)
//   - My Location (Name of this locality like "NSG Ruine Homburg"
//
// WHEN:
//   - Date and Time (with or without a given time and or as a date range)
//   - whether the given time is in the night or in daylight
//
// WHO:
//    - the collector could be a predefined collector or one or more manually edited collector(s).
//
// diverse:
//    - notices about the locality (about location, excursion etc.)
//

#import "FieldtripDetailsViewController.h"
#import "AppDelegate.h"
#import "Enums.h"
#import "LocationService.h"
#import "Crypto.h"

// cell classes
#import "FieldtripDetailsSpecimenIdentifierCell.h"
#import "FieldtripDetailsSpecimenNotesCell.h"
//#import "FieldtripDetailsLocationNameCell.h"
#import "FieldtripDetailsLocationCell.h"
#import "FieldtripDetailsPlacemarkCell.h"
#import "FieldtripDetailsDateCell.h"
#import "FieldtripDetailsProjectCell.h"
#import "FieldtripDetailsMapViewCell.h"
#import "SpecimenDetailsTableViewController.h"
#import "FieldtripDetailsEditViewController.h"
#import "SpecimenMapController.h"
#import "Conversion.h"
#import "EDSunriseSet.h"
#import "Fieldtrip.h"
#import "Image.h"



@interface FieldtripDetailsViewController ()


// die IBOutlets hängen noch alle an der Statischen View
//@property (weak, nonatomic) IBOutlet UITextField *localityNameTextField;
//@property (weak, nonatomic) IBOutlet UILabel *coordinatesTypeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *coordinatesLabel;
//@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
//@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
//@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
//@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
//@property (weak, nonatomic) IBOutlet UIImageView *dayNightStatusImageView;
//@property (weak, nonatomic) IBOutlet UIImageView *staticMapImage;
//@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
//@property (weak, nonatomic) IBOutlet UILabel *countryAndAdministrativeAreaLabel;
//@property (weak, nonatomic) IBOutlet UIScrollView *imageScrollView;

//@property (weak, nonatomic) IBOutlet UILabel *subAdministrativeAreaLabel;
//@property (weak, nonatomic) IBOutlet UILabel *administrativeLocalityLabel;
//@property (weak, nonatomic) IBOutlet UILabel *administrativeSubLocalityLabel;


//@property (strong, nonatomic) NSTimer * timer;

//@property (strong, nonatomic) UIAlertView *errorAlert;
//@property (retain, nonatomic) MKMapView *mapView;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property (strong, nonatomic) CLLocationManager * locationManager;
@property (strong, nonatomic) CLLocation * location;
@property (strong, nonatomic) UIRefreshControl *refreshControl;
@property (strong, nonatomic) UIToolbar *toolbar;


// testing:
//@property (weak, nonatomic) IBOutlet UIButton *locationUpdateButton;
//- (IBAction)locationUpdateButtonTouched:(UIButton *)sender;

@property BOOL locationTracking;
@property int locationUpdateTries;


- (IBAction)editButtonTouched:(UIBarButtonItem *)sender;

//- (IBAction)localityNameTextFieldDidEndOnExit:(UITextField *)sender;
//- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender;
//- (IBAction)cancelButtonTouched:(UIBarButtonItem *)sender;


@end

@implementation FieldtripDetailsViewController


#pragma mark - IBOutlet Actions


/*!
 *  Action triggered when user presses the Done button on keyboard
 *
 *  @param sender UITextField control the user can press.
 *
 *  @since 1.0
 */
- (IBAction)editButtonTouched:(UIBarButtonItem *)sender
{
    [self saveFormToModel];
    
    // open fieldtrip detail edit
}

//- (IBAction)localityNameTextFieldDidEndOnExit:(UITextField *)sender
//{
//    self.fieldtrip.localityName = self.localityNameTextField.text;
//    
//    [sender resignFirstResponder];
//}


- (IBAction)saveButtonTouched:(UIBarButtonItem *)sender
{
    // set model data
//    self.fieldtrip.localityName = self.localityNameTextField.text;
    
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
    
    // go back to previous view in the navigation stack
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)cancelButtonTouched:(UIBarButtonItem *)sender
{
    // go back to previous view in the navigation stack
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)takePhoto
{
    UIImagePickerController *picker = [[UIImagePickerController alloc] init];
    
    picker.delegate = self;
    picker.allowsEditing = NO;

    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
    } else {
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    
    [self presentViewController:picker
                       animated:YES
                     completion:NULL];
}

- (IBAction)addSpecimen:(UIButton *)sender
{
    [self performSegueWithIdentifier:@"addSpecimenSegue" sender:self];
}





#pragma mark - UIImagePickerController Delegates -


- (void)imagePickerController:(UIImagePickerController *)picker
didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *chosenImage = info[UIImagePickerControllerEditedImage];
  
//    self.staticMapImage.image = chosenImage;
    
    
//    CGSize thumbSize;
//    thumbSize.height = 40;
//    thumbSize.width  = 40;
//    UIGraphicsBeginImageContext(thumbSize);
//    [chosenImage drawInRect:CGRectMake(0, 0, thumbSize.width, thumbSize.height)];
//    UIImage* thumbImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    // convert images to PNG file format
    NSData *pngImageData = UIImagePNGRepresentation(chosenImage);
//    NSData *thumbImageData = UIImagePNGRepresentation(thumbImage);

//    chosenImage = nil;
    
    // create a filename based on sha1
    NSString *sha1Hash = [Crypto sha1WithBinary:pngImageData];
    NSString *filename = [NSString stringWithFormat:@"%@.png", sha1Hash];

    Image * image = [NSEntityDescription insertNewObjectForEntityForName:@"Image"
                                                  inManagedObjectContext:self.managedObjectContext];
    
    image.filename = filename;
    image.created = [NSDate date];
    image.type = @0;

    // representations could be stored in representations property
    
    
    
//    [photo setPictureData:pngImageData];
  
  
    [self.fieldtrip addImagesObject:image];
    
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
        [picker dismissViewControllerAnimated:YES
                                   completion:NULL];
        return ;
    }
    
    // Create Pictures in users Documents directory if it doesn't exist
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Pictures"];
    
    // Does directory already exist? No, then create it.
    if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                       withIntermediateDirectories:NO
                                                        attributes:nil
                                                             error:&error]) {
            NSLog(@"Create directory error: %@", error);
        }
    }
    
    // create the full file path
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    
    NSLog(@"Full path to store picture: %@", filePath);

    
    NSFileManager *fileManager = [NSFileManager defaultManager];

    if (YES == [fileManager createFileAtPath:filePath
                                    contents:pngImageData
                                  attributes:nil]) {
    
    
    
        // store the png
        NSLog(@"Picture stored.");
    } else {
        NSLog(@"Failed to write map file to disc.");

        [self.fieldtrip removeImagesObject:image];
        [self.managedObjectContext save:&error];
        if (error) {
            NSLog(@"Error: %@", [error localizedDescription]);
        }
    }
    
    
    
//    UIImageView * imageView = [[UIImageView alloc] initWithImage:thumbImage];
//    [self.imageScrollView addSubview:imageView];
    
    
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES
                               completion:NULL];
    
}



#pragma mark - Refreshing

- (void)refreshTableView
{
//    NSLog(@"Start to refresh location!");
//
//    if ([self.locationUpdateButton isEnabled] == NO) {
//        
//        NSLog(@"locationUpdateButton is not enabled. No operation.");
//        return ;
//    }
//    
//    if ([self.locationUpdateButton isSelected] == NO) {
//        [self startLocationTracking];
//    } else {
//        [self stopLocationTracking];
//
//    }
    
    // [self.refreshControl endRefreshing];
}



#pragma mark - Location Helper

// -> Fieldtrip locationFromUndefiened
//- (CLLocation *)locationFromUndefined
//{
//    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(0.0,
//                                                               0.0);
//    return [[CLLocation alloc] initWithCoordinate:coords
//                                         altitude:0.0
//                               horizontalAccuracy:0.9
//                                 verticalAccuracy:0.0
//                                        timestamp:nil];
//}



// -> Fieldtrip location
//- (CLLocation *)locationFromModel
//{
//    
//    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.fieldtrip.latitude doubleValue],
//                                                               [self.fieldtrip.longitude doubleValue]);
//    return [[CLLocation alloc] initWithCoordinate:coords
//                                         altitude:[self.fieldtrip.altitude doubleValue]
//                               horizontalAccuracy:[self.fieldtrip.horizontalAccuracy doubleValue]
//                                 verticalAccuracy:[self.fieldtrip.verticalAccuracy doubleValue]
//                                        timestamp:self.fieldtrip.beginDate];
//}

#pragma mark - Form Data

- (void)showExistingModelForEditing
{
    self.navigationItem.title = self.fieldtrip.localityName;

    // Prevent activating automatic location updates
//    [self.locationUpdateButton setEnabled:NO];
    
//    [self drawLocalityFromModel];
//    [self drawTimeZoneFromModel];
//    [self drawBeginDateFromModel];
//    [self drawLocationFromModel];
//    [self drawPlacemarkFromModel];
//    [self drawDayNightStatusFromModel];
//    [self drawMapFromModel];
    
    // ...
}



- (void)createNewModelForEditing
{
    self.fieldtrip = [NSEntityDescription insertNewObjectForEntityForName:@"Fieldtrip"
                                                   inManagedObjectContext:self.managedObjectContext];
    [self.navigationItem setTitle:@"New"];
    
    // Create a default model
    [self.fieldtrip defaultsWithLocalityName:NSLocalizedString(@"Mein Fundort", nil)];


//    [self drawLocalityFromModel];
//    [self drawBeginDateFromModel];
//    [self drawTimeZoneFromModel];
    
    [self startLocationTracking];
}


#pragma mark - ViewController Delegates


//- (id)initWithStyle:(UITableViewStyle)style
//{
//    self = [super initWithStyle:style];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}


- (void)viewDidLoad
{
    [super viewDidLoad];

    // get core data stack
    self.managedObjectContext = ApplicationDelegate.managedObjectContext;
    
    // Because we want the Keybord return button working:
//    self.localityNameTextField.delegate = self;

    // Configure refresh controll
    UIRefreshControl *refresh = [[UIRefreshControl alloc] init];
    refresh.tintColor = [UIColor grayColor];
    
    [refresh addTarget:self
                action:@selector(refreshTableView)
      forControlEvents:UIControlEventValueChanged];
    
    self.refreshControl = refresh;
    
    
	// We will observe "Placemark found" and "Placemark not found" notifications in
    // the method receivedNotification if they arrived in NotificationCenter
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(calculateSunriseSunsetTwilight)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
//
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(clearPlacemark)
//                                                 name:@"Placemark not found"
//                                               object:nil];
    

    // add photo buttom in navigation bar
    UIBarButtonItem *btnCurrent = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *btnCamera = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCamera
                                                                               target:self
                                                                               action:@selector(takePhoto)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCurrent, btnCamera, nil]];
    
    if (self.fieldtrip == nil) {
        
        NSLog(@"create a new locality model");
        // create a new locality model
        if (_startWithTakePicture == YES) {
            
            // 1) bool ist hier doof.
            // 2) das Neuerstellen des Fieldtrips muss in einem Hintergrund-Thread gemacht und muss noch keine Map oder korrekte Placemarks enthalten. Wichtig ist aber, dass die images gespeichert worden sind
            // 3) Doofe Frage: Das Foto-Feature macht ganz anders Sinn: Wenn es einen Recent Fieldtrip gibt, der kurzlich erstellt worden ist - d.h., in der "letzten" Sammelzeit (z.B. von Sonnenaufgang bis zum nächsten Sonnenaufgang und in einem Umkreis von vielleicht 1Km) wird das Bild autom. zum letzten Fieldtrip hinzugefügt. Ansonsten wird ein neuer Fieldtrip erstellt und das Bild dann hinzugefügt. DAs klingt etwas kompliziert - wenn der User nichts davon merkt, ist das gut. Sonst scheiße.
            [self createNewModelForEditing];
        } else {
            [self createNewModelForEditing];
        }
    } else {
        NSLog(@"show or edit a locality model");
        // show or edit a locality model
        [self showExistingModelForEditing];
    }

    // register custom cell "TextFieldCell" for queueing
//    [self.tableView registerNib:[UINib nibWithNibName:[TextFieldCell reuseIdentifier]
//                                               bundle:[NSBundle mainBundle]]
//         forCellReuseIdentifier:[TextFieldCell reuseIdentifier]];
    
    //
    
    
//    [self.tableView registerNib:[UINib nibWithNibName:[ImageViewCell reuseIdentifier]
//                                               bundle:[NSBundle mainBundle]]
//         forCellReuseIdentifier:[ImageViewCell reuseIdentifier]];
}


- (void)viewDidAppear:(BOOL)animated
{
    return;
    _toolbar = [[UIToolbar alloc] init];
    _toolbar.barStyle = UIBarStyleDefault;
    
    //Set the toolbar to fit the width of the app.
    [_toolbar sizeToFit];
    
    //Caclulate the height of the toolbar
    CGFloat toolbarHeight = [_toolbar frame].size.height;
    
    //Get the bounds of the parent view
    CGRect viewBounds = self.parentViewController.view.bounds;
    
    //Get the height of the parent view.
    CGFloat rootViewHeight = CGRectGetHeight(viewBounds);
    
    //Get the width of the parent view,
    CGFloat rootViewWidth = CGRectGetWidth(viewBounds);
    
    //Create a rectangle for the toolbar
    CGRect rectArea = CGRectMake(0, rootViewHeight - toolbarHeight, rootViewWidth, toolbarHeight);
    
    //Reposition and resize the receiver
    [_toolbar setFrame:rectArea];
    
    //Add the toolbar as a subview to the navigation controller.
    [self.navigationController.view addSubview:_toolbar];
}


- (void)viewDidDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [_toolbar removeFromSuperview];
    [self stopLocationTracking];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)didMoveToParentViewController:(UIViewController *)parent
{
    if (![parent isEqual:self.parentViewController]) {
        
        [self saveFormToModel];
    }
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"editFieldtripDetailsSegue"]) {
        
        FieldtripDetailsEditViewController * controller = segue.destinationViewController;
        
        controller.fieldtrip = self.fieldtrip;
    }
    
    
    if ([[segue identifier] isEqualToString:@"addSpecimenSegue"]) {
        
        NSLog(@"create a new specimen from fieldtrip!");
        
        SpecimenDetailsTableViewController * controller = segue.destinationViewController;
        
        controller.specimen = nil;
    }
    
    if ([[segue identifier] isEqualToString:@"openSpecimenMap"]) {
        SpecimenMapController * controller = segue.destinationViewController;
        
        controller.fieldtrip = self.fieldtrip;
    }

}



// DAS brauche ich auch nicht, weil ich bereits an anderen STellen darauf reagiere. Right?!
// receiver for notifications from NotificationCenter we are listen to
//- (void)receivedNotification:(NSNotification *) notification
//{
//    if ([[notification name] isEqualToString:@"Address Found"]) {
//        NSLog(@"Received a placemark. Go and draw it, it's already in the model");
//
//        NSLog(@"Placemark müsste jetzt im UI aktualisiert werden...");
////        [self drawPlacemarkFromModel];
//        
//    } else if ([[notification name] isEqualToString:@"Not Found"]) {
////        [self clearPlacemark];
//
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Results Found"
//                                                            message:nil
//                                                           delegate:self
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil, nil];
//        [alertView show];
//    }
//}




#pragma mark - UITableView Delegates

// fieldtrip details table view should have tow sections.
// The first section for displaying fieldtrip details like
// localityName, date a little map for orientation etc.
// The second section should give a direct link to the specimens
// of the trip in one single view. It should give the abality to
// add specimens - currently implemented with a add-system button
// in the section header which triggers an segue to specimen controller
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // #0 Fundort ("Static")
    // #1 Specimens (dynamic)
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Fieldtrip-Section
    if (section == 0) {
        // #0 specimenIdentifier (FieldtripDetailsSpecimenIdentifierCell)
        // #1 localityName (FieldtripDetailsLocationNameCell) -> must be FieldtripDetailsLocalityNameCell?!
        // #2 location details summary (FieldtripDetailsLocationCell)
        // #3 placemark (FieldtripDetailsPlacemarkCell)
        // #4 date details summary (FieldtripDetailsDateCell)
        // #5 project (FieldtripDetailsProjectCell)
        // #6 ImageMap (FieldtripDetailsStaticMapViewCell)
        // #7 Images scroll view (FieldtripDetailsImagesScrollViewCell)

        return 7;
    }

    // Specimens-Section
    if (section == 1) {
        // count of specimens - use data core here
        return 0;
    }
    
    // default
    return 0;
}

// The great rock'n'roll swindle: code hard what dynamicaly is.
// Creating tableView cells with xib and/or dynamic storyboard cell prototypes
- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Fieldtrip section
    if (indexPath.section == 0) {


        // specimen identifier text field (exc. number)
        if (indexPath.row == 0) {
            
            FieldtripDetailsSpecimenIdentifierCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsSpecimenIdentifierCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }

        // spceimenNotes text view
        if (indexPath.row == 1) {
            
            FieldtripDetailsSpecimenNotesCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsSpecimenNotesCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }
        
//        // locationName text field
//        if (indexPath.row == 1) {
//            
//            FieldtripDetailsLocationNameCell *cell;
//            cell = [tableView dequeueReusableCellWithIdentifier:@"FieldtripDetailsLocationNameCell"
//                                                   forIndexPath:indexPath];
//            cell.fieldtrip = self.fieldtrip;
//
//            return cell;
//        }

        // location view
        if (indexPath.row == 2) {
            
            FieldtripDetailsLocationCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsLocationCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }
        
        // placemark view
        if (indexPath.row == 3) {
            
            FieldtripDetailsPlacemarkCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsPlacemarkCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }

        // date view
        if (indexPath.row == 4) {
            
            FieldtripDetailsDateCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsDateCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }

        // project view
        if (indexPath.row == 5) {
            
            FieldtripDetailsProjectCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsProjectCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.separatorInset = UIEdgeInsetsMake(0, 0, 0, cell.bounds.size.width);
            cell.fieldtrip = self.fieldtrip;
            
            return cell;
        }
        
        
        // Image Map
        if (indexPath.row == 6) {

            FieldtripDetailsMapViewCell *cell;
            cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsMapViewCell reuseIdentifier]
                                                   forIndexPath:indexPath];
            cell.fieldtrip = self.fieldtrip;
            return cell;
        }

        // Images scroll view
        if (indexPath.row == 7) {
//            FieldtripDetailsImagesScrollViewCell
        }
    }
    
    // Specimens section
    if (indexPath.section == 1) {
        // Use here a predefined cell with cellStyle "label"
    }
    
    
    UITableViewCell * dummyCell;
    dummyCell = [tableView dequeueReusableCellWithIdentifier:@"DummyCell"
                                                forIndexPath:indexPath];
    
    NSLog(@"class of used cell: %@", [dummyCell class]);
    
    dummyCell.textLabel.text = @"Dummy Cell";
    
    return dummyCell;
}




- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    // Locality-Section
//    if (section == 0) {
//        return @"Locality";
//    }
//
    // Specimens-Section
    if (section == 0) {
        return @"Specimen";
    }
    
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    // SpecimenNotes
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 97;
    }
    
    // Location
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 71;
    }
    // Placemark
    if (indexPath.section == 0 && indexPath.row == 3) {
        return 72;
    }
    // Date
    if (indexPath.section == 0 && indexPath.row == 4) {
        return 65;
    }
    // Project
    if (indexPath.section == 0 && indexPath.row == 5) {
        return 44;
    }

    // MapView
    if (indexPath.section == 0 && indexPath.row == 6) {
        return 140;
    }
    
    return 44;
}


- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if (section == 1) {
        CGRect frame = tableView.frame;
        
        UIButton *addSpecimenButton = [UIButton buttonWithType:UIButtonTypeContactAdd];

        addSpecimenButton.frame = CGRectMake(frame.size.width - 60, 0, 50, 30);

        [addSpecimenButton addTarget:self
                              action:@selector(addSpecimenToucheUpInside)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:addSpecimenButton];
    }
}

- (void)addSpecimenToucheUpInside
{
    [self performSegueWithIdentifier:@"addSpecimenSegue" sender:self];
}

//-  (UIView *)tableView:(UITableView *)tableView
//viewForHeaderInSection:(NSInteger)section
//{
//    if (section == -1) {
//        CGRect frame = tableView.frame;
//    
//        UIButton *addSpecimenButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
//        addSpecimenButton.frame = CGRectMake(frame.size.width-60, 10, 50, 30);
//        
////        UIButton *addButton = [[UIButton alloc] initWithFrame:CGRectMake(frame.size.width-60, 10, 50, 30)];
////        addButton.titleLabel.text = @"+";
//        addSpecimenButton.backgroundColor = [UIColor redColor];
//
//        
//        UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, 100, 30)];
//        title.text = @"SPECIMENS";
//    
//        UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
//        [headerView addSubview:title];
//        [headerView addSubview:addSpecimenButton];
//    
//        return headerView;
//    }
//    
//    return nil;
//}



//#pragma mark - UIAlertViewDelegate
//??? kommt noch von der Switch-Implementierung, die jetzt über den Toggle-Button wieder verwendet werden müsste...
//- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
//{
//    [self resetGpsStatusControl];
//}


#pragma mark - CLLocationManager


// initializes and configures the location manager
- (void)initLocationManager
{
    if (self.locationManager == nil) {
        self.locationUpdateTries = 5;
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        self.locationManager.delegate = self;
    }
    
}

- (void)destroyLocationManager
{
    self.locationManager = nil;
}


// Tells us that the authorization status for the application changed.
- (void)locationManager:(CLLocationManager *)manager
didChangeAuthorizationStatus:(CLAuthorizationStatus)status
{
    // implement when concurrency has a good flow for authorized
    
    NSLog(@"locationMager:didChangeAuthorizationStatus: status: %u", status);
    
    
}


- (void)locationManager:(CLLocationManager *)manager
       didFailWithError:(NSError *)error
{
    NSLog(@"LocationManger didFailWithError: %@", error);
    
    
    [self stopLocationTracking];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationFailure
                                                        object:self];
    
    UIAlertView *errorAlert;
    errorAlert = [[UIAlertView alloc] initWithTitle:NSLocalizedString(@"Error", nil)
                                            message:NSLocalizedString(@"Failed to get your Location", nil)
                                           delegate:self
                                  cancelButtonTitle:NSLocalizedString(@"OK", nil)
                                  otherButtonTitles:nil];
    [errorAlert show];
}


- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray *)locations
{
    NSLog(@"LocationManager: didUpdateLocations!");
    
    CLLocation * location = [locations lastObject];

    if (location == nil) {
        NSLog(@"Ignoring GPS failure (nil object).");
        
        return;
    }
    
    NSDate* eventDate = location.timestamp;
    NSTimeInterval howRecent = [eventDate timeIntervalSinceNow];
    
    if (fabs(howRecent) > 15.0) {
        // If the event is not recent, do nothing with it.
        NSLog(@"howRecent (must be >= 15.0): %f", fabs(howRecent));
        return ;
    }

    if (fabs(location.horizontalAccuracy) > 100) {

        NSLog(@"horizontalAccuracy (bust be <= 100): %f", fabs(location.horizontalAccuracy));
        return;
    }

    if (fabs(location.verticalAccuracy) > 100) {
        
        NSLog(@"verticalAccuracy (bust be < 100): %f", fabs(location.verticalAccuracy));
        return;
    }
    
    
    [self stopLocationTracking];
    
    [self.fieldtrip setLocation:location];
    NSLog(@"Notification LocationUpdate");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationUpdate
                                                        object:self];

    return;
    
    static CLLocation * cachedLocation = nil;
//
//    // grundsätzlich werden nur ca. 5 locationUpdates geholt, danach muss der User das manuell noch
//    // einmal antriggern.
    self.locationUpdateTries--;

    if (self.locationUpdateTries < 0) {
        [self stopLocationTracking];

        return ;
    }
    
    [self.fieldtrip setLocation:location];
    
//    [self drawLocationFromModel];

//    NSLog(@"Berechne Sonnenzeiten neu mit Location-Updates...");
    

    if (cachedLocation == nil) {
        
//        NSLog(@"Initialisiere Location-Cache.");

        // location für ein Folge-Update merken
        cachedLocation = location;
    } else {
        
        // Ich weiß, ich habe bereits eine letzt Position im Cache.
        // Wenn die horizontale Koordinate unverändert ist, benötige ich keinen weiteren Service-Call zu Reverse-Apis und zur Erstellung der Karte.
        if (cachedLocation.coordinate.longitude == location.coordinate.longitude &&
            cachedLocation.coordinate.latitude == location.coordinate.latitude &&
            cachedLocation.horizontalAccuracy == location.horizontalAccuracy) {

            self.locationUpdateTries = 0;

            NSLog(@"Location-Update liefert die selbe horizontale Position ist die im Cache ist. Keine Actionen darauf!");
//            NSLog(@"------------");

            return;
        }
    }

    cachedLocation = location;

//    [self calculateSunriseSunsetTwilight];
    
    NSLog(@"Notification LocationUpdate");
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationLocationUpdate
                                                        object:self];
    
    return ;
    
    
    
//    NSLog(@"starte reverse geocoding.");
//    [self reverseGeocodeLocation];
    
//    NSLog(@"starte neuzeichnen der Karte");
//    [self makeMapSnaphotFromModel];
    NSLog(@"neuzeichnen der statischen MapView müsste jetzt getriggert werden...");
    
    cachedLocation = location;
    
//    NSLog(@"Cached  Location: %@", cachedLocation);
//    NSLog(@"Updated Location: %@", location);
//    NSLog(@"Location Update and Action");

    
    // Reverse Geocoding (sollte asynchron gehen - keine Netzwerkprüfung hier!)

}



#pragma mark - Common Methods

// -> FieldtripDetailsSummaryCell
//- (void)reverseGeocodeLocation
//{
//    // ???
//    // 1) das komplette Geocoding von einem eigenen Object erledigen lassen
//    // 2) das Object arbeitet mit NSURLSession, weil die Requests aufgehoben werden müssen (queue)
//    // 3) der Request wird ggf. in einer eigenen Queue ausgeführt (weil sich die Requests anstauen, einer für alle)
//    
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder reverseGeocodeLocation:[self.fieldtrip location]
//                   completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (placemarks.count) {
//             NSLog(@"Locality reverse coded and found. %@", self);
//
//             CLPlacemark * placemark = [placemarks lastObject];
//             [self setModelWithPlacemark:placemark];
////             [self drawPlacemarkFromModel]; (wird bereits über notification aufgerufen)
//
//             // gibt ein gefundenes Placemark bekannt
//             // Bringt aber nix, weil die Aktualisierung jetzt im Main-Thread ausgeführt wird! :-(
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"Placemark found" object:self];
//         } else {
//             NSLog(@"Placemark not found. %@", self.fieldtrip);
//
////             [self clearPlacemark];
//             
//             // we will post a 'Not Found' notification to NotificationCenter if an address wasn't found
//             [[NSNotificationCenter defaultCenter] postNotificationName:@"Placemark not found" object:self];
//         }
//     }];
//}


#pragma mark - Data to Model


- (void)saveFormToModel
{
    // set model data
    // die Zuweisung von Input zu Model findet in FieldtripDetailsLocationName statt...
//    self.fieldtrip.localityName = self.localityNameTextField.text;
    
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    } else {

    }
}


// Standard Data for new Model
//- (void)setModelWithDefaults
//{
//    [self.fieldtrip defaultsWithLocalityName:NSLocalizedString(@"Mein Fundort", nil)];
//    return;
//}


// nach Fieldtrip auslagern
//- (void)setModelWithLocation:(CLLocation *)location
//{
//    self.fieldtrip.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
//    self.fieldtrip.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
//    self.fieldtrip.altitude = [NSNumber numberWithDouble:location.altitude];
//    self.fieldtrip.verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
//    self.fieldtrip.horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
//}


//- (void)setModelWithPlacemark:(CLPlacemark *)placemark
//{
//    // Address book Informations
//    //             NSDictionary *addressBookEntry = [placemark addressDictionary];
//             
//    // Administrative/Political Informations
//    self.fieldtrip.country = placemark.country;
//    self.fieldtrip.countryCodeISO = placemark.ISOcountryCode;
//    self.fieldtrip.administrativeArea = placemark.administrativeArea;
//    self.fieldtrip.subAdministrativeArea = placemark.subAdministrativeArea;
//    self.fieldtrip.administrativeLocality = placemark.locality;
//    self.fieldtrip.administrativeSubLocality = placemark.subLocality;
//    
//    // Geographic Informations
//    self.fieldtrip.ocean = placemark.ocean;
//    self.fieldtrip.inlandWater = placemark.inlandWater;
//             
//    // Landmark Informations
//    //             NSArray * areasOfInterest = [placemark areasOfInterest];
//    //             CLRegion * region = [placemark region];
//    //             NSString * regionIdentifier = [region identifier];
//}


//- (void)setModelWithSunriseSetTwilight:(EDSunriseSet *)sunriseset
//{
//    // set model data
//    self.fieldtrip.sunrise = sunriseset.sunrise;
//    self.fieldtrip.sunset = sunriseset.sunset;
//    self.fieldtrip.twilightBegin = sunriseset.civilTwilightStart;
//    self.fieldtrip.twilightEnd = sunriseset.civilTwilightEnd;
//}


// -> FieldtripDetailsMapViewCell
//- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image
//{
//	// begin a graphics context of sufficient size
//	UIGraphicsBeginImageContext(image.size);
//    
//	// draw original image into the context
//	[image drawAtPoint:CGPointZero];
//    
//	// get the context for CoreGraphics
//	CGContextRef ctx = UIGraphicsGetCurrentContext();
//    
//	// set stroking color and draw circle
//	[[UIColor blueColor] setStroke];
//    
//	// make circle rect 5 px from border
//    CGRect circleRect = CGRectMake(image.size.width / 2 - 10,
//                                   image.size.height / 2 - 10,
//                                   20,
//                                   20);
//	
//	circleRect = CGRectInset(circleRect, 5, 5);
//    
//    // Für Punkt-Koordinaten hätte ich gerne einen Kreis,
//    // für MGRS ein Quadrat, dass die genauigkeit des referenzierten Grids wiederspiegelt!
//	// draw circle
//	CGContextStrokeEllipseInRect(ctx, circleRect);
////    CGContextStrokeRect(ctx, circleRect);
//    
//	// make image out of bitmap context
//	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//	// free the context
//	UIGraphicsEndImageContext();
//    
//	return retImage;
//}

// -> FieldtripDetailsMapViewCell
//- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView
//                       fullyRendered:(BOOL)fullyRendered
//{
//    if (fullyRendered) {
//        NSLog(@"MapView ist fertig gerendert. Jetzt SnapShot erstellen!");
//    }
//}


// -> FieldtripDetailsMapViewCell
//- (void)makeMapSnaphotFromModel
//{
//    NSLog(@"makeMapSnapshot...");
//
//    MKCoordinateRegion region;
//    
//    region.center.latitude = [self.fieldtrip.latitude doubleValue]; // location.coordinate.latitude;
//    region.center.longitude = [self.fieldtrip.longitude doubleValue]; //  location.coordinate.longitude;
//    
//    region.span.longitudeDelta = 0.01; // ca. 111km / 0.001° => 100m
//    region.span.latitudeDelta = 0.01;  // ca. 111km / 0.001° => 100m
//
//    [self initMapView];
//    [self.mapView setRegion:region animated:NO];
//    
//    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
//
//    options.region = region;
//    options.scale = [UIScreen mainScreen].scale;
//    
//    options.size = self.mapView.frame.size;
//    
//    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
//    
//    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
//
//        UIImage *image = snapshot.image;
//        
//        UIImage *imageWithCircle = [self imageByDrawingCircleOnImage:image];
//
//        // show the map with the pure circle in it
//        self.staticMapImage.image = imageWithCircle;
//
//        // convert image to PNG file format
//        NSData *pngImageData = UIImagePNGRepresentation(imageWithCircle);
//
//        // create a filename based on sha1
//        NSString *sha1Hash = [Crypto sha1WithBinary:pngImageData];
//        NSString *filename = [NSString stringWithFormat:@"%@.png", sha1Hash];
//
//        // Create Pictures in users Documents directory if it doesn't exist
//        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
//        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Maps"];
//        NSError *ioError;
//
//        // Does directory already exist? No, then create it.
//        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
//            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
//                                           withIntermediateDirectories:NO
//                                                            attributes:nil
//                                                                 error:&ioError]) {
//                NSLog(@"Create directory error: %@", error);
//            }
//        }
//        
//        // create the full file path
//        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
//        
//        NSLog(@"Full path to store picture: %@", filePath);
//        
//        // store the png
//        if ([pngImageData writeToFile:filePath
//                           atomically:YES] == YES) {
//            self.fieldtrip.mapImageFilename = filename;
//            
//        } else {
//            NSLog(@"Failed to write map file to disc.");
//            // alert the error
//            self.fieldtrip.mapImageFilename = nil;
//        }
//    }];
//}



#pragma mark - Model to UI

// -> FieldtripDetailsSummaryCell
//- (void)drawLocalityFromModel
//{
//    self.localityNameTextField.text = self.fieldtrip.localityName;
    // ...
//}

// -> FieldtripDetailsMapViewCell
//- (void)drawMapFromModel
//{
//	NSString *imageMapPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/Maps/%@", self.fieldtrip.mapImageFilename]];
//    
//    NSLog(@"String to load: %@", imageMapPath);
//
//	NSData *imageMapData = [NSData dataWithContentsOfFile:imageMapPath];
//
//	if (imageMapData == nil) {
//        NSLog(@"Fild couldn't be loaded. Must be regenerate from model data...");
//        [self makeMapSnaphotFromModel];
//    } else {
//        self.staticMapImage.image = [UIImage imageWithData:imageMapData];
//    }
//}


//- (void)clearPlacemark
//{
//    [self.countryAndAdministrativeAreaLabel setText:@""];
//    [self.subAdministrativeAreaLabel setText:@""];
//    [self.administrativeLocalityLabel setText:@""];
//    [self.administrativeSubLocalityLabel setText:@""];
//}


// -> FieldtripDetailsSummaryCell
//- (void)drawPlacemarkFromModel
//{
//    [self clearPlacemark];
//
//    self.countryAndAdministrativeAreaLabel.text = [self.fieldtrip placemark];
//}

// -> FieldtripDetailsSummaryCell
// Akualisiert alle Positionsfelder (Koordinaten, Höhe und Fehler)
//- (void)drawLocationFromModel
//{
//    CLLocation * location = [self.fieldtrip location];
//    
//    // Formatieren der Location Properties nach Geodetic decimal:
//    FwdCoordinateFormat withCoordinateFormat = kFwdCoordinateFormatGeodeticDecimal;
//    FwdMapDatum withMapDatum = kFwdMapDatumWGS1984;
//    FwdUnitOfLength withUnitOfLength = kFwdUnitOfLengthMeter;
//    
//    FwdConversion *conversion = [FwdConversion new];
//    
//    switch (withCoordinateFormat) {
//        case kFwdCoordinateFormatGeodeticDecimal:
//        case kFwdCoordinateFormatGeodeticDegreesShort:
//        case kFwdCoordinateFormatGeodeticDegreesLong:
//            self.coordinatesLabel.text = [conversion locationToCoordinates:location
//                                                                    format:withCoordinateFormat
//                                                                  mapDatum:withMapDatum];
//            break;
//            
//        case kFwdCoordinateFormatMGRSLong:
//        case kFwdCoordinateFormatMGRSShort:
//        case kFwdCoordinateFormatUTMLong:
//        case kFwdCoordinateFormatUTMShort:
//            NSLog(@"just unsupported coodinate format in use!");
//            break;
//    }
//    
//    self.altitudeLabel.text = [conversion locationToAltitude:location
//                                            withUnitOfLength:withUnitOfLength];
//    
//    self.horizontalAccuracyLabel.text = [conversion locationToHorizontalAccuracy:location
//                                                                withUnitOfLength:withUnitOfLength];
//    
//    self.verticalAccuracyLabel.text = [conversion locationToVerticalAccuracy:location
//                                                            withUnitOfLength:withUnitOfLength];
//}


/*!
 *  Updates current date label if changes would be visible to the user. Fixed short style format is used dependend of the device locale.
 *
 *  @param date Date to use for drawing the current date label
 *
 *  @since 1.0
 */
//- (void)drawBeginDateFromModel
//{
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle: NSDateFormatterShortStyle];
//    
//    [dateFormatter setTimeStyle: NSDateFormatterMediumStyle];
//    
//    NSString * formatedDate = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
//
//    if (![self.beginDateLabel.text isEqualToString:formatedDate]) {
//        self.beginDateLabel.text = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
//    }
//}


//- (void)drawTimeZoneFromModel
//{
//    self.timeZoneLabel.text = [self.fieldtrip.timeZone name];
//}


// -> FieldtripDetailsSummaryCell
//- (void)drawDayNightStatusFromModel
//{
//    self.dayNightStatusImageView.hidden = NO;
//    self.dayNightStatusImageView.highlighted = [self isDayLightWidthDate:self.fieldtrip.beginDate
//                                                             sunriseDate:self.fieldtrip.sunrise
//                                                              sunsetDate:self.fieldtrip.sunset];
//}


// für komische Switch-Logik.
//- (void)resetGpsStatusControl
//{
//    self.locationUpdateButton.selected = NO;
//}


- (void)startLocationTracking
{
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
  
    // for iOS 8+
    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    
    [self.locationManager startUpdatingLocation];
//    }
    
    
    
//    if ([LocationService isEnabled] && [LocationService isAuthorized]) {
        //
        //
        ////        [self.locationUpdateButton setEnabled:YES];
        //        [self startLocationTracking];
        
//    } else {
    
        //        [self.locationUpdateButton setEnabled:NO];
//    }
    
//    self.locationUpdateButton.selected = YES;

//    [self.locationManager startUpdatingLocation];
}


- (void)stopLocationTracking
{
    [self.locationManager stopUpdatingLocation];

//    self.locationUpdateButton.selected = NO;
    
//    [self.refreshControl endRefreshing];
    [self destroyLocationManager];
}


#pragma mark - Calculation - 


/**
 * Calculates Sunrise, Sunset and Twilight for a given time zone and coordinates
 * and stores it in the model.
 */
- (void)calculateSunriseSunsetTwilight
{
    // Daten aus dem Model holen:
    NSDate * date = self.fieldtrip.beginDate;
    NSTimeZone * timeZone = self.fieldtrip.timeZone;
    float lat = [self.fieldtrip.latitude doubleValue];
    float lon = [self.fieldtrip.longitude doubleValue];
    
    // initializes the SunriseSet object with mett:
    EDSunriseSet *sunriseset  = [EDSunriseSet sunrisesetWithTimezone:timeZone
                                                            latitude:lat
                                                           longitude:lon];
    // calculate the sun
    [sunriseset calculate:date];
    
//    [self setModelWithSunriseSetTwilight:sunriseset];
    
    // Write calculated data of sunrise, sunset and twilight back to model
    self.fieldtrip.sunrise = sunriseset.sunrise;
    self.fieldtrip.sunset = sunriseset.sunset;
    self.fieldtrip.twilightBegin = sunriseset.civilTwilightStart;
    self.fieldtrip.twilightEnd = sunriseset.civilTwilightEnd;
}


#pragma mark - Helper -


//- (BOOL)isDayLightWidthDate:(NSDate *)date
//                sunriseDate:(NSDate *)sunrise
//                 sunsetDate:(NSDate *)sunset
//{
//    // compare sunrise and sunset time with current time
//    if ([date compare:sunrise] == NSOrderedDescending &&
//        [date compare:sunset] == NSOrderedAscending) {
//        // It is light outside (day)
//        return YES;
//    } else {
//        // It is dark outside (night)
//        return NO;
//    }
//}

// -> FieldtripDetailsMapView
//- (void)initMapView
//{
//    // create an hidden mapView object
//    self.mapView = [[MKMapView alloc] initWithFrame:self.staticMapImage.frame];
//    self.mapView.hidden = YES;
//    // Configure the small mapView object
//    // There are three options for Apple Maps:
//    // - MKMapTypeStandard (default)
//    // - MKMapTypeSatellite
//    // - MKMapTypeHybrid
//    self.mapView.mapType = MKMapTypeStandard;
//    self.mapView.zoomEnabled = NO;
//    self.mapView.scrollEnabled = NO;
//    self.mapView.contentScaleFactor = 2.0;
//    self.mapView.delegate = self;
//
//    [self.view addSubview:self.mapView];
//}


//- (IBAction)locationUpdateButtonTouched:(UIButton *)sender
//{
//    NSLog(@"........ Button touched");
//    
//    if ([self.locationUpdateButton isEnabled] == NO) {
//        
//        NSLog(@"locationUpdateButton is not enabled. No operation.");
//        return ;
//    }
//
//    if ([self.locationUpdateButton isSelected] == YES) {
//        NSLog(@"locationUpdateButton is selected and will be deselected now. Location-Updates should be canceled.");
//        [self stopLocationTracking];
//    } else {
//        NSLog(@"locationUpdateButton is NOT selected and will be selected now. Location-Updates should be started.");
//        [self startLocationTracking];
//    }
//}
@end
