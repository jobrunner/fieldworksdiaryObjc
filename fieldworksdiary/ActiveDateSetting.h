//
//  ActiveDateSetting.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 27.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>

#define kSampleDateIsAllday @"sampleDateIsAllday"

@interface ActiveDateSetting : NSObject

+ (void)setActiveAllday:(BOOL)allday;
+ (BOOL)isActiveAllday;

@end
