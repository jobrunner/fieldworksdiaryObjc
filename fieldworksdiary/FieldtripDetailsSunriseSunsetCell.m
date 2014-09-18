//
//  SunriseSunsetView.m
//  sunrise
//
//  Created by Jo Brunner on 16.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "FieldtripDetailsSunriseSunsetCell.h"

@implementation FieldtripDetailsSunriseSunsetCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void)awakeFromNib
{
    // Initialization code
}


#pragma mark - FieldtripDetailsCellProtocol -

- (void)setFieldtrip:(Fieldtrip *)fieldtrip
{
    _fieldtrip = fieldtrip;
    [self updateUserInterface];
}


- (Fieldtrip *)fieldtrip
{
    return _fieldtrip;
}


- (void)updateUserInterface
{
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsSunriseSunsetCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsSunriseSunsetCell";
    
    return identifier;
}

// other

- (void)drawSunriseLabelFromFromModel
{
//    NSDate * date = self.fieldtrip.sunrise;
//    
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
//    [timeFormatter setDateStyle: NSDateFormatterNoStyle];
//    [timeFormatter setTimeStyle: NSDateFormatterShortStyle];
//    
//    NSString * formatedTime = [timeFormatter stringFromDate:date];
//    
//    if (![self.sunriseLabel.text isEqualToString:formatedTime]) {
//        self.sunriseLabel.text = formatedTime;
//    }
}


- (void)drawSunsetLabelFromModel
{
//    NSDate * date = self.fieldtrip.sunset;
//    
//    NSDateFormatter *timeFormatter = [[NSDateFormatter alloc] init];
//    [timeFormatter setDateStyle: NSDateFormatterNoStyle];
//    [timeFormatter setTimeStyle: NSDateFormatterShortStyle];
//    
//    NSString * formatedTime = [timeFormatter stringFromDate:date];
//    
//    if (![self.sunsetLabel.text isEqualToString:formatedTime]) {
//        self.sunsetLabel.text = formatedTime;
//    }
}

@end
