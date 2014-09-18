//
//  InputTableViewCell.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 18.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TextFieldCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;

+ (NSString *)reuseIdentifier;

@end
