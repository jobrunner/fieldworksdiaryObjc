//
//  Formatter.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 05.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "Formatter.h"

@implementation Formatter

- (NSString *)counter:(NSUInteger)count {
    
    static NSNumberFormatter *formatter;
    
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    }
    
    return [formatter stringFromNumber:[NSNumber numberWithInteger:count]];
}

- (NSNumberFormatter *)geodeticDecimalFormatter {
    
    static NSNumberFormatter *formatter;
    
    if (!formatter) {
        formatter = [[NSNumberFormatter alloc] init];
        formatter.locale = [NSLocale currentLocale];
        formatter.numberStyle = NSNumberFormatterDecimalStyle;
        formatter.alwaysShowsDecimalSeparator = NO;
        formatter.usesGroupingSeparator = NO;
        formatter.usesSignificantDigits = false;
        formatter.minimumFractionDigits = 6;
        formatter.maximumFractionDigits = 12;
    }

    return formatter;
}

@end
