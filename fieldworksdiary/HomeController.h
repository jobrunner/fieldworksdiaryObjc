//
//  MettHomeTableViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@import UIKit;

@class Fieldtrip;

@interface HomeController : UITableViewController <UIScrollViewDelegate>

//@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
//@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) Fieldtrip *recentFieldtrip;

@end
