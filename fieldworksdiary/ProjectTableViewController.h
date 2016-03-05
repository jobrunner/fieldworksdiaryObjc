//
//  ProjectTableViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@class Project;

@protocol FieldtripPickerDelegate;

@interface ProjectTableViewController : UITableViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate,
    UISearchBarDelegate,
    UISearchDisplayDelegate> {
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

@property BOOL useAsPicker;
@property (nonatomic, weak) id<FieldtripPickerDelegate> delegate;

@end

@protocol FieldtripPickerDelegate <NSObject>

@optional

- (void)fieldtripPicker:(ProjectTableViewController *)picker
     didSelectFieldtrip:(Project *)fieldtrip;

@end