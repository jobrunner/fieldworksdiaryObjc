#import "FieldtripDetailsLocationCell.h"
#import "Conversion.h"
#import "Fieldtrip.h"
#import "Placemark.h"

@implementation FieldtripDetailsLocationCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style
    reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style
                reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code

        // make seperator invisible:
        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
    }
    
    return self;
}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateLocationFailure)
//                                                 name:kNotificationLocationFailure
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
    CLLocation * location = [self.fieldtrip location];
    
    if (location == nil) {
        self.coordinatesLabel.text = nil;
        self.altitudeLabel.text = nil;
        self.horizontalAccuracyLabel.text = nil;
        self.verticalAccuracyLabel.text = nil;
        
        return;
    }
    
    // Formatieren der Location Properties nach Geodetic decimal:
    CoordinateFormat withCoordinateFormat = kCoordinateFormatGeodeticDecimal;
    MapDatum withMapDatum = kMapDatumWGS1984;
    UnitOfLength withUnitOfLength = kUnitOfLengthMeter;
    
    Conversion *conversion = [Conversion new];
    
    switch (withCoordinateFormat) {
        case kCoordinateFormatGeodeticDecimal:
        case kCoordinateFormatGeodeticDegreesShort:
        case kCoordinateFormatGeodeticDegreesLong:
            self.coordinatesLabel.text = [conversion locationToCoordinates:location
                                                                    format:withCoordinateFormat
                                                                  mapDatum:withMapDatum];
            break;
            
        case kCoordinateFormatMGRSLong:
        case kCoordinateFormatMGRSShort:
        case kCoordinateFormatUTMLong:
        case kCoordinateFormatUTMShort:
            NSLog(@"just unsupported coodinate format in use!");
            break;
    }
    
    self.altitudeLabel.text = [conversion locationToAltitude:location
                                            withUnitOfLength:withUnitOfLength];
    
    self.horizontalAccuracyLabel.text = [conversion locationToHorizontalAccuracy:location
                                                                withUnitOfLength:withUnitOfLength];
    
    self.verticalAccuracyLabel.text = [conversion locationToVerticalAccuracy:location
                                                            withUnitOfLength:withUnitOfLength];
}

- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsLocationCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsLocationCell";
    
    return identifier;
}

#pragma mark - IBAction -

- (IBAction)locationUpdateButtonTouched:(UIButton *)sender
{
}

@end
