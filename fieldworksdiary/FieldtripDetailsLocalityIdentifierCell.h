//
//  FieldtripDetailsLocalityIdentifierCell.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 15.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsLocalityIdentifierCell : UITableViewCell <FieldtripDetailsCellProtocol,
    UITextFieldDelegate>

@property (strong, nonatomic) Fieldtrip *fieldtrip;
@property (weak, nonatomic) IBOutlet UITextField *localityIdentifierTextField;

- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender;
+ (NSString *)reuseIdentifier;

@end
