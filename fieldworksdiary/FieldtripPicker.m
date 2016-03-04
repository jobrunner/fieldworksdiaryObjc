//
//  FieldtripPicker.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "FieldtripPicker.h"
#import "Project.h"
#import "FieldtripCell.h"

@interface FieldtripPicker ()

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end

@implementation FieldtripPicker

- (void)viewDidLoad {

    [super viewDidLoad];

    _managedObjectContext = ApplicationDelegate.managedObjectContext;
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
    
    Project *fieldtrip = [self.fetchedResultsController objectAtIndexPath:indexPath];
    
    if ([self.delegate respondsToSelector:@selector(fieldtripPicker:didSelectFieldtrip:)]) {
        [self.delegate fieldtripPicker:self didSelectFieldtrip:fieldtrip];
    }

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - NSFetchedResultsControllerDelegate

- (NSFetchedResultsController *)fetchedResultsController {
    
    if (_fetchedResultsController != nil) {
        
        return _fetchedResultsController;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    NSEntityDescription *entity = [NSEntityDescription entityForName:@"Project"
                                              inManagedObjectContext:_managedObjectContext];
    
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
                                                            managedObjectContext:_managedObjectContext
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