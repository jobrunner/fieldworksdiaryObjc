@class Fieldtrip;

@interface SampleDetailsSunriseSunsetCell : UITableViewCell

@property (nonatomic, strong) Fieldtrip * sample;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
