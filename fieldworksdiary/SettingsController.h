//
//  SettingsController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "FieldtripsController.h"
#import "CoordinateSystemPickerController.h"

@interface SettingsController : UITableViewController <
    FieldtripPickerDelegate,
    CoordinateSystemPickerDelegate>

@end
