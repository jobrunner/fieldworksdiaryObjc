//
//  FieldtripViewController.h
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FieldtripsController : UITableViewController <NSFetchedResultsControllerDelegate, UISearchBarDelegate, UISearchDisplayDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;

@end
