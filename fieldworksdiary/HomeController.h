//
//  HomeViewController.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

@class Fieldtrip;

@interface HomeController : UITableViewController <UIScrollViewDelegate>

@property (strong, nonatomic) Fieldtrip *recentSample;

@end
