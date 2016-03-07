//
//  ProjectTableViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "MGSwipeTableCell.h"

@class Project;

@protocol FieldtripPickerDelegate;

@interface FieldtripsController : UITableViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate,
    UISearchBarDelegate,
    UISearchDisplayDelegate,
    MGSwipeTableCellDelegate> {
    
    NSFetchedResultsController *fetchedResultsController;
    NSManagedObjectContext *managedObjectContext;
}

// kFieldtripUsageDetails:      Default. Shows all fieldtrips, selecting a fieldtrip links to details
// kFieldtripUsagePicker:       Shows all fieldtrips, selecting a fieldtrip activates it as active fieldtrip
// kFieldtripUsageSampleFilter: Shows all fieldtrips, selecting an fieldtrip links to corresponding samples
@property FieldtripUsage fieldtripUsage;

//
//@property BOOL useAsOverview;
//
//@property BOOL useAsPicker;
//
//@property BOOL useAsSampleFilter;

@property (nonatomic, weak) id<FieldtripPickerDelegate> delegate;

@end

@protocol FieldtripPickerDelegate <NSObject>

@optional

- (void)fieldtripPicker:(FieldtripsController *)picker
     didSelectFieldtrip:(Project *)fieldtrip;

@end