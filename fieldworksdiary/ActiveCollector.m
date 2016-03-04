//
//  ActiveCollectors.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "ActiveCollector.h"

@implementation ActiveCollector

NSString *userDefaultsKey = kActiveCollectorUserDefaultsKey;

+ (NSString *)name {

    NSString * activeCollector = [ActiveCollector activeCollector];
    
    return (activeCollector != nil) ? activeCollector : NSLocalizedString(@"-", @"no active collector");
}

+ (NSString *)activeCollector {
    
    // getting the collector back
    return [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsKey];
}

+ (void)setActiveCollector:(NSString *)collector {
    
    [[NSUserDefaults standardUserDefaults] setObject:collector
                                              forKey:userDefaultsKey];
}

+ (BOOL)isActive:(NSString *)collector {

    NSString *activeCollector = [ActiveCollector activeCollector];
    
    return [collector isEqualToString:activeCollector];
}

@end
