//
//  TimeZonePickerCell.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 28.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@interface TimeZonePickerCell : UITableViewCell

@property (nonatomic, strong) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *timeZoneNameLabel;

- (void)configureWithTimeZone:(NSTimeZone *)timeZone
                  atIndexPath:(NSIndexPath *)indexPath
                     selected:(BOOL)selected;

@end
