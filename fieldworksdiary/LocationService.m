@import CoreLocation;

#import "LocationService.h"

@interface LocationService() <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager *locationManager;

@end

@implementation LocationService

- (id)init
{
    if (self = [super init]) {
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.delegate = self;
    }
    
    return self;
}



+ (BOOL)isEnabled
{
    return [CLLocationManager locationServicesEnabled];
}


+ (BOOL)isAuthorized
{
    CLAuthorizationStatus authorizationStatus = [CLLocationManager authorizationStatus];
    
    if (authorizationStatus == kCLAuthorizationStatusNotDetermined) {
        // User hasn't yet been asked to authorize location updates
        NSLog(@"authorizationStatus: kCLAuthorizationStatusNotDetermined");

        return YES;
        
    } else if (kCLAuthorizationStatusRestricted == authorizationStatus) {
        
        // User gibt keinen Zugriff auf *diese* App
        NSLog(@"authorizationStatus: kCLAuthorizationStatusRestricted");
        
    } else if (kCLAuthorizationStatusDenied == authorizationStatus) {
        
        // User gibt explizit keinen Zugriff auf die App
        NSLog(@"authorizationStatus: kCLAuthorizationStatusDenied");
        
    } else if (kCLAuthorizationStatusAuthorized == authorizationStatus) {
        
        // Zugriff authorisiert!
        NSLog(@"authorizationStatus: kCLAuthorizationStatusAuthorized");
        
        return YES;
    }
    
    return NO;
}


- (void)requestAlwaysAuthorization
{
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {

        NSString *title;
        
        if (status == kCLAuthorizationStatusDenied) {
            title = NSLocalizedString(@"Location services are off", nil);
        } else {
            title = NSLocalizedString(@"Background location is not enabled", nil);
        }
        
        NSString *message = NSLocalizedString(@"To use background location you must turn on 'Always' in the Location Services Settings", nil);
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 1) {
        // Send the user to the Settings for this app
        NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        [[UIApplication sharedApplication] openURL:settingsURL];
    }
}
@end
