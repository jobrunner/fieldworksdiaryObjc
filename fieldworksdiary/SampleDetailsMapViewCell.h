@class Fieldtrip;

@interface SampleDetailsMapViewCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic, strong) Fieldtrip * sample;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UIImageView *staticMapImage;

+ (NSString *)reuseIdentifier;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
