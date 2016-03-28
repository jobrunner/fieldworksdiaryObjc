//
//  ActiveDateSetting.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 27.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "ActiveDateSetting.h"

@implementation ActiveDateSetting

+ (void)setActiveAllday:(BOOL)allday {

    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    [preferences setBool:allday
                  forKey:kSampleDateIsAllday];
}

+ (BOOL)isActiveAllday {
    
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];

    return [preferences boolForKey:kSampleDateIsAllday];
}

@end
