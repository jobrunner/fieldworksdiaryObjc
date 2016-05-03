@class Fieldtrip;

@interface SampleDetailsMapViewCell : UITableViewCell <MKMapViewDelegate>

@property (nonatomic, strong) Fieldtrip * sample;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UIImageView *staticMapImage;
@property (weak, nonatomic) IBOutlet UILabel *noMapAvailableLabel;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
