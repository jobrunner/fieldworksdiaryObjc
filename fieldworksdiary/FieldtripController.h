//
//  FieldtripViewTableViewController.h
//  sunrise
//
//  Created by Jo Brunner on 23.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//


#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>
#import "AppDelegate.h"
#import "LocationService.h"
#import "Crypto.h"
#import "FieldtripDetailsSummaryCell.h"
#import "TextFieldCell.h"
#import "ImageViewCell.h"
#import "SpecimenDetailsTableViewController.h"
#import "FieldtripDetailsEditViewController.h"
#import "Conversion.h"
#import "EDSunriseSet.h"
#import "Fieldtrip.h"
#import "Image.h"




@interface FieldtripController : UITableViewController <CLLocationManagerDelegate, UIAlertViewDelegate, UITextFieldDelegate, MKMapViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) Fieldtrip *fieldtrip;

@end
