//
//  TimeZonePickerCell.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "TimeZonePickerCell.h"

@implementation TimeZonePickerCell

- (void)configureWithTimeZone:(NSTimeZone *)timeZone
                  atIndexPath:(NSIndexPath *)indexPath
                     selected:(BOOL)selected {
    
    self.indexPath = indexPath;

    NSString *label = [NSString stringWithFormat:@"%@ (%@)", [timeZone name], [timeZone abbreviation]];
    self.timeZoneNameLabel.text = label;

    
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
        self.timeZoneNameLabel.textColor = tintColor;
    }
    else {
        self.timeZoneNameLabel.textColor = textColor;
    }
}

@end
