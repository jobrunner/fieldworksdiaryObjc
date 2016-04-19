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
    
//    [[NSNotificationCenter defaultCenter] addObserver:self
//                                             selector:@selector(updateLocationFailure)
//                                                 name:kNotificationLocationFailure
//                                               object:nil];
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
    
    CLLocation * location = [self.sample location];
    
    if (location == nil) {

        self.coordinatesLabel.text = @"No coordinates available";
        self.coordinatesLabel.textColor = UIColor.redColor;

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