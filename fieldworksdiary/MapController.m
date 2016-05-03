//
//  SpecimenMapControllerViewController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 18.09.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//
@import MapKit;

#import "MapController.h"
#import "Fieldtrip.h"

@interface MapController ()

@end

@implementation MapController

//- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
//    
//    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
//    if (self) {
//        // Custom initialization
//    }
//    return self;
//}
//
- (void)viewDidLoad {

    [super viewDidLoad];
    
    MKCoordinateRegion region;
    
    region.center.latitude = [self.sample.latitude doubleValue]; // location.coordinate.latitude;
    region.center.longitude = [self.sample.longitude doubleValue]; //  location.coordinate.longitude;
    
    // aus dem Datensatz nehmen...
    region.span.longitudeDelta = 0.01; // ca. 111km / 0.001° => 100m
    region.span.latitudeDelta = 0.01;  // ca. 111km / 0.001° => 100m
    
    self.mapView.delegate = self;
    // Configure the small mapView object
    // There are three options for Apple Maps:
    // - MKMapTypeStandard (default)
    // - MKMapTypeSatellite
    // - MKMapTypeHybrid

    // Standard must be configred be user in settings:
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = YES;
    self.mapView.scrollEnabled = YES;
    // self.mapView.contentScaleFactor = 2.0;
    
    [self.mapView setRegion:region
                   animated:NO];

    [self addAnnotations];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

- (void)addAnnotations {
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([_sample.latitude doubleValue], [_sample.longitude doubleValue]);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];

    annotation.coordinate = coords;

    [self.mapView addAnnotation:annotation];
}

-(MKAnnotationView *) mapView:(MKMapView *)mapView
            viewForAnnotation:(id<MKAnnotation>)annotation {
    
    MKPinAnnotationView *pin = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                                               reuseIdentifier:@"current"];
    pin.image = [UIImage imageNamed:@"annotation-pin"];
    
    return pin;
}
@end
