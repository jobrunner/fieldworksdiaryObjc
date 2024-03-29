//
//  Samples Controller
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
#import "AppDelegate.h"
#import "SamplesController.h"
#import "SampleDetailsController.h"
#import "SampleCell.h"
#import "Fieldtrip.h"
#import "Placemark.h"

@import MessageUI;

@interface SamplesController ()

@property (nonatomic, strong) NSFetchedResultsController *fetchedResultsController;
@property (nonatomic, strong) NSManagedObjectContext *managedObjectContext;
@property (nonatomic, retain) NSMutableArray *searchResults;
@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation SamplesController

#pragma mark - UIViewController

- (void)viewDidLoad {

    [super viewDidLoad];

    self.managedObjectContext = ApplicationDelegate.managedObjectContext;
    
    self.searchResults = [NSMutableArray arrayWithCapacity:[[self.fetchedResultsController fetchedObjects] count]];
    
    // hide the search bar until user scolls down
    CGPoint searchBarOffset = CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height);
    
    [self.tableView setContentOffset:searchBarOffset
                            animated:YES];
    
    // add an additional search bar item to the right
//    UIBarButtonItem *btnCurrent = self.navigationItem.rightBarButtonItem;
//    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
//                                                                               target:self
//                                                                               action:@selector(searchNavigationItemTouched)];
//    
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCurrent, btnSearch, nil]];
}

- (void)searchNavigationItemTouched {
    
    [self.searchDisplayController.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [[self.fetchedResultsController sections] count];
}

- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section {
    
    id <NSFetchedResultsSectionInfo> theSection;
	theSection = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [self sectionTitleFromSectionName:[theSection name]];
}

- (NSString *)sectionTitleFromSectionName:(NSString *)sectionName {

    // 20140429
    NSInteger numericSection = [sectionName integerValue];
    NSInteger year = numericSection / 10000;
  	NSInteger month = (numericSection - year * 10000) / 100;
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
	NSString *sectionTitle = [[self sectionHeaderDateFormatter] stringFromDate:date];
    
    return sectionTitle;
}

- (NSDateFormatter *)sectionHeaderDateFormatter {

    static NSDateFormatter *formatter = nil;
    
    if (!formatter) {
        formatter = [[NSDateFormatter alloc] init];
        [formatter setCalendar:[NSCalendar currentCalendar]];
        
        NSString *formatTemplate = [NSDateFormatter dateFormatFromTemplate:@"MMMM YYYY"
                                                                   options:0
                                                                    locale:[NSLocale currentLocale]];
        [formatter setDateFormat:formatTemplate];
    }

    return formatter;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    // switch between search table view managened by the search bar and search display view ...
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        return [self.searchResults count];
    }
    else {

        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section {

    return 23;
}

- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)sectionIndex {

    id <NSFetchedResultsSectionInfo> section;
    section = [[self.fetchedResultsController sections] objectAtIndex:sectionIndex];
    NSString * sectionTitle;
    sectionTitle = [self sectionTitleFromSectionName:[section name]];
    
    UIFont *font = [UIFont boldSystemFontOfSize:13.0];
    UIColor *tintColor = [UIColor colorWithRed:(4.0/255.0)
                                         green:(102.0/255.0)
                                          blue:(0.0/255.0)
                                         alpha:1.0];

    UIView *sepView = [[UIView alloc] initWithFrame:CGRectMake(0, 22, tableView.frame.size.width, 1.0)];
    sepView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    sepView.layer.borderWidth = 1.0f;
    
    UILabel *sectionTitleLabel;
    sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 0, tableView.frame.size.width, 22)];
    sectionTitleLabel.font = font;
    sectionTitleLabel.text = sectionTitle;
    sectionTitleLabel.textColor = tintColor;
    sectionTitleLabel.textAlignment = NSTextAlignmentCenter;

    UIColor * bgColor = [UIColor  whiteColor];
    UIView *sectionView;
    sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 23)];
    [sectionView addSubview:sepView];
    [sectionView addSubview:sectionTitleLabel];
    [sectionView setBackgroundColor:bgColor];
    
    return sectionView;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"SampleCell";
    
    SampleCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellId
                                              bundle:nil]
        forCellReuseIdentifier:cellId];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(SampleCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    Fieldtrip *sample;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        sample = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        sample = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [cell configureWithModel:sample
                 atIndexPath:indexPath
                withDelegate:self];
}


- (void)deleteSample:(SampleCell *)cell {
    
    void (^action)() = ^{

        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
        }
    };
    
    UIAlertController *actionSheet;
    actionSheet = [UIAlertController alertControllerWithTitle:nil
                                                      message:nil
                                               preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *deleteAction;
    deleteAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Delete Entry", @"Delete Entry")
                                            style:UIAlertActionStyleDestructive
                                          handler:action];
    UIAlertAction *cancelAction;
    cancelAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Cancel", @"Cancel")
                                            style:UIAlertActionStyleDefault
                                          handler:nil];
    [actionSheet addAction:deleteAction];
    [actionSheet addAction:cancelAction];

    [self presentViewController:actionSheet
                       animated:YES
                     completion:nil];
}

- (BOOL)swipeTableCell:(SampleCell *)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion {
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {

        [self deleteSample:cell];
        
        return NO;
    }

    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
        
        [self toggleMarkSample:cell];
    }

    if (direction == MGSwipeDirectionRightToLeft && index == 2) {
        // Send an email with sample data
        [self sendMail:[self.fetchedResultsController objectAtIndexPath:cell.indexPath]];
    }
    
    return YES;
}

- (void)toggleMarkSample:(UITableViewCell *)cell {
    
    // Mark sample
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Fieldtrip *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // toogle isMarked flag
    fieldtrip.isMarked = ([fieldtrip.isMarked boolValue]) ? @NO : @YES;
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
    }
}

// Dosn't support default delete operation of table view cells.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

// Dosn't support sorting operation of table view cells.
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    SampleCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
    [self performSegueWithIdentifier:@"openSampleSegue"
                              sender:cell];
}

#pragma mark - UISearchDisplayDelegate

-  (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    // hide the search bar until user did end search
    CGPoint searchBarOffset = CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height);
    
    [self.tableView setContentOffset:searchBarOffset
                            animated:YES];
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {

    [self.searchResults removeAllObjects];

    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localityName contains[cd] %@ || country contains[cd] %@ || countryCodeISO LIKE %@ || localityDescription contains[cd] %@ || administrativeArea contains[cd] %@ || administrativeLocality contains[cd] %@ || administrativeSubLocality contains[cd] %@ || subAdministrativeArea contains[cd] %@ || localityIdentifier contains[cd] %@ || specimenIdentifier contains[cd] %@", searchText, searchText, searchText, searchText, searchText, searchText, searchText, searchText, searchText, searchText];

    NSArray * fieldtrips = [self.fetchedResultsController fetchedObjects];
        
    [self.searchResults addObjectsFromArray:[fieldtrips filteredArrayUsingPredicate:predicate]];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fieldtrip"
                                              inManagedObjectContext:self.managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    [request setEntity:entity];
    
    // Set the batch size to a suitable number.
    [request setFetchBatchSize:20];

    if (_sampleUsage == kSampleUsageFilteredByMarked) {
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"isMarked = YES"];
        [request setPredicate:predicate];
    }
    else if (_sampleUsage == kSampleUsageFilteredByFieldtrip) {
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"project == %@", _filterByFieldtrip];
        [request setPredicate:predicate];
    }
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    [request setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *resultsController;
    
    // ???
    // Achtung: Ich habe hier cacheName auf nil gesetzt. Nicht gut.
    // - Der cache wird gelöscht mit:
    // [NSFetchedResultsController deleteCacheWithName:@"FieldtripMasterTable"]
    
//    [NSFetchedResultsController deleteCacheWithName:@"FieldtripMasterTable"];
    
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                            managedObjectContext:self.managedObjectContext
                                                              sectionNameKeyPath:@"sectionIdentifier"
                                                                       cacheName:nil];
    //]@"FieldtripMasterTable"];
    
    resultsController.delegate = self;
    
    self.fetchedResultsController = resultsController;
    
	NSError *error = nil;
    
	if (![self.fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);

        abort();
	}
    
    return _fetchedResultsController;
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {

    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type {
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [self.tableView insertSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [self.tableView deleteSections:[NSIndexSet indexSetWithIndex:sectionIndex]
                          withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
        case NSFetchedResultsChangeUpdate:
            // not supported
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;    

    if (tableView == self.searchDisplayController.searchResultsTableView) {
        // NSLog(@"tableView ist zufällig gerade die searchResultsTableView");
    }
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [self.searchDisplayController.searchResultsTableView reloadData];
            
            break;
            
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {

    [self.tableView endUpdates];
}

#pragma mark - Mailer

- (void)mailComposeController:(MFMailComposeViewController *)controller
          didFinishWithResult:(MFMailComposeResult)result
                        error:(NSError *)error {
    
    [self dismissViewControllerAnimated:YES
                             completion:nil];
}

- (void)sendMail:(Fieldtrip *)fieldtrip {

    NSMutableString *emailBody = [[NSMutableString alloc] init];
    
    [emailBody appendFormat:@"specimenIdentifier:%@\n", fieldtrip.specimenIdentifier];
    [emailBody appendFormat:@"localityIdentifier:%@\n", fieldtrip.localityIdentifier];
    [emailBody appendFormat:@"localityName:%@\n", fieldtrip.localityName];
    [emailBody appendFormat:@"latitude:%@\n", fieldtrip.latitude];
    [emailBody appendFormat:@"longitude:%@\n", fieldtrip.longitude];
    [emailBody appendFormat:@"horizontalAccuracy:%@\n", fieldtrip.horizontalAccuracy];
    [emailBody appendFormat:@"longitude:%@\n", fieldtrip.altitude];
    [emailBody appendFormat:@"verticalAccuracy:%@\n", fieldtrip.verticalAccuracy];
    [emailBody appendFormat:@"placemark:%@\n", fieldtrip.placemark];
    [emailBody appendFormat:@"beginDate:%@\n", fieldtrip.beginDate];
    [emailBody appendFormat:@"endDate:%@\n", fieldtrip.endDate];
    [emailBody appendFormat:@"isFullTime:%@\n", fieldtrip.isFullTime];
    [emailBody appendFormat:@"timeZone:%@\n", fieldtrip.timeZone];
    [emailBody appendFormat:@"specimenNotes:%@\n", fieldtrip.specimenNotes];

    NSMutableString *emailSubject = [[NSMutableString alloc] init];
    [emailSubject appendFormat:@"%@", fieldtrip.specimenIdentifier];
    
    NSString *recipient = [NSString stringWithFormat:@"%@", @"jo@egolab.de"];
    NSArray *emailRecipients = @[recipient];
    
    MFMailComposeViewController *mailComposerController = [[MFMailComposeViewController alloc]init];

    if ([MFMailComposeViewController canSendMail]) {
        mailComposerController.mailComposeDelegate = self;
        
        [mailComposerController setToRecipients:emailRecipients];
        [mailComposerController setSubject:emailSubject];
        [mailComposerController setMessageBody:emailBody
                                        isHTML:NO];
        [self presentViewController:mailComposerController
                           animated:YES
                         completion:nil];
            
//            [mailComposerController addAttachmentData:[sampleData dataUsingEncoding:NSUTF8StringEncoding]
//                                             mimeType:@"application/json"
//                                             fileName:exportfile];
    }
    else {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Mail error"
                                                            message:@"Device has not been set up to send mail"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil];
            [alertView show];
    }
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"createSampleSegue"]) {
        
        SampleDetailsController * controller = segue.destinationViewController;
        controller.sample = nil;
    }
    
    if ([[segue identifier] isEqualToString:@"openSampleSegue"]) {

        SampleDetailsController * controller = segue.destinationViewController;

        SampleCell *cell = sender;
        Fieldtrip *sample = [self.fetchedResultsController objectAtIndexPath:cell.indexPath];
        
        controller.sample = sample;
    }
}

@end
