#import "RegionCell.h"

@implementation RegionCell

- (void)configureWithRegion:(NSString *)region
                atIndexPath:(NSIndexPath *)indexPath
                   selected:(BOOL)selected {
    
    self.indexPath = indexPath;
    
    self.regionLabel.text = region;
    
    
    // Tint selected item or check it or...
    static UIColor *tintColor;
    
    // read tintColor. This is a hack...
    if (tintColor == nil) {
        tintColor = [UIColor colorWithRed:(4.0/255.0)
                                    green:(102.0/255.0)
                                     blue:(0.0/255.0)
                                    alpha:1.0];
    }
    
    static UIColor *textColor;
    if (textColor == nil) {
        textColor = [UIColor colorWithRed:(0.0/255.0)
                                    green:(00./255.0)
                                     blue:(0.0/255.0)
                                    alpha:1.0];
    }
    
    if (selected) {
        self.regionLabel.textColor = tintColor;
    }
    else {
        self.regionLabel.textColor = textColor;
    }
}

@end
