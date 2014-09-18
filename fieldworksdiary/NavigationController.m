//
//  NavigationController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 14.07.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "NavigationController.h"
#import "HomeController.h"

@implementation NavigationController


#pragma mark - UIViewController -


- (void)viewDidLoad
{
    [super viewDidLoad];

    self.delegate = self;
}

#pragma mark - NavigationControllerDelegates -


// delegate method before navigation and view did load
// This implementation is not well seperated by concern
- (void)navigationController:(UINavigationController *)navigationController
      willShowViewController:(UIViewController *)viewController
                    animated:(BOOL)animated
{
    if ([viewController isKindOfClass:[HomeController class]]) {
        if (!self.navigationBarHidden) {
            [self setNavigationBarHidden:YES
                                animated:NO];
        }
    } else {
        if (self.navigationBarHidden) {
            [self setNavigationBarHidden:NO
                                animated:NO];
        }
    }
}

@end
