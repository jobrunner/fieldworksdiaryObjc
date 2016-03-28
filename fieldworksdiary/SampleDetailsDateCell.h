// #import "SampleDetailsCellProtocol.h"

// @class Fieldtrip;

@interface SampleDetailsDateCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *dayNightStatusImageView;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunriseLabel;
@property (weak, nonatomic) IBOutlet UILabel *sunsetLabel;
@property (weak, nonatomic) IBOutlet UIImageView *sunriseImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sunsetImageView;

@property (nonatomic, readonly) NSIndexPath *indexPath;

// @property (nonatomic, strong) Fieldtrip * fieldtrip;

//+ (NSString *)reuseIdentifier;
//- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
//- (Fieldtrip *)fieldtrip;

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath;
@end
