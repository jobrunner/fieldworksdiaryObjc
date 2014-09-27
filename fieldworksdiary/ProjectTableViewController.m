//
//  ProjectTableViewController.m
//  Fieldworksdiary
//

#import "ProjectTableViewController.h"

@interface ProjectTableViewController ()

@property (strong, nonatomic) NSMutableArray *searchResults;
@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;

@end

@implementation ProjectTableViewController


#pragma mark - UIViewControllerDelegate


- (void)viewDidLoad
{
    [super viewDidLoad];

    // managed object context aus Pseudo Singleton holen:
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    NSLog(@"Managed Object Context über AppDeligate zugewiesen: %@", self.managedObjectContext);
    
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
    UIBarButtonItem *btnCurrent = self.navigationItem.rightBarButtonItem;
    UIBarButtonItem *btnSearch = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemSearch
                                                                               target:self
                                                                               action:@selector(searchNavigationItemTouched)];
    
    [self.navigationItem setRightBarButtonItems:[NSArray arrayWithObjects:btnCurrent, btnSearch, nil]];

    

    
}


- (void)searchNavigationItemTouched
{
    [self.searchDisplayController.searchBar becomeFirstResponder];
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([[segue identifier] isEqualToString:@"createProjectSegue"]) {
        ProjectDetailsViewController * controller = segue.destinationViewController;
        controller.project = nil;
    }
    
    if ([[segue identifier] isEqualToString:@"editProjectSegue"]) {
        ProjectDetailsViewController * controller = segue.destinationViewController;
        controller.project = [(ProjectTableViewCell *)sender project];
    }
}


#pragma mark - UITableView Delegates


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // switch between search table view managened by the search bar and search display view ...
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        return [self.searchResults count];
    }
    else {
        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
//        
//        id <NSFetchedResultsSectionInfo> sectionInfo = [self.fetchedResultsController sections][section];
//        
//        NSInteger count = [sectionInfo numberOfObjects];
//        
//        NSLog(@"NumberOfRowsInSecion: %ld ist: %ld", (long)section, (long)count);
//        
//        return count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellId = @"ProjectCell";
    
    ProjectTableViewCell *cell;
    cell = (ProjectTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (cell == nil) {
        cell = [[ProjectTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
                                           reuseIdentifier:cellId];
    }
    
    // pass the model and let cell writing the content as needed (encapsulated)
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        cell.project = [self.searchResults objectAtIndex:indexPath.row];
    } else {
        cell.project = [self.fetchedResultsController objectAtIndexPath:indexPath];
    }
    
    return cell;
}


// Support editing of the table view.
-     (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}

// Override to support editing the table view.
-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // user deletes a row inline
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSManagedObjectContext *context = [self.fetchedResultsController managedObjectContext];
        [context deleteObject:[self.fetchedResultsController objectAtIndexPath:indexPath]];
        
        NSError *error = nil;
        
        if (![context save:&error]) {
            NSLog(@"Unresolved error %@, %@", error, [error localizedDescription]);
            abort();
        }
    }
}

// Override to support conditional rearranging of the table view.
-     (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
//    return YES;
    return NO;
}

-     (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 28;
}


// configure cell hight for search bar and search display controller
-    (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


#pragma mark - NSFetchedResultsControllerDelegate


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];

    
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"projectShortName"
                                                                   ascending:YES];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    NSFetchedResultsController *resultsController;
    
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                            managedObjectContext:self.managedObjectContext
                                                              sectionNameKeyPath:nil
                                                                       cacheName:nil];
    
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


- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}


- (void)controller:(NSFetchedResultsController *)controller
  didChangeSection:(id <NSFetchedResultsSectionInfo>)sectionInfo
           atIndex:(NSUInteger)sectionIndex
     forChangeType:(NSFetchedResultsChangeType)type
{
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
      newIndexPath:(NSIndexPath *)newIndexPath
{
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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
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


-  (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchString:(NSString *)searchString
{
    [self filterContentForSearchText:searchString
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    
    return YES;
}


- (BOOL)searchDisplayController:(UISearchDisplayController *)controller
shouldReloadTableForSearchScope:(NSInteger)searchOption
{
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text] scope:@"All"];
    
    return YES;
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    // hide the search bar until user scolls down
    CGPoint searchBarOffset = CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height);
    
    [self.tableView setContentOffset:searchBarOffset
                            animated:YES];
}


#pragma mark - Search

- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    NSPredicate *predicate;
    [self.searchResults removeAllObjects];
    
    if ([scope isEqualToString:@"Title"]) {
        predicate = [NSPredicate predicateWithFormat:@"projectShortName BEGINSWITH[c] %@", searchText];
    }
    else {
        predicate = [NSPredicate predicateWithFormat:@"projectShortName CONTAINS[cd] %@ || projectLongName CONTAINS[cd] %@ || notes CONTAINS[cd] %@", searchText, searchText, searchText];
    }
    NSLog(@"predicate: %@", predicate);
    
    NSArray * projects = [self.fetchedResultsController fetchedObjects];
    
    NSLog(@"projects: %@", projects);
    
    NSLog(@"search results: %@", [projects filteredArrayUsingPredicate:predicate]);
    
    [self.searchResults addObjectsFromArray:[projects filteredArrayUsingPredicate:predicate]];
    

}


@end
