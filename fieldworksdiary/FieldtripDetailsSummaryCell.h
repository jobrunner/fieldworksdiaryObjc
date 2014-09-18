#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsSummaryCell : UITableViewCell <FieldtripDetailsCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel *coordinatesTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
//@property (weak, nonatomic) IBOutlet UILabel *currentTimeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *dayNightStatusImageView;
// @property (weak, nonatomic) IBOutlet UIImageView *staticMapImage;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *countryAndAdministrativeAreaLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectLabel;

@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;

@property (nonatomic, strong) Fieldtrip * fieldtrip;


@property (weak, nonatomic) IBOutlet UIButton *locationUpdateButton;

- (IBAction)locationUpdateButtonTouched:(UIButton *)sender;


+ (NSString *)reuseIdentifier;
- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
