//
//  ProjectTableViewCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "ProjectTableViewCell.h"

@interface ProjectTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *projectNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *projectTimelineLabel;

@end

@implementation ProjectTableViewCell


//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier
//{
//    self = [super initWithStyle:style
//                reuseIdentifier:reuseIdentifier];
//    
//    if (self) {
//        // Initialization code
//        self.name.text = self.model.name;
//        self.projectTimeline.text = [self.model.beginDate description];
//    }
//    
//    return self;
//}

// Overload synthentisized setter
- (void)setProject:(Project *)project
{
    _project = project;
    
    [self configureCell];
}

- (void)configureCell
{
    _projectNameLabel.text = self.project.projectShortName;
    _projectTimelineLabel.text = [self.project.beginDate description];
}

@end
