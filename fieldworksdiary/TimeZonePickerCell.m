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
                  atIndexPath:(NSIndexPath *)indexPath {
    
    self.indexPath = indexPath;
    self.timeZoneNameLabel.text = [timeZone name];
}

@end
