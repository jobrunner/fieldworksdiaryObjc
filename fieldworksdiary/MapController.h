@class Fieldtrip;
@class MKMapView;

@interface MapController : UIViewController <MKMapViewDelegate>

/*!
 *  Holds a reference to the fieldtrip model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property (weak, nonatomic) IBOutlet MKMapView *mapView;

@end
