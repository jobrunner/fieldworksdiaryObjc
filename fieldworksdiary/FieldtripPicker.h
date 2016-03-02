//
//  FieldtripPicker.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@class UIKit;
@class Project;

@protocol FieldtripPickerDelegate;

@interface FieldtripPicker : UITableViewController <
    UITableViewDelegate,
    UITableViewDataSource,
    NSFetchedResultsControllerDelegate> {
    
    NSIndexPath *selectedIndexPath;
}

@property (nonatomic, weak) id<FieldtripPickerDelegate> delegate;
@property (nonatomic, copy) Project *selectedFieldtrip;

@end

@protocol FieldtripPickerDelegate <NSObject>

@optional

- (void)fieldtripPicker:(FieldtripPicker *)picker
     didSelectFieldtrip:(Project *)fieldtrip;

@end