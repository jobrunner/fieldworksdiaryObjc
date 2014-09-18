#import "FieldtripDetailsCellProtocol.h"


@class Fieldtrip;
@class MKNetworkOperation;

@interface FieldtripDetailsPlacemarkCell : UITableViewCell <FieldtripDetailsCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *countryAndAdministrativeAreaLabel;

@property (strong, nonatomic) MKNetworkOperation *geocoderOperation;

+ (NSString *)reuseIdentifier;
- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
