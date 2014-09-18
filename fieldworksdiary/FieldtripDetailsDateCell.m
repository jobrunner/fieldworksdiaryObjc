#import "FieldtripDetailsDateCell.h"
#import "Fieldtrip.h"

@implementation FieldtripDetailsDateCell

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
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationDateUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterface)
//                                                 name:kNotificationSunriseSunsetTwilightUpdate
//                                               object:nil];

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
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    NSString * formatedDate = [dateFormatter stringFromDate:self.fieldtrip.beginDate];


    
    self.beginDateLabel.text = formatedDate;
    self.timeZoneLabel.text = self.fieldtrip.timeZone.name;

    if (_fieldtrip.location == nil || _fieldtrip.sunrise == nil || _fieldtrip.sunset == nil) {
        _dayNightStatusImageView.hidden = YES;
        _sunriseLabel.text = nil;
        _sunsetLabel.text = nil;
        _sunriseImageView.hidden = YES;
        _sunsetImageView.hidden = YES;
    } else {
    
        // day light/night icon
        _dayNightStatusImageView.hidden = NO;
        _dayNightStatusImageView.highlighted = [self isDayLightWidthDate:_fieldtrip.beginDate
                                                             sunriseDate:_fieldtrip.sunrise
                                                              sunsetDate:_fieldtrip.sunset];

        // Update sunrise and sunset times
        NSDateFormatter *sunriseSunsetDateFormatter = nil;
        if (sunriseSunsetDateFormatter == nil) {
            sunriseSunsetDateFormatter = [[NSDateFormatter alloc] init];
            sunriseSunsetDateFormatter.dateStyle = NSDateFormatterNoStyle;
            sunriseSunsetDateFormatter.timeStyle = NSDateFormatterShortStyle;
        }
    
        _sunriseImageView.hidden = NO;
        _sunsetImageView.hidden = NO;
        _sunriseLabel.text = [sunriseSunsetDateFormatter stringFromDate:_fieldtrip.sunrise];
        _sunsetLabel.text  = [sunriseSunsetDateFormatter stringFromDate:_fieldtrip.sunset];
    }
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsDateCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsDateCell";
    
    return identifier;
}

- (BOOL)isDayLightWidthDate:(NSDate *)date
                sunriseDate:(NSDate *)sunrise
                 sunsetDate:(NSDate *)sunset
{
    // compare sunrise and sunset time with current time
    if ([date compare:sunrise] == NSOrderedDescending &&
        [date compare:sunset] == NSOrderedAscending) {
        // It is light outside (day)
        return YES;
    } else {
        // It is dark outside (night)
        return NO;
    }
}

/**
 * Calculates Sunrise, Sunset and Twilight for a given time zone and coordinates
 * and stores it in the model.
 */
//- (void)calculateSunriseSunsetTwilight
//{
//    // Daten aus dem Model holen:
//    NSDate * date = self.fieldtrip.beginDate;
//    NSTimeZone * timeZone = self.fieldtrip.timeZone;
//    float lat = [self.fieldtrip.latitude doubleValue];
//    float lon = [self.fieldtrip.longitude doubleValue];
//    
//    // initializes the SunriseSet object with mett:
//    EDSunriseSet *sunriseset  = [EDSunriseSet sunrisesetWithTimezone:timeZone
//                                                            latitude:lat
//                                                           longitude:lon];
//    // calculate the sun
//    [sunriseset calculate:date];
//    
//    // Write calculated data of sunrise, sunset and twilight back to model
//    [self setModelWithSunriseSetTwilight:sunriseset];
//}

@end
