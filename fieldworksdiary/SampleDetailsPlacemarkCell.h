
@class Fieldtrip;
@class MKNetworkOperation;

@interface SampleDetailsPlacemarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *countryAndAdministrativeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripLabel;

@property (strong, nonatomic) MKNetworkOperation *geocoderOperation;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
