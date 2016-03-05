//
//  Samples Controller
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
#import "AppDelegate.h"
#import "SamplesController.h"
#import "FieldtripDetailsViewController.h"
#import "FieldtripTableViewCell.h"
#import "MGSwipeTableCell.h"
#import "Fieldtrip.h"
#import "Placemark.h"

@import UIKit;
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

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"createFieldtripSegue"]) {
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
    }
    
    if ([[segue identifier] isEqualToString:@"openFieldtripSegue"]) {
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = [(FieldtripTableViewCell *)sender fieldtrip];
    }
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
    
    static NSString *cellId = @"FieldtripCell";

    FieldtripTableViewCell *cell;
    
    cell = (FieldtripTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[FieldtripTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:cellId];
    }
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.fieldtrip = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        cell.fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }

    //configure right buttons
    cell.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" // Delete, index = 1
                                                    icon:[UIImage imageNamed:@"trash"]
                                         backgroundColor:[UIColor redColor]
                                                 padding:28],
                          [MGSwipeButton buttonWithTitle:@""  // Mark, index = 2
                                                    icon:[UIImage imageNamed:@"star"]
                                         backgroundColor:[UIColor orangeColor]
                                                 padding:28],
                          [MGSwipeButton buttonWithTitle:@""  // More, index = 3
                                                    icon:[UIImage imageNamed:@"mail"]
                                         backgroundColor:[UIColor lightGrayColor]
                                                 padding:28]];
    cell.rightSwipeSettings.transition = MGSwipeTransitionBorder;
    cell.delegate = self;
    
    return cell;
}

- (BOOL)swipeTableCell:(FieldtripTableViewCell*)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion {
    
//    NSLog(@"Delegate: button tapped, %@ position, index %d, from Expansion: %@",
//          direction == MGSwipeDirectionLeftToRight ? @"left" : @"right", (int)index, fromExpansion ? @"YES" : @"NO");
    
    
//    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
//        // Delete
//        NSIndexPath * path = [self.tableView indexPathForCell:cell];
////
//////        [tests removeObjectAtIndex:path.row];
//        [self.tableView deleteRowsAtIndexPaths:@[path]
//                              withRowAnimation:UITableViewRowAnimationLeft];
//
//        return NO; //Don't autohide to improve delete expansion animation
//    }

    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
        
        [self toggleMarkSample:cell];

        //
        // Mark
        //
//        NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
//        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
//
//        Fieldtrip *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
//
//        // toogle isMarked
//        fieldtrip.isMarked = ([fieldtrip.isMarked isEqual:@YES]) ? @NO : @YES;
//        
//        NSError *error = nil;
//        
//        if (![context save:&error]) {
//            NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
//            
//            abort();
//        }
//        
//        NSLog(@"isMarked: %@", fieldtrip.isMarked);
    }

    if (direction == MGSwipeDirectionRightToLeft && index == 2) {
        // Send an email with sample data
        [self sendMail:cell.fieldtrip];
    }
    
    return YES;
}

- (void)toggleMarkSample:(UITableViewCell *)cell {
    
    // Mark sample
    NSIndexPath * indexPath = [self.tableView indexPathForCell:cell];
    NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
    
    Fieldtrip *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    // toogle isMarked flag
    fieldtrip.isMarked = ([fieldtrip.isMarked isEqual:@YES]) ? @NO : @YES;
    
    NSError *error = nil;
    
    if (![context save:&error]) {
        NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
        
        abort();
    }
    
    NSLog(@"isMarked: %@", fieldtrip.isMarked);
}

- (void)actionSheet:(UIActionSheet *)actionSheet
clickedButtonAtIndex:(NSInteger)buttonIndex {

    if (actionSheet.tag == kSampleActionSheetMore) {
        NSLog(@"The Normal action sheet. %ld", (long)buttonIndex);
        
        // Mail
//        if (buttonIndex == 0) {
//            [self sendMail];
//        }

        // mark
        if (buttonIndex == 1) {

            NSLog(@"mark...");
        }
        
    }
    else if (actionSheet.tag == 200){
        NSLog(@"The Delete confirmation action sheet.");
    }
    else{
        NSLog(@"The Color selection action sheet.");
    }
    
//    NSLog(@"Index = %d - Title = %@", buttonIndex, [actionSheet buttonTitleAtIndex:buttonIndex]);
}



// Support delete (editing) of the table view.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // user deletes a row inline
    if (editingStyle == UITableViewCellEditingStyleDelete) {

        NSLog(@"DELETING...");
        
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];

        if (tableView == self.searchDisplayController.searchResultsTableView) {
//            NSLog(@"Delete im SearchTableView");
//            NSLog(@"im Context gelöscht - aber nicht in der Search Display");
//
//            [tableView deleteRowsAtIndexPaths:@[indexPath]
//                             withRowAnimation:UITableViewRowAnimationFade];
//
        } else {
//            NSLog(@"Delete im TableView");
        }

        
        NSError *error = nil;

        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);

            abort();
        }
    }
}

- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath {

    return 70;
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

    if (self.showOnlyMarkedAsFavorits) {
        NSPredicate *predicate;
        predicate = [NSPredicate predicateWithFormat:@"isMarked=YES"];
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

#pragma mark - Mailer - 

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


@end
