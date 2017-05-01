#import "SampleDetailsPositionCell.h"
#import "ActiveCoordinateSystem.h"
#import "CoordinateSystem.h"
#import "ActiveCoordinateSystem.h"
#import "Conversion.h"
#import "Fieldtrip.h"
#import "Placemark.h"

@implementation SampleDetailsPositionCell

@synthesize sample = _sample;


//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style
//                reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//
//        // make seperator invisible:
//        self.separatorInset = UIEdgeInsetsMake(0, 0, 0, self.bounds.size.width);
//    }
//    
//    return self;
//}

- (void)awakeFromNib {
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTrackerImageOn)
                                                 name:kNotificationLocationTrackingStart
                                               object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(switchTrackerImageOff)
                                                 name:kNotificationLocationTrackingStop
                                               object:nil];
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateLocationFailure)
//                                                 name:kNotificationLocationFailure
//                                               object:nil];
}

- (void)switchTrackerImageOn {
    
    // grün animieren:
    _locationTrackerImage.animationImages = @[[UIImage imageNamed:@"satelite-on-1"],
                                              [UIImage imageNamed:@"satelite-on-2"],
                                              [UIImage imageNamed:@"satelite-on-3"],
                                              [UIImage imageNamed:@"satelite-on-4"]];
    _locationTrackerImage.animationDuration = 0.6f;
    [_locationTrackerImage startAnimating];
}

- (void)switchTrackerImageOff {

    [_locationTrackerImage stopAnimating];
}

- (void)setSample:(Fieldtrip *)sample
{
    _sample = sample;
    
    [self updateUserInterface];
}

- (Fieldtrip *)sample {
    
    return _sample;
}

- (void)updateUserInterface {
    
    CLLocation * location = self.sample.location;
    
    if (location == nil) {

        self.coordinatesTypeLabel.text = nil;
        self.coordinatesTypeLabel.hidden = YES;
        
        self.coordinatesLabel.text = NSLocalizedString(@"No coordinates available",
                                                       @"Sample Details");
        // self.coordinatesLabel.textColor = UIColor.redColor;

        self.accuracyCaptionLabel.hidden = YES;
        self.altitudeCaptionLabel.hidden = YES;
        self.altitudeLabel.text = nil;

        self.horizontalAccuracyLabel.hidden = YES;
        self.horizontalAccuracyLabel.text = nil;
        self.verticalAccuracyLabel.hidden = YES;
        self.verticalAccuracyLabel.text = nil;
        
        return;
    }
        
    UnitOfLength unitOfLength = [ActiveCoordinateSystem unitOfLength];
    CoordinateSystem *coordinateSystem = [ActiveCoordinateSystem coordinateSystem];

    Conversion *conversion = Conversion.new;

    self.coordinatesTypeLabel.text = coordinateSystem.localizedSystemName;
    self.coordinatesLabel.textColor = UIColor.darkGrayColor;
    self.coordinatesLabel.text = [conversion locationToCoordinates:location
                                                  coordinateSystem:coordinateSystem];

    self.altitudeCaptionLabel.hidden = NO;
    self.altitudeLabel.hidden = NO;
    self.altitudeLabel.text = [conversion locationToAltitude:location
                                            withUnitOfLength:unitOfLength];

    self.accuracyCaptionLabel.hidden = NO;
    self.horizontalAccuracyLabel.hidden = NO;
    self.horizontalAccuracyLabel.text = [conversion locationToHorizontalAccuracy:location
                                                                withUnitOfLength:unitOfLength];

    self.verticalAccuracyLabel.hidden = NO;
    self.verticalAccuracyLabel.text = [conversion locationToVerticalAccuracy:location
                                                            withUnitOfLength:unitOfLength];
}

@end