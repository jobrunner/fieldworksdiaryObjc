//
//  SpecimenDetailsTableViewController.h
//  sunrise
//
//  Created by Jo Brunner on 18.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "Specimen.h"

@interface SpecimenDetailsTableViewController : UITableViewController <UITextFieldDelegate, UITextViewDelegate>

/*!
 *  Holds a reference to the locality model
 *
 *  @since 1.0
 */
@property (strong, nonatomic) Specimen *specimen;

@end
