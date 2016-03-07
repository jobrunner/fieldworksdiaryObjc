//
//  ProjectTableViewController.m
//  Fieldworksdiary
//

#import "AppDelegate.h"
#import "FieldtripsController.h"
#import "FieldtripCell.h"
#import "ProjectDetailsViewController.h"
#import "SamplesController.h"
#import "ActiveFieldtrip.h"
#import "Project.h"

@interface FieldtripsController ()

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation FieldtripsController

#pragma mark - UIViewControllerDelegate

- (void)viewDidAppear:(BOOL)animated {

    [self.tableView reloadData];
}

- (void)viewDidLoad {
    
    [super viewDidLoad];

    // managed object context aus Pseudo Singleton holen:
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    managedObjectContext = appDelegate.managedObjectContext;
    

    // Uncomment the following line to preserve selection between presentations.
//    self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    //    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    
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
    
//    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCurrent, btnSearch, nil]];
}

//- (void)searchNavigationItemTouched {
//    
//    [self.searchDisplayController.searchBar becomeFirstResponder];
//}

#pragma mark - UITableView Delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
	return [[self.fetchedResultsController sections] count];
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

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *cellId = @"FieldtripCell";
    
    FieldtripCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];

    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:@"FieldtripCell"
                                              bundle:nil]
        forCellReuseIdentifier:cellId];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(FieldtripCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {

    Project *fieldtrip;
    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        fieldtrip = [self.searchResults objectAtIndex:indexPath.row];
    }
    else {
        fieldtrip = [fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    [cell configureWithModel:fieldtrip
                 atIndexPath:indexPath
                withDelegate:self
                selectorOnly:(_fieldtripUsage == kFieldtripUsagePicker)];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    if (_fieldtripUsage == kFieldtripUsagePicker) {

        Project *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
        
        if ([self.delegate respondsToSelector:@selector(fieldtripPicker:didSelectFieldtrip:)]) {
            [self.delegate fieldtripPicker:self didSelectFieldtrip:fieldtrip];
        }
        
        [self.navigationController popViewControllerAnimated:YES];
    }
    else if (_fieldtripUsage == kFieldtripUsageSampleFilter) {
        // show samples within selected fieldtrip

        FieldtripCell *cell = [tableView cellForRowAtIndexPath:indexPath];

        [self performSegueWithIdentifier:@"openFilteredSamplesSegue"
                                  sender:cell];
    }
    else {
        FieldtripCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
        [self performSegueWithIdentifier:@"editFieldtripSegue"
                                  sender:cell];
    }
}

// Dosn't support native editing of table view cells.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

// Dosn't support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {

    return NO;
}

- (void)deleteFieldtrip:(FieldtripCell *)cell {
    
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

- (void)toggleActiveFieldtrip:(FieldtripCell *)cell {

    Project *fieldtrip = [fetchedResultsController objectAtIndexPath:cell.indexPath];
    
    if ([ActiveFieldtrip isActive:fieldtrip]) {
        [ActiveFieldtrip setActiveFieldtrip:nil];
    }
    else {
        
        [ActiveFieldtrip setActiveFieldtrip:fieldtrip];
    }
    [self.tableView reloadData];
}

- (BOOL)swipeTableCell:(FieldtripCell *)cell
   tappedButtonAtIndex:(NSInteger)index
             direction:(MGSwipeDirection)direction
         fromExpansion:(BOOL)fromExpansion {
    
    if (direction == MGSwipeDirectionRightToLeft && index == 0) {
        
        [self deleteFieldtrip:cell];
        
        return NO;
    }
    
    if (direction == MGSwipeDirectionRightToLeft && index == 1) {
        
        [self toggleActiveFieldtrip:cell];
    }
    
    return YES;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
//
//    return 28;
//}

// configure cell hight for search bar and search display controller
//-    (CGFloat)tableView:(UITableView *)tableView
//heightForRowAtIndexPath:(NSIndexPath *)indexPath {
//
//
//    return 70;
//}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (fetchedResultsController != nil) {

        return fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
                                              inManagedObjectContext:managedObjectContext];
    
    [request setEntity:entity];

    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *resultsController;
    
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                            managedObjectContext:managedObjectContext
                                                              sectionNameKeyPath:nil
                                                                       cacheName:nil];
    
    resultsController.delegate = self;
    
    fetchedResultsController = resultsController;
    
	NSError *error = nil;
    
	if (![fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
	    NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
	    abort();
	}
    
    return fetchedResultsController;
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
            break;
    }
}

- (void)controller:(NSFetchedResultsController *)controller
   didChangeObject:(id)object
       atIndexPath:(NSIndexPath *)indexPath
     forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    
    UITableView *tableView = self.tableView;
    
    switch(type) {
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:@[newIndexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
            break;
            
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:@[indexPath]
                             withRowAnimation:UITableViewRowAnimationFade];
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

/*
 // Implementing the above methods to update the table view in response to individual changes may have performance implications if a large number of changes are made simultaneously. If this proves to be an issue, you can instead just implement controllerDidChangeContent: which notifies the delegate that all section and object changes have been processed.
 
 - (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
 {
 // In the simplest, most efficient, case, reload the table view.
 [self.tableView reloadData];
 }
 */

#pragma mark - UISearchDisplayDelegate

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString {
    
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}

- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption {
    
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    
    return YES;
}

- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller {
    
    // hide the search bar until user scolls down
    CGPoint searchBarOffset = CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height);
    
    [self.tableView setContentOffset:searchBarOffset
                            animated:YES];
}

#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope {
    
    [self.searchResults removeAllObjects];
    
    NSPredicate *predicate;

    if ([scope isEqualToString:@"Title"]) {
        predicate = [NSPredicate predicateWithFormat:@"name BEGINSWITH[c] %@", searchText];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd] %@ || notes CONTAINS[cd] %@", searchText, searchText, searchText];
    }
    NSLog(@"predicate: %@", predicate);
    
    NSArray *fieldtrips = [self.fetchedResultsController fetchedObjects];
    
    NSLog(@"fieldtrips: %@", fieldtrips);
    NSLog(@"search results: %@", [fieldtrips filteredArrayUsingPredicate:predicate]);
    
    [self.searchResults addObjectsFromArray:[fieldtrips filteredArrayUsingPredicate:predicate]];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"createFieldtripSegue"]) {
        ProjectDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
    }
    
    if ([[segue identifier] isEqualToString:@"editFieldtripSegue"]) {
        ProjectDetailsViewController * controller = segue.destinationViewController;
        FieldtripCell *cell = (FieldtripCell *)sender;
        controller.fieldtrip = [fetchedResultsController objectAtIndexPath:cell.indexPath];
    }
    
    if ([[segue identifier] isEqualToString:@"openFilteredSamplesSegue"]) {
        SamplesController *controller = segue.destinationViewController;
        FieldtripCell *cell = (FieldtripCell *)sender;
        controller.filterByFieldtrip = [fetchedResultsController objectAtIndexPath:cell.indexPath];
    }
}

@end
