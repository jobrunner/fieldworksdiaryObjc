@class Fieldtrip;
@class MKMapView;

@interface MapController : UIViewController <MKMapViewDelegate>

/*!
 *  Holds a reference to the sample model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Fieldtrip *sample;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
