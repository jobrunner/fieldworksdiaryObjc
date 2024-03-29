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

- (void)configureWithModel:(NSManagedObject *)managedObject
                 atIndexPath:(NSIndexPath *)indexPath
              withDelegate:(id)delegate
              selectorOnly:(BOOL)selectorOnly;

@end
