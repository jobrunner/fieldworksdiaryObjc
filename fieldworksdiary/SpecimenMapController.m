//
//  SpecimenMapControllerViewController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 18.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@import MapKit;

#import "SpecimenMapController.h"
#import "Fieldtrip.h"

@interface SpecimenMapController ()

@end

@implementation SpecimenMapController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    MKCoordinateRegion region;
    
    region.center.latitude = [self.fieldtrip.latitude doubleValue]; // location.coordinate.latitude;
    region.center.longitude = [self.fieldtrip.longitude doubleValue]; //  location.coordinate.longitude;
    
    region.span.longitudeDelta = 0.01; // ca. 111km / 0.001° => 100m
    region.span.latitudeDelta = 0.01;  // ca. 111km / 0.001° => 100m
    
    self.mapView.delegate = self;
    // Configure the small mapView object
    // There are three options for Apple Maps:
    // - MKMapTypeStandard (default)
    // - MKMapTypeSatellite
    // - MKMapTypeHybrid

    // must be configred be user in settings:
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    self.mapView.contentScaleFactor = 2.0;
    
    [self.mapView setRegion:region
                   animated:NO];

    [self addAnnotations];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)addAnnotations
{
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.fieldtrip.latitude doubleValue], [self.fieldtrip.longitude doubleValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];

    annotation.coordinate = coords;

    [self.mapView addAnnotation:annotation];
}


-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation
{
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:@"current"];
    pin.image = [UIImage imageNamed:@"annotation-pin"];
    
    return pin;
}
@end
