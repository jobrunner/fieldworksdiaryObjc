//
//  ProjectTableViewCell.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Project.h"

@interface ProjectTableViewCell : UITableViewCell

// das ist dreck! Zugriff ganz anders.
//@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *projectTimelineLabel;

@property (strong, nonatomic) Project * project;

@end
