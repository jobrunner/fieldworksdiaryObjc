//
//  FieldtripCell.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGSwipeTableCell.h"
#import "Project.h"

@interface FieldtripCell : MGSwipeTableCell

@property (strong, nonatomic) NSIndexPath *indexPath;

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginEndLabel;
@property (weak, nonatomic) IBOutlet UILabel *isActiveLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isActiveImageView;

- (void)configureWithModel:(NSManagedObject *)managedObject
                 indexPath:(NSIndexPath *)indexPath
              selectorOnly:(BOOL)selectorOnly;
@end
