//
//  ActiveFieldtrip.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//
#import <Foundation/Foundation.h>

@class Project;

@interface ActiveFieldtrip : NSObject

+ (NSString *)name;
+ (Project *)activeFieldtrip;
+ (void)setActiveFieldtrip:(Project *)fieldtrip;
+ (BOOL)isActive:(Project *)fieldtrip;

@end
