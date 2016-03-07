//
//  SamplesCellTableViewCell.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 07.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "MGSwipeTableCell.h"

@interface SampleCell : MGSwipeTableCell

@property (strong, nonatomic) NSIndexPath *indexPath;

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath
              withDelegate:(id<MGSwipeTableCellDelegate>)delegate;
@end
