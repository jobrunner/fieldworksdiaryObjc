//
//  FieldtripPicker.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "FieldtripPicker.h"

// Project aka Fieldtrip
#import "Project.h"
#import "FieldtripCell.h"

@interface FieldtripPicker ()

@end

@implementation FieldtripPicker

- (void)viewDidLoad {

    [super viewDidLoad];

    self.managedObjectContext = ApplicationDelegate.managedObjectContext;
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
    
//    [NSFetchedResultsController deleteCacheWithName:@"FieldtripMasterTable"];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return [[self.fetchedResultsController sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    return [[[self.fetchedResultsController sections] objectAtIndex:section] numberOfObjects];
}

//- (UITableViewCell *)tableView:(UITableView *)tableView
//         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
//    
//    static NSString *cellId = @"fieldtripPickerCell";
//
//    UITableViewCell *cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:cellId];
////                                           forIndexPath:indexPath];
//    
//    if (cell == nil) {
//        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault
//                                      reuseIdentifier:cellId];
//    }
//    
//    
//    Project *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
//    
//    cell.textLabel.text = fieldtrip.name;
//
////    if ([fieldtrip.isActive isEqual:@1]) {
////        cell.accessoryType = UITableViewCellAccessoryCheckmark;
////    }
//    
//    return cell;
//}


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
    
    Project *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    [cell configureWithModel:fieldtrip
                   indexPath:indexPath
                selectorOnly:YES];
}

- (void) tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    FieldtripCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    
//    [self performSegueWithIdentifier:@"editFieldtripSegue"
//                              sender:cell];
}




/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
                                              inManagedObjectContext:self.managedObjectContext];
    
    [request setEntity:entity];
    
    
    // Set the batch size to a suitable number.
    [request setFetchBatchSize:20];
    
    // Edit the sort key as appropriate.
    NSSortDescriptor *sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"name"
                                                                   ascending:NO];
    NSArray *sortDescriptors = @[sortDescriptor];
    
    [request setSortDescriptors:sortDescriptors];
    
    // Edit the section name key path and cache name if appropriate.
    // nil for section name key path means "no sections".
    NSFetchedResultsController *resultsController;
    
    // ???
    // Achtung: Ich habe hier cacheName auf nil gesetzt. Nicht gut.
    // - Der cache wird gelöscht mit:
    // [NSFetchedResultsController deleteCacheWithName:@"ProjectMasterTable"]
    
    //    [NSFetchedResultsController deleteCacheWithName:@"ProjectMasterTable"];
    
    resultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:request
                                                            managedObjectContext:self.managedObjectContext
                                                              sectionNameKeyPath:nil // @"sectionIdentifier"
                                                                       cacheName:nil]; // @"ProjectMasterTable"
    resultsController.delegate = self;
    
    _fetchedResultsController = resultsController;
    
    NSError *error = nil;
    
    if (![_fetchedResultsController performFetch:&error]) {
        // Replace this implementation with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        
        abort();
    }
    
    return _fetchedResultsController;
}

@end
