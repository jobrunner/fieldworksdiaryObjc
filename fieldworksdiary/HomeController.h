//
//  MettHomeTableViewController.h
//  sunrise
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "FieldtripsController.h"
#import "FieldtripDetailsViewController.h"
#import "ProjectTableViewController.h"


@interface HomeController : UITableViewController <NSFetchedResultsControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UIScrollViewDelegate>

@property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;



@end
