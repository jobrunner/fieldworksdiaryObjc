//
//  FieldtripTableViewCell.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Fieldtrip.h"
@class Fieldtrip;

@interface FieldtripTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *localityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateWeekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateTimeLabel;

@property (strong, nonatomic) Fieldtrip *fieldtrip;

@end
