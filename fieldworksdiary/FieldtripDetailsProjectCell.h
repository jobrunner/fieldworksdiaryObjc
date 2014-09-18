#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsProjectCell : UITableViewCell <FieldtripDetailsCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (nonatomic, strong) Fieldtrip * fieldtrip;

+ (NSString *)reuseIdentifier;
- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
