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

#import "ImageScrollViewCell.h"

@class Fieldtrip;

@interface SampleDetailsController : UITableViewController <
    CLLocationManagerDelegate,
    UIAlertViewDelegate,
    UITextFieldDelegate,
    MKMapViewDelegate,
    UIImagePickerControllerDelegate,
    UINavigationControllerDelegate,
    ImageScrollViewCellDelegate>

/*!
 *  Holds a reference to the locality model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Fieldtrip *sample;

// @property BOOL startWithTakePicture;

@end
