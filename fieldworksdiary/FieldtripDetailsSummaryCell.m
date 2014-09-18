@import CoreLocation;

#import "FieldtripDetailsSummaryCell.h"
#import "Conversion.h"
#import "Fieldtrip.h"
#import "Placemark.h"

//@interface FieldtripDetailsSummaryCell()
//@end


@implementation FieldtripDetailsSummaryCell

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
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterfaceDate)
//                                                 name:kNotificationDateUpdate
//                                               object:nil];

//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateLocation)
//                                                 name:kNotificationLocationUpdate
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateLocationFailure)
//                                                 name:kNotificationLocationFailure
//                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterfacePlacemark)
//                                                 name:kNotificationPlacemarkUpdate
//                                               object:nil];
//    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateUserInterfacePlacemark)
//                                                 name:kNotificationPlacemarkFailure
//                                               object:nil];
}


- (void)setFieldtrip:(Fieldtrip *)fieldtrip
{
    _fieldtrip = fieldtrip;
    
    [self updateUserInterface];
}


- (Fieldtrip *)fieldtrip
{
    return _fieldtrip;
}


//- (void)updateLocation
//{
//    NSLog(@"starte reverse geocoding.");
//    [self reverseGeocodeLocation];
//    
////    [self updateUserInterfaceLocation];
//}
//
//
//- (void)updateLocationFailure
//{
//    
////    [self updateUserInterfaceLocation];
//}


/*!
 *  Updates current date label if changes would be visible to the user. Fixed short style format is used dependend of the device locale.
 *
 *  @since 1.0
 */
//- (void)updateUserInterfaceDate
//{
//    static NSDateFormatter *dateFormatter = nil;
//    
//    if (dateFormatter == nil) {
//        dateFormatter = [NSDateFormatter new];
//        dateFormatter.timeStyle = NSDateFormatterShortStyle;
//        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
//    }
//
//    NSString * formatedDate = [dateFormatter stringFromDate:self.fieldtrip.beginDate];
//
//    self.beginDateLabel.text = formatedDate;
//    
//    self.dayNightStatusImageView.hidden = NO;
//    self.dayNightStatusImageView.highlighted = [self isDayLightWidthDate:_fieldtrip.beginDate
//                                                             sunriseDate:_fieldtrip.sunrise
//                                                              sunsetDate:_fieldtrip.sunset];
//}


/*!
 *  Updates user interface with current location.
 *
 *  @since 1.0
 */
//- (void)updateUserInterfaceLocation
//{
//    CLLocation * location = [self.fieldtrip location];
//    
//    if (location == nil) {
//        self.coordinatesLabel.text = nil;
//        self.altitudeLabel.text = nil;
//        self.horizontalAccuracyLabel.text = nil;
//        self.verticalAccuracyLabel.text = nil;
//        
//        return;
//    }
//    
//    // Formatieren der Location Properties nach Geodetic decimal:
//    CoordinateFormat withCoordinateFormat = kCoordinateFormatGeodeticDecimal;
//    MapDatum withMapDatum = kMapDatumWGS1984;
//    UnitOfLength withUnitOfLength = kUnitOfLengthMeter;
//    
//    Conversion *conversion = [Conversion new];
//    
//    switch (withCoordinateFormat) {
//        case kCoordinateFormatGeodeticDecimal:
//        case kCoordinateFormatGeodeticDegreesShort:
//        case kCoordinateFormatGeodeticDegreesLong:
//            self.coordinatesLabel.text = [conversion locationToCoordinates:location
//                                                                    format:withCoordinateFormat
//                                                                  mapDatum:withMapDatum];
//            break;
//            
//        case kCoordinateFormatMGRSLong:
//        case kCoordinateFormatMGRSShort:
//        case kCoordinateFormatUTMLong:
//        case kCoordinateFormatUTMShort:
//            NSLog(@"just unsupported coodinate format in use!");
//            break;
//    }
//    
//    self.altitudeLabel.text = [conversion locationToAltitude:location
//                                            withUnitOfLength:withUnitOfLength];
//    
//    self.horizontalAccuracyLabel.text = [conversion locationToHorizontalAccuracy:location
//                                                                withUnitOfLength:withUnitOfLength];
//    
//    self.verticalAccuracyLabel.text = [conversion locationToVerticalAccuracy:location
//                                                            withUnitOfLength:withUnitOfLength];
//}








//- (void)updateUserInterfacePlacemark
//{
//    NSLog(@"updateUserInterfacePlacemark");
//    // die Methode placemark muss hier her, weil sie Darstellung macht...
//
//    _countryAndAdministrativeAreaLabel.text = [Placemark stringFromPlacemark:[self.fieldtrip placemark]];
//    
//    
//
//    
//    
//    // Update sunrise and sunset times
//    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
//    [dateFormatter setDateStyle: NSDateFormatterNoStyle];
//    [dateFormatter setTimeStyle: NSDateFormatterShortStyle];
//    
//    _sunriseLabel.text = [dateFormatter stringFromDate:_fieldtrip.sunrise];
//    _sunsetLabel.text = [dateFormatter stringFromDate:_fieldtrip.sunset];
//}


//- (BOOL)isDayLightWidthDate:(NSDate *)date
//                sunriseDate:(NSDate *)sunrise
//                 sunsetDate:(NSDate *)sunset
//{
//    // compare sunrise and sunset time with current time
//    if ([date compare:sunrise] == NSOrderedDescending &&
//        [date compare:sunset] == NSOrderedAscending) {
//        // It is light outside (day)
//        return YES;
//    } else {
//        // It is dark outside (night)
//        return NO;
//    }
//}


//- (void)updateUserInterface
//{
////    [self updateUserInterfaceDate];
////    [self updateUserInterfaceLocation];
////    [self updateUserInterfacePlacemark];
//}





//- (void)reverseGeocodeLocation
//{
//    // todo: in Operation Queue ausführen:
//    
//    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
//    
//    [geocoder reverseGeocodeLocation:[self.fieldtrip location]
//                   completionHandler:^(NSArray *placemarks, NSError *error)
//     {
//         if (placemarks.count) {
//             NSLog(@"Locality reverse coded and found. %@", self);
//             
//             CLPlacemark * placemark = [placemarks lastObject];
//
//             self.fieldtrip.placemark = [[Placemark alloc] initWithPlacemark:placemark];
//             
////             [self.fieldtrip setPlacemark:[[Placemark alloc] initWithPlacemark:placemark]];
//             
//             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkUpdate
//                                                                 object:self];
//         } else {
//            [self.fieldtrip setPlacemark:nil];
//
//             // we will post a 'Not Found' notification to NotificationCenter if an address wasn't found
//             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkFailure
//                                                                 object:self];
//         }
//     }];
//}


- (IBAction)locationUpdateButtonTouched:(UIButton *)sender
{
    
}

#pragma mark - Cell Interface Methods


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsSummaryCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsSummaryCell";
    
    return identifier;
}

@end
