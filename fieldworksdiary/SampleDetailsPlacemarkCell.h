
@class Fieldtrip;
@class MKNetworkOperation;

@interface SampleDetailsPlacemarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countryAndAdministrativeAreaLabel;

@property (strong, nonatomic) MKNetworkOperation *geocoderOperation;

- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
