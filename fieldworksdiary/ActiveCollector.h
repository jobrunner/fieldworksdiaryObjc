//
//  ActiveCollectors.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ActiveCollector : NSObject

+ (NSString *)name;
+ (NSString *)activeCollector;
+ (void)setActiveCollector:(NSString *)collector;
+ (BOOL)isActive:(NSString *)collector;

@end
