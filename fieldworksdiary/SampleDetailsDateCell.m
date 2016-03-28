#import "SampleDetailsDateCell.h"
#import "Fieldtrip.h"


@interface SampleDetailsDateCell()

@property (nonatomic, strong) Fieldtrip *sample;

@end


@implementation SampleDetailsDateCell

// @synthesize fieldtrip = _fieldtrip;



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
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);

    // MUSS noch!
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationDateUpdate
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterface)
//                                                 name:kNotificationLocationUpdate
//                                               object:nil];

    
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterface)
//                                                 name:kNotificationSunriseSunsetTwilightUpdate
//                                               object:nil];

}


#pragma mark - FieldtripDetailsCellProtocol -

//- (void)setFieldtrip:(Fieldtrip *)fieldtrip
//{
//    _fieldtrip = fieldtrip;
//    [self updateUserInterface];
//}
//
//
//- (Fieldtrip *)fieldtrip
//{
//    return _fieldtrip;
//}

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath {
    
    _sample = (Fieldtrip *)managedObject;
    _indexPath = indexPath;

    [self updateUserInterface];
    
//    return;
//    
//    static NSDateFormatter *dateFormatter = nil;
//    
//    if (dateFormatter == nil) {
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.timeStyle = NSDateFormatterShortStyle;
//        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//    }
//    
//    NSString * formatedDate = [dateFormatter stringFromDate:sample.beginDate];
//    
//    self.beginDateLabel.text = formatedDate;
//    self.timeZoneLabel.text = sample.timeZone.name;
//    
//    if (sample.location == nil || sample.sunrise == nil || sample.sunset == nil) {
//        _dayNightStatusImageView.hidden = YES;
//        _sunriseLabel.text = nil;
//        _sunsetLabel.text = nil;
//        _sunriseImageView.hidden = YES;
//        _sunsetImageView.hidden = YES;
//    }
//    else {
//        
//        // day light/night icon
//        _dayNightStatusImageView.hidden = NO;
//        _dayNightStatusImageView.highlighted = [self isDayLightWidthDate:sample.beginDate
//                                                             sunriseDate:sample.sunrise
//                                                              sunsetDate:sample.sunset];
//        // Update sunrise and sunset times
//        NSDateFormatter *sunriseSunsetDateFormatter = nil;
//        if (sunriseSunsetDateFormatter == nil) {
//            sunriseSunsetDateFormatter = [[NSDateFormatter alloc] init];
//            sunriseSunsetDateFormatter.dateStyle = NSDateFormatterNoStyle;
//            sunriseSunsetDateFormatter.timeStyle = NSDateFormatterShortStyle;
//        }
//        
//        _sunriseImageView.hidden = NO;
//        _sunsetImageView.hidden = NO;
//        _sunriseLabel.text = [sunriseSunsetDateFormatter stringFromDate:sample.sunrise];
//        _sunsetLabel.text  = [sunriseSunsetDateFormatter stringFromDate:sample.sunset];
//    }
}

- (void)updateUserInterface {

    static NSDateFormatter *dateFormatter = nil;

    Fieldtrip *sample = _sample;
    
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterShortStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }
    
    NSString * formatedDate = [dateFormatter stringFromDate:sample.beginDate];
    
    self.beginDateLabel.text = formatedDate;

    
    // allDay
    if (sample.isFullTime) {
        
        // Freitag, 11. März 2016
        // Fr., 11. bis Sa., 12. März 2016
        // Fr., 11. März bis Sa., 10. April 2016
        // Fr., 11. März 2016 bis Sa., 2. Januar 2017
    }
    else {
        // Freitag, 11. März 2016
        // Von 17:00 bis 19:00
        
        // Fr., 11. März 2016
        
    }
    
    
    NSMutableString *timeZone;
    [timeZone appendFormat:@"%@: %@", @"Time zone", sample.timeZone.name];
    self.timeZoneLabel.text = timeZone;

    if (sample.location == nil || sample.sunrise == nil || sample.sunset == nil) {
        _dayNightStatusImageView.hidden = YES;
        _sunriseLabel.text = nil;
        _sunsetLabel.text = nil;
        _sunriseImageView.hidden = YES;
        _sunsetImageView.hidden = YES;
    }
    else {
    
        // day light/night icon
        _dayNightStatusImageView.hidden = NO;
        _dayNightStatusImageView.highlighted = [self isDayLightWidthDate:sample.beginDate
                                                             sunriseDate:sample.sunrise
                                                              sunsetDate:sample.sunset];

        // Update sunrise and sunset times
        NSDateFormatter *sunriseSunsetDateFormatter = nil;
        if (sunriseSunsetDateFormatter == nil) {
            sunriseSunsetDateFormatter = [[NSDateFormatter alloc] init];
            sunriseSunsetDateFormatter.dateStyle = NSDateFormatterNoStyle;
            sunriseSunsetDateFormatter.timeStyle = NSDateFormatterShortStyle;
        }
    
        _sunriseImageView.hidden = NO;
        _sunsetImageView.hidden = NO;
        _sunriseLabel.text = [sunriseSunsetDateFormatter stringFromDate:sample.sunrise];
        _sunsetLabel.text  = [sunriseSunsetDateFormatter stringFromDate:sample.sunset];
    }
}

//- (NSString *)reuseIdentifier
//{
//    return [FieldtripDetailsDateCell reuseIdentifier];
//}


//+ (NSString *)reuseIdentifier
//{
//    static NSString *identifier = @"FieldtripDetailsDateCell";
//    
//    return identifier;
//}

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
