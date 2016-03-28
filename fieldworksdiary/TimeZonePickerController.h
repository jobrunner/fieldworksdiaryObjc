//
//  TimeZonePicker.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@protocol TimeZonePickerDelegate;

@interface TimeZonePickerController : UITableViewController

@property (nonatomic, strong) NSArray *timezoneNames;
@property (nonatomic, weak) id<TimeZonePickerDelegate> delegate;

@end

@protocol TimeZonePickerDelegate <NSObject>

@optional

- (void)timeZonePicker:(TimeZonePickerController *)picker
     didSelectTimeZone:(NSTimeZone *)timeZone;

@end