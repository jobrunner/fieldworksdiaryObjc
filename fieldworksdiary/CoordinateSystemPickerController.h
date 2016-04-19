//
//  CoordinateSettingsControllerTableViewController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 09.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//
#import "CoordinateSystemsListController.h"

@class CoordinateSystem;

@protocol CoordinateSystemPickerDelegate;

@interface CoordinateSystemPickerController : UITableViewController <CoordinateSystemsListDelegate>

@property (nonatomic, strong) CoordinateSystem *coordinateSystem;
@property (nonatomic, weak) id<CoordinateSystemPickerDelegate> delegate;

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;

- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

@protocol CoordinateSystemPickerDelegate <NSObject>

@optional

- (void)coordinateSystemPicker:(CoordinateSystemPickerController *)controller
     didSelectCoordinateSystem:(CoordinateSystem *)coordinateSystem;

@end