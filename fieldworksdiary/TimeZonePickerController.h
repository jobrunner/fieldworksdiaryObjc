#include "TimeZonesController.h"

@protocol TimeZonePickerDelegate;

@interface TimeZonePickerController : UITableViewController <
    TimeZonesControllerDelegate>

@property (nonatomic, copy) NSTimeZone *timeZone;
@property (nonatomic, weak) id<TimeZonePickerDelegate> delegate;

@end

@protocol TimeZonePickerDelegate <NSObject>

@optional

- (void)timeZonePicker:(TimeZonePickerController *)picker
     didSelectTimeZone:(NSTimeZone *)timeZone;

@end