#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface SampleDetailsFieldtripCell : UITableViewCell

@property (nonatomic, readonly) NSIndexPath *indexPath;
@property (nonatomic, weak) IBOutlet UILabel *projectLabel;

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath;

@end
