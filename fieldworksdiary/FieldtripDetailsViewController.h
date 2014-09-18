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

//#import "AppDelegate.h"
//#import "FwdLocationService.h"
//#import "Crypto.h"
//#import "FieldtripDetailsSummaryCell.h"
//#import "TextFieldCell.h"
//#import "ImageViewCell.h"
//#import "SpecimenDetailsTableViewController.h"
//#import "FieldtripDetailsEditViewController.h"
//#import "FwdConversion.h"
//#import "EDSunriseSet.h"
//// #import "Fieldtrip.h"
//#import "Image.h"


@interface FieldtripDetailsViewController : UITableViewController <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

/*!
 *  Holds a reference to the locality model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property BOOL startWithTakePicture;

@end
