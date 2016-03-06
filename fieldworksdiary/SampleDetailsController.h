//
//  MettLocalityCreationViewController.h
//  sunrise
//
//  Created by Jo Brunner on 11.02.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@import UIKit;
@import CoreLocation;
@import MapKit;

@class Fieldtrip;


@interface SampleDetailsController : UITableViewController <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/*!
 *  Holds a reference to the locality model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property BOOL startWithTakePicture;

@end
