#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsLocationCell : UITableViewCell <FieldtripDetailsCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *coordinatesTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UIButton *locationUpdateButton;

@property (nonatomic, strong) Fieldtrip * fieldtrip;

- (IBAction)locationUpdateButtonTouched:(UIButton *)sender;

+ (NSString *)reuseIdentifier;
- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
