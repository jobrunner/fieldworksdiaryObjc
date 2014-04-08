//
//  TestDummyViewController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 08.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TestDummyViewController : UIViewController <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *celciusTextField;
@property (weak, nonatomic) IBOutlet UITextField *fahrenheitTextField;

@end
