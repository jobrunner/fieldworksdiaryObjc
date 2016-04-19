@import CoreLocation;

#import "SampleDetailsPlacemarkCell.h"
#import "Fieldtrip.h"
#import "Placemark.h"
#import "AppDelegate.h"
#import "GoogleGeocoder.h"

@interface SampleDetailsPlacemarkCell()

@property (nonatomic, strong) Fieldtrip *sample;

@end

@implementation SampleDetailsPlacemarkCell

@synthesize sample = _sample;


//- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)awakeFromNib
{
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(reverseGeocodeLocation)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationPlacemarkUpdate
                                               object:nil];
}

//- (void)configureWithModel:(NSManagedObject *)managedObject
//               atIndexPath:(NSIndexPath *)indexPath {
//    
//    _indexPath = indexPath;
//    
//    Fieldtrip *sample = (Fieldtrip *)[managedObject valueForKey:@"Fieldtrip"];
//
//    _countryAndAdministrativeAreaLabel.text = [Placemark stringFromPlacemark:fieldtrip.placemark];
//}


#pragma mark - FieldtripDetailsCellProtocol -

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}


- (Fieldtrip *)sample {
    
    return _sample;
}


- (void)updateUserInterface
{
    _countryAndAdministrativeAreaLabel.text = [Placemark stringFromPlacemark:[self.sample placemark]];
}

//- (NSString *)reuseIdentifier
//{
//    return [FieldtripDetailsPlacemarkCell reuseIdentifier];
//}


//+ (NSString *)reuseIdentifier
//{
//    static NSString *identifier = @"FieldtripDetailsPlacemarkCell";
//    
//    return identifier;
//}

#pragma mark - Geocoding -


- (NSDictionary *)locationDictFromResponseJSON:(NSDictionary *)responseJSON {
    
    //    NSDate *responseDate  = [NSDate date];
    //    NSNumber *timestamp   = [NSNumber numberWithLong:[responseDate timeIntervalSince1970]];
    NSDictionary* results = [responseJSON objectForKey:@"results"];
    
    NSMutableDictionary* location = [NSMutableDictionary dictionaryWithDictionary:@{@"country":@"",
                                                                                    @"countryCodeIso":@"",
                                                                                    @"administrative_area_level_1":@"",
                                                                                    @"administrative_area_level_2":@"",
                                                                                    @"administrative_area_level_3":@"",
                                                                                    @"administrative_area_level_4":@"",
                                                                                    @"locality":@"",
                                                                                    @"sublocality":@""
                                                                                    //                                                                                    ,
                                                                                    //                                                                                    @"language":language,
                                                                                    //                                                                                    @"timestamp":timestamp
                                                                                    }];
    NSArray* fields = [location allKeys];
    
    for (NSDictionary* components in results) {
        for (NSDictionary*class in [components objectForKey:@"address_components"]) {
            NSMutableOrderedSet* fieldset = [NSMutableOrderedSet orderedSetWithArray:fields];
            NSSet* types = [NSSet setWithArray:[class objectForKey:@"types"]];
            
            [fieldset intersectSet: types];
            
            if ([fieldset count] > 0) {
                NSString* key = [fieldset firstObject];
                NSString* longValue = [class objectForKey:@"long_name"];
                
                [location setValue:longValue forKey:key];
                
                if ([key isEqual:@"country"]) {
                    NSString* shortValue = [class objectForKey:@"short_name"];
                    [location setValue:shortValue forKey:@"countryCodeIso"];
                }
            }
        }
    }
    
    return (NSDictionary*)location;
}


// will be called when location update notification raised
- (void)reverseGeocodeLocationGoogle {
    
    NSLog(@"reverseGeocodeLocation in Placemark Cell");
    NSLog(@"location: %@", _sample.location);
    
    if (_sample.location == nil) {

//        return ;
    }
    
    self.geocoderOperation =
    [ApplicationDelegate.geocoder geocodeWithLatitude:[_sample.latitude doubleValue]
                                            longitude:[_sample.longitude doubleValue]
                                             language:@"de"
                                           completion:^(NSDictionary *responseJSON) {
                                               
                                               NSLog(@"Geocode succeeded: %@", responseJSON);
                                               
                                               // filter relevant fields from google service
                                               NSDictionary* location;
                                               location = [self locationDictFromResponseJSON:responseJSON];
                                               
                                               Placemark *placemark;
                                               placemark = [[Placemark alloc] initWithGoogleLocationDict:location];
                                               
                                               _sample.placemark = placemark;
                                               
                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkUpdate
                                                                                                   object:self];
                                               
//                                               NSArray *values = [location allValues];
//                                               NSString *displayString = [values componentsJoinedByString:@"\n"];


                                               
                                               
//                                               self.textView.text = displayString;
                                               
                                           } error:^(NSError *error) {
                                               
                                               NSLog(@"Error-Code: %ld", (long)error.code);

                                               _sample.placemark = nil;
                                               [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkFailure
                                                                                                   object:self];
                                               
//                                               NSLog(@"Geocode failed with error: %@", [error localizedDescription]);
//                                               self.textView.text = @"will try to get data, when network is reachable.";
                                               
                                           }];
    
    
//    [self.geocoderOperation start];
    
    return;
    
    // todo: in Operation Queue ausführen:
    
    // CoreLocation Geocoding
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[self.sample location]
                   completionHandler:^(NSArray *placemarks, NSError *error)
     {
         if (placemarks.count) {
             NSLog(@"Locality reverse coded and found. %@", self);
             
             CLPlacemark * placemark = [placemarks lastObject];
             
             self.sample.placemark = [[Placemark alloc] initWithPlacemark:placemark];
             
             //             [self.fieldtrip setPlacemark:[[Placemark alloc] initWithPlacemark:placemark]];
             
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkUpdate
                                                                 object:self];
         } else {
             [self.sample setPlacemark:nil];
             
             // we will post a 'Not Found' notification to NotificationCenter if an address wasn't found
             [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkFailure
                                                                 object:self];
         }
     }];
}

- (void)reverseGeocodeLocation {
    
    // CoreLocation Geocoding
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:[self.sample location]
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       
                       if (placemarks.count) {
//                           NSLog(@"Locality reverse coded and found. %@", self);
             
                           CLPlacemark * placemark = [placemarks lastObject];
             
                           self.sample.placemark = [[Placemark alloc] initWithPlacemark:placemark];
             
                           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkUpdate
                                                                 object:self];
                       }
                       else {
                           self.sample.placemark = nil;
             
                           // we will post a 'Not Found' notification to NotificationCenter if an address wasn't found
                           [[NSNotificationCenter defaultCenter] postNotificationName:kNotificationPlacemarkFailure
                                                                 object:self];
                       }
                   }];
}

@end
