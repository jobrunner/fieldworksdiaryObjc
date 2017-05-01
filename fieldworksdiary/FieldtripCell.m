//
//  FieldtripCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "FieldtripCell.h"
#import "ActiveFieldtrip.h"
#import "DateUtility.h"

@interface FieldtripCell ()

@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginEndLabel;

@end

@implementation FieldtripCell

- (void)awakeFromNib {

    [super awakeFromNib];
    
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
    
    // Tint selected item or check it or...
    static UIColor *tintColor;
    
    // read tintColor. This is a hack...
    if (tintColor == nil) {
        tintColor = [UIColor colorWithRed:(4.0/255.0)
                                    green:(102.0/255.0)
                                     blue:(0.0/255.0)
                                    alpha:1.0];
    }
    
    static UIColor *textColor;
    if (textColor == nil) {
        textColor = [UIColor colorWithRed:(0.0/255.0)
                                    green:(00./255.0)
                                     blue:(0.0/255.0)
                                    alpha:1.0];
    }
    
    self.indexPath = indexPath;
    self.nameLabel.text = [managedObject valueForKey:@"name"];
    self.delegate = delegate;
    BOOL isActive = [ActiveFieldtrip isActive:(Project *)managedObject];
    
    if (selectorOnly) {
        self.accessoryType = UITableViewCellAccessoryNone;
        if (isActive) {
            self.accessoryType = UITableViewCellAccessoryCheckmark;
        }
        else {
            self.accessoryType = UITableViewCellAccessoryNone;
        }
        self.nameLabel.textColor = textColor;
    }
    else {
        if (isActive) {
            self.nameLabel.textColor = tintColor;
        }
        else {
            self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            self.nameLabel.textColor = textColor;
        }
    }
    
    NSDate *beginDate = [managedObject valueForKey:@"beginDate"];
    NSDate *endDate = [managedObject valueForKey:@"endDate"];
    
    self.beginEndLabel.text = [DateUtility formattedBeginDate:beginDate
                                                      endDate:endDate
                                                       allday:YES];
}

@end
