//
//  FieldtripPicker.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@class UIKit;
@class Project;

@protocol FieldtripPickerDelegate

- (void)fieldtripPicker:(UITableView *)picker
     didSelectFieldtrip:(Project *)fieldtrip
             identifier:(NSString *)identifier;

@end

@interface FieldtripPicker : UITableViewController <UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate> {
    
    NSIndexPath *selectedIndexPath;
//    NSFetchedResultsController *fetchedResultsController;
//    NSManagedObjectContext *managedObjectContext;
}

//+ (NSArray *)countryNames;
//+ (NSArray *)countryCodes;
//+ (NSDictionary *)countryNamesByCode;
//+ (NSDictionary *)countryCodesByName;

 @property (strong, nonatomic) NSFetchedResultsController *fetchedResultsController;
 @property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@property (nonatomic, weak) id<FieldtripPickerDelegate> delegate;
@property (nonatomic, copy) NSString *selectedFieldtripName;
// @property (nonatomic, copy) NSString *selectedCountryCode;

// - (void)setWithLocale:(NSLocale *)locale;

@end


