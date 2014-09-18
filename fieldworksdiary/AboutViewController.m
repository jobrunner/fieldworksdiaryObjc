//
//  MettAboutViewController.m
//  sunrise
//
//  Created by Jo Brunner on 14.02.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "AboutViewController.h"

@interface AboutViewController ()

- (IBAction)closeButtonTouchUpInside:(UIButton *)sender;
- (IBAction)generateTestdataButtonTouched:(UIButton *)sender;

@end

@implementation AboutViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}


- (IBAction)closeButtonTouchUpInside:(UIButton *)sender
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)generateTestdataButtonTouched:(UIButton *)sender
{
    // Über 11 Jahre.
    // in einem Jahr zwischen 10 und 400 Fieldtrips
    // Zwischen einer und 15 Proben
    // Muster: immer in so 2 Wochen Rhythmen ganz wo anders
    // Inseln (Kanaren) sollen genauso abgebildet werden, wie "Dauer"-Projekte vor der Haustüre
    
    // Das einfachste wäre es, wenn ich meine realen Daten manuell einpflegen würde
    // :D
    
    
    
    

}
@end
