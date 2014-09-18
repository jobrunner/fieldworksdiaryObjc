#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsMapViewCell : UITableViewCell <FieldtripDetailsCellProtocol, MKMapViewDelegate>

@property (nonatomic, strong) Fieldtrip * fieldtrip;
@property (nonatomic, retain) MKMapView *mapView;

@property (nonatomic, weak) IBOutlet UIImageView *staticMapImage;

+ (NSString *)reuseIdentifier;

- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
