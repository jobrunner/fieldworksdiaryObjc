#import "SampleDetailsDateCell.h"
#import "Fieldtrip.h"
#import "DateUtility.h"

@implementation SampleDetailsDateCell

@synthesize sample = _sample;

//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)awakeFromNib {
    
    self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);

    // das muss sehr spät aufgerufen werden, damit das geht...
    [_beginDateLabel sizeToFit];
    [_beginDateLabel setNumberOfLines:0];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationDateUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationLocationUpdate
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationSunriseSunsetTwilightUpdate
                                               object:nil];
}

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}


- (Fieldtrip *)sample {
    
    return _sample;
}



//- (void)configureWithModel:(NSManagedObject *)managedObject
//               atIndexPath:(NSIndexPath *)indexPath {
//    
//    _sample = (Fieldtrip *)managedObject;
//    _indexPath = indexPath;
//
//    [self updateUserInterface];

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
//}

- (void)updateUserInterface {

    if (_sample == nil) {
        
        return;
    }
    
//    NSLog(@"updateUserInterface in SampleDetailsDateCell");

    Fieldtrip *sample = _sample;
    
    NSString *dateRangeString = [DateUtility formattedBeginDate:_sample.beginDate
                                                        endDate:_sample.endDate
                                                         allday:_sample.isFullTime.boolValue];
    self.beginDateLabel.text = dateRangeString;

    if (_sample.isFullTime.boolValue) {
        
        self.timeZoneLabel.text = @"";
    }
    else {
        NSString *timeZoneCaption = NSLocalizedString(@"Time zone", @"Time zone");
        NSString *timeZoneString = [NSString stringWithFormat:@"%@: %@ (%@)", timeZoneCaption, sample.timeZone.name, _sample.timeZone.abbreviation];

        self.timeZoneLabel.text = timeZoneString;
    }
    

    if (_sample.location == nil || _sample.sunrise == nil || _sample.sunset == nil) {
        _dayNightStatusImageView.hidden = YES;
        _sunriseLabel.text = nil;
        _sunsetLabel.text = nil;
        _sunriseImageView.hidden = YES;
        _sunsetImageView.hidden = YES;
    }
    else {
    
        // day light/night icon
        _dayNightStatusImageView.hidden = NO;
        _dayNightStatusImageView.highlighted = [self isDayLightWidthDate:_sample.beginDate
                                                             sunriseDate:_sample.sunrise
                                                              sunsetDate:_sample.sunset];

        // Update sunrise and sunset times
        NSDateFormatter *sunriseSunsetDateFormatter = nil;
        if (sunriseSunsetDateFormatter == nil) {
            sunriseSunsetDateFormatter = [[NSDateFormatter alloc] init];
            sunriseSunsetDateFormatter.dateStyle = NSDateFormatterNoStyle;
            sunriseSunsetDateFormatter.timeStyle = NSDateFormatterShortStyle;
        }
    
        _sunriseImageView.hidden = NO;
        _sunsetImageView.hidden = NO;
        _sunriseLabel.text = [sunriseSunsetDateFormatter stringFromDate:_sample.sunrise];
        _sunsetLabel.text  = [sunriseSunsetDateFormatter stringFromDate:_sample.sunset];
    }
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

@end