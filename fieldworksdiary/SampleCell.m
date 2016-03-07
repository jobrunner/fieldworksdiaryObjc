//
//  FieldtripCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 28.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "Fieldtrip.h"
#import "Placemark.h"
#import "SampleCell.h"
#import "ActiveFieldtrip.h"

@interface SampleCell ()

@property (weak, nonatomic) IBOutlet UILabel *localityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *placemarkLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateDayLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateWeekdayLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateTimeLabel;
@property (weak, nonatomic) IBOutlet UILabel *identifierLabel;

@end

@implementation SampleCell

- (void)awakeFromNib {
    
    //configure right swipe buttons
    self.rightButtons = @[[MGSwipeButton buttonWithTitle:@"" // Delete, index = 1
                                                    icon:[UIImage imageNamed:@"trash"]
                                         backgroundColor:[UIColor redColor]
                                                 padding:28],
                          [MGSwipeButton buttonWithTitle:@""  // Mark, index = 2
                                                    icon:[UIImage imageNamed:@"star"]
                                         backgroundColor:[UIColor orangeColor]
                                                 padding:28],
                          [MGSwipeButton buttonWithTitle:@""  // More, index = 3
                                                    icon:[UIImage imageNamed:@"mail"]
                                         backgroundColor:[UIColor lightGrayColor]
                                                 padding:28]];
    self.rightSwipeSettings.transition = MGSwipeTransitionBorder;
}

- (void)configureWithModel:(NSManagedObject *)managedObject
               atIndexPath:(NSIndexPath *)indexPath
              withDelegate:(id)delegate {
    
    Fieldtrip *sample = (Fieldtrip *)managedObject;
    
    self.indexPath = indexPath;
    self.delegate = delegate;

    static UIColor *markedColor;
    static UIColor *tintColor;
    
    if (markedColor == nil) {
        markedColor = [UIColor orangeColor];
    }
    
    if (tintColor == nil) {
        tintColor = [UIColor colorWithRed:(4.0/255.0)
                                    green:(102.0/255.0)
                                     blue:(0.0/255.0)
                                    alpha:1.0];
    }
    
    _localityNameLabel.text = sample.localityName;
    _placemarkLabel.text = [Placemark stringFromPlacemark:[sample placemark]];
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    [dateFormatter setLocale:[NSLocale currentLocale]];
    [dateFormatter setTimeZone:sample.timeZone];
    
    [dateFormatter setDateFormat:@"dd"];
    
    _beginDateDayLabel.text = [dateFormatter stringFromDate:sample.beginDate];
    
    if ([sample.isMarked isEqual:@YES]) {
        _beginDateDayLabel.textColor = markedColor;
    }
    else {
        // tmp hack, because UIAppearance is still nil here.
        _beginDateDayLabel.textColor = tintColor;
    }
    
    [dateFormatter setDateFormat:@"EEEE"];
    _beginDateWeekdayLabel.text = [dateFormatter stringFromDate:sample.beginDate];
    
    [dateFormatter setDateStyle:NSDateFormatterNoStyle];
    [dateFormatter setTimeStyle:NSDateFormatterShortStyle];
    _beginDateTimeLabel.text = [dateFormatter stringFromDate:sample.beginDate];
    
    NSMutableString *identifier = [NSMutableString new];
    
    if (sample.specimenIdentifier != nil) {
        [identifier appendFormat:@"%@ ", sample.specimenIdentifier];
    }
    
    if (sample.localityIdentifier != nil) {
        [identifier appendFormat:@"(%@)", sample.localityIdentifier];
    }
    
    _identifierLabel.text = identifier;
}

@end
