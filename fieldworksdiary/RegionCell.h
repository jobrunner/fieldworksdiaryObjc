#import <UIKit/UIKit.h>

@interface RegionCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *regionLabel;

- (void)configureWithRegion:(NSString *)region
                atIndexPath:(NSIndexPath *)indexPath
                   selected:(BOOL)selected;

@end
