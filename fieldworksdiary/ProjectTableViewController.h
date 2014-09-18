//
//  ProjectTableViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "ProjectTableViewCell.h"
#import "ProjectDetailsViewController.h"
#import "Project.h"


@interface ProjectTableViewController : UITableViewController
<NSFetchedResultsControllerDelegate,
UISearchBarDelegate,
UISearchDisplayDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end
