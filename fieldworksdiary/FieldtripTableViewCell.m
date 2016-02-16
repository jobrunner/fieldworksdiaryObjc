//
//  FieldtripTableViewCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.03.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "Placemark.h"
#import "FieldtripTableViewCell.h"

@implementation FieldtripTableViewCell


//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style
//                reuseIdentifier:reuseIdentifier];
//    
//    if (!self) {
//        return nil;
//    }
//
//    // Initialization code
//    self.textLabel.adjustsFontSizeToFitWidth = NO;
//    self.textLabel.textColor = [UIColor darkGrayColor];
//    self.detailTextLabel.font = [UIFont systemFontOfSize:12.0f];
//    self.detailTextLabel.numberOfLines = 1;
//    self.selectionStyle = UITableViewCellSelectionStyleGray;
//
//    return self;
//}
//@synthesize fieldtrip;

- (void)setFieldtrip:(Fieldtrip *)fieldtrip
{
    _fieldtrip = fieldtrip;
    
    // labels den Model-Wert zuweisen
    [self configureCell];
}

- (Fieldtrip *)getFieldtrip
{
    return _fieldtrip;
}

- (void)configureCell
{
    _localityNameLabel.text = self.fieldtrip.localityName;
    _locationLabel.text = [Placemark stringFromPlacemark:[self.fieldtrip placemark]];
    
    // rename to placemarkLabel!!!
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:self.fieldtrip.timeZone];
    
    [dateFormatter setDateFormat:@"dd"];
    //    [dateFormatter setDateStyle:NSDateFormatterShortStyle];
    //    [dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    
    _beginDateDayLabel.text = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
    
    [dateFormatter setDateFormat:@"EEEE"];
    _beginDateWeekdayLabel.text = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    _beginDateTimeLabel.text = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
    
    NSMutableString *identifier = [NSMutableString new];
    
    if (self.fieldtrip.specimenIdentifier != nil) {
        [identifier appendFormat:@"%@ ", self.fieldtrip.specimenIdentifier];
    }

    if (self.fieldtrip.localityIdentifier != nil) {
        [identifier appendFormat:@"(%@)", self.fieldtrip.localityIdentifier];
    }
    
    _identifierLabel.text = identifier;
}



@end
