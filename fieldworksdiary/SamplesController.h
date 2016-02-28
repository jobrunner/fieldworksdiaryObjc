//
//  Samples Controller
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "MGSwipeTableCell.h"
#import <MessageUI/MessageUI.h>


@class UIKit;
// @class MessageUI;

@interface SamplesController : UITableViewController
<   NSFetchedResultsControllerDelegate,
    UISearchBarDelegate,
    UISearchDisplayDelegate,
    UINavigationControllerDelegate,
    UIActionSheetDelegate,
    MFMailComposeViewControllerDelegate,
    MGSwipeTableCellDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
