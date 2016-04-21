@protocol TimeZonesControllerDelegate;

@interface TimeZonesController : UITableViewController

@property (nonatomic, copy) NSString *regionNameFilter;
@property (nonatomic, copy) NSTimeZone *timeZone;
@property (nonatomic, weak) id<TimeZonesControllerDelegate> delegate;

@end

@protocol TimeZonesControllerDelegate <NSObject>

@optional

- (void)timeZonesController:(TimeZonesController *)controller
          didSelectTimeZone:(NSTimeZone *)timeZone;

@end