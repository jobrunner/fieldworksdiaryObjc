@class Fieldtrip;

@interface SampleDetailsPositionCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *coordinatesTypeLabel;
@property (weak, nonatomic) IBOutlet UILabel *coordinatesLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *altitudeLabel;
@property (weak, nonatomic) IBOutlet UILabel *accuracyCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *horizontalAccuracyLabel;
@property (weak, nonatomic) IBOutlet UILabel *verticalAccuracyLabel;

@property (nonatomic, strong) Fieldtrip * sample;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
