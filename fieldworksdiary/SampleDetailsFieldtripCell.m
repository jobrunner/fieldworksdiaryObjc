#import "SampleDetailsFieldtripCell.h"
#import "Project.h"


@implementation SampleDetailsFieldtripCell

- (void)awakeFromNib {
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationFieldtripUpdate
                                               object:nil];
}

- (void)configureWithModel:(NSManagedObject *)managedObject
                 atIndexPath:(NSIndexPath *)indexPath {
    
    _indexPath = indexPath;

    Project *fieldtrip = (Project *)[managedObject valueForKey:@"Project"];
    
    NSString *fieldtripLabel = NSLocalizedString(@"Fieldtrip", "Fieldtrip");
    _projectLabel.text = [NSString stringWithFormat:@"%@: %@", fieldtripLabel, fieldtrip.name];
}

@end
