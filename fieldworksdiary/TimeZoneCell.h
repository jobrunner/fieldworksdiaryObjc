@interface TimeZoneCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *timeZoneNameLabel;

- (void)configureWithTimeZone:(NSTimeZone *)timeZone
                  atIndexPath:(NSIndexPath *)indexPath
                     selected:(BOOL)selected;

@end
