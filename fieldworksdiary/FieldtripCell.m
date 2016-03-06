//
//  FieldtripCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "FieldtripCell.h"
#import "ActiveFieldtrip.h"

@interface FieldtripCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginEndLabel;
@property (weak, nonatomic) IBOutlet UIImageView *isActiveImageView;

@end

@implementation FieldtripCell

- (void)awakeFromNib {

    //configure right swipe buttons
    self.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" // Delete, index = 1
                                                    icon:[UIImage imageNamed:@"trash"]
                                         backgroundColor:[UIColor redColor]
                                                 padding:kSwipeIconPadding],
                          [MGSwipeButton buttonWithTitle:@""  // Flag, index = 2
                                                    icon:[UIImage imageNamed:@"flag"]
                                         backgroundColor:[UIColor greenColor]
                                                 padding:kSwipeIconPadding]];
    self.rightSwipeSettings.transition = MGSwipeTransitionBorder;
}

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath
              withDelegate:(id)delegate
              selectorOnly:(BOOL)selectorOnly {
    
    self.indexPath = indexPath;
    self.nameLabel.text = [managedObject valueForKey:@"name"];
    self.delegate = delegate;
    BOOL isActive = [ActiveFieldtrip isActive:(Project *)managedObject];
    self.isActiveImageView.hidden = !isActive;
    
    if (selectorOnly) {
        self.accessoryType = UITableViewCellAccessoryNone;
    }
    else {
        self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    static NSDateFormatter *dateFormatter = nil;
    
    if (dateFormatter == nil) {
        dateFormatter = [NSDateFormatter new];
        dateFormatter.timeStyle = NSDateFormatterNoStyle;
        dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    }

    // @todo
    // 1) equal: Show only beginDate
    // 2) different days:  <beginDate.Day>. - <endDate.Day>.<Month>.<Year>
    // 3) different month: <beginDate.Day>.<beginDate.Month>. - <endDate.Day>.<endDate.Month>.<endDate.Year>
    // 4) different year:  <beginDate> - <endDate>
    
    NSDate *beginDate = [managedObject valueForKey:@"beginDate"];
    NSString * beginDateFormatted = [dateFormatter stringFromDate:beginDate];

    NSDate *endDate = [managedObject valueForKey:@"endDate"];
    NSString *endDateFormatted = [dateFormatter stringFromDate:endDate];
    
    NSMutableString *beginEnd = [[NSMutableString alloc] init];

    [beginEnd appendFormat:@"Vom %@ bis %@", beginDateFormatted, endDateFormatted];
    
    self.beginEndLabel.text = beginEnd;
}

@end
