//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
#import "AppDelegate.h"
#import "FieldtripsController.h"
#import "FieldtripDetailsViewController.h"
#import "FieldtripTableViewCell.h"
#import "Fieldtrip.h"

@interface FieldtripsController ()

@property (nonatomic, retain) NSMutableArray *searchResults;

@property (nonatomic, weak) IBOutlet UISearchBar *searchBar;

@end

@implementation FieldtripsController


#pragma mark - UIViewController


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.managedObjectContext = ApplicationDelegate.managedObjectContext;
    
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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
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


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
	return [[self.fetchedResultsController sections] count];
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];

    return [self sectionTitleFromSectionName:[theSection name]];
}


- (NSString *)sectionTitleFromSectionName:(NSString *)sectionName
{
    // 20140429
    NSInteger numericSection = [sectionName integerValue];
    NSInteger year = numericSection / 10000;
  	NSInteger month = (numericSection - year * 10000) / 100;
    //	NSInteger day = numericSection - year * 10000 - month * 100;
    
    NSDateComponents *dateComponents = [[NSDateComponents alloc] init];
    dateComponents.year = year;
    dateComponents.month = month;
    //    dateComponents.day = day;
    
    NSDate *date = [[NSCalendar currentCalendar] dateFromComponents:dateComponents];
    
	NSString *sectionTitle = [self.sectionHeaderDateFormater stringFromDate:date];
    
    return sectionTitle;
}


- (NSDateFormatter *)sectionHeaderDateFormater
{
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
 numberOfRowsInSection:(NSInteger)section
{
    // switch between search table view managened by the search bar and search display view ...
    if (tableView == self.searchDisplayController.searchResultsTableView) {

        return [self.searchResults count];
    }
    else {

        return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
    }
}


- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 28;
}


- (UIView *)tableView:(UITableView *)tableView
viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.frame.size.width, 28)];

    /* Create custom view to display section header... */
    UILabel *sectionTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(4, 5, tableView.frame.size.width, 18)];

	id <NSFetchedResultsSectionInfo> theSection = [[self.fetchedResultsController sections] objectAtIndex:section];
    
    NSString * sectionTitle = [self sectionTitleFromSectionName:[theSection name]];
    
    [sectionTitleLabel setText:sectionTitle];
    [sectionView addSubview:sectionTitleLabel];
    UIColor * bgColor = [UIColor groupTableViewBackgroundColor];

    [sectionView setBackgroundColor:bgColor];
    
    return sectionView;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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

    return cell;
}


// Support delete (editing) of the table view.
-     (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}


// Override to support editing the table view.
-  (void)tableView:(UITableView *)tableView
commitEditingStyle:(UITableViewCellEditingStyle)editingStyle
 forRowAtIndexPath:(NSIndexPath *)indexPath
{
    // user deletes a row inline
    if (editingStyle == UITableViewCellEditingStyleDelete) {

//        NSLog(@"DELETING...");
        
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

//        NSLog(@"DELETED");
    }
}


// Override to support conditional rearranging of the table view.
-     (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}


// configure cell hight for search bar and search display controller
-    (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 70;
}


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
    [self filterContentForSearchText:[self.searchDisplayController.searchBar text]
                               scope:[[self.searchDisplayController.searchBar scopeButtonTitles]
                                      objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
 
    return YES;
}


- (void)searchDisplayControllerDidEndSearch:(UISearchDisplayController *)controller
{
    // hide the search bar until user did end search
    CGPoint searchBarOffset = CGPointMake(0.0, self.tableView.tableHeaderView.frame.size.height);
    
    [self.tableView setContentOffset:searchBarOffset
                            animated:YES];
}


#pragma mark - Search


- (void)filterContentForSearchText:(NSString*)searchText
                             scope:(NSString*)scope
{
    [self.searchResults removeAllObjects];

    if ([scope isEqualToString:@"All"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localityName contains[cd] %@ || country contains[cd] %@ || countryCodeISO LIKE %@ || localityDescription contains[cd] %@ || administrativeArea contains[cd] %@ || administrativeLocality contains[cd] %@ || administrativeSubLocality contains[cd] %@ || subAdministrativeArea contains[cd] %@", searchText, searchText, searchText, searchText, searchText, searchText, searchText, searchText];

        NSArray * fieldtrips = [self.fetchedResultsController fetchedObjects];
        
        [self.searchResults addObjectsFromArray:[fieldtrips filteredArrayUsingPredicate:predicate]];
        
        return;
    }

    
    if ([scope isEqualToString:@"Title"]) {
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"localityName beginswith[cd] %@", searchText];
        
        NSArray * fieldtrips = [self.fetchedResultsController fetchedObjects];
        
        [self.searchResults addObjectsFromArray:[fieldtrips filteredArrayUsingPredicate:predicate]];
        
        return;
        
    }
}


#pragma mark - NSFetchedResultsControllerDelegate


- (NSFetchedResultsController *)fetchedResultsController
{
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Fieldtrip"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];

    
    // Set the batch size to a suitable number.
    [request setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"beginDate"
                                                                   ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *resultsController;
    
    
    
    
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
            // not supported
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


- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}


@end
