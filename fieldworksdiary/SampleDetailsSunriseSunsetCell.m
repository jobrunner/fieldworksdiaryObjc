#import "SampleDetailsSunriseSunsetCell.h"

@implementation SampleDetailsSunriseSunsetCell

@synthesize sample = _sample;


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)awakeFromNib {
    
    // Initialization code
}

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}

- (Fieldtrip *)sample {
    
    return _sample;
}

- (void)updateUserInterface {

}

//- (NSString *)reuseIdentifier
//{
//    return [FieldtripDetailsSunriseSunsetCell reuseIdentifier];
//}
//
//
//+ (NSString *)reuseIdentifier
//{
//    static NSString *identifier = @"FieldtripDetailsSunriseSunsetCell";
//    
//    return identifier;
//}

// other

//- (void)drawSunriseLabelFromFromModel {
//    
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
//}


//- (void)drawSunsetLabelFromModel {
//
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
//}

@end