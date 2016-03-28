//
//  ActiveFieldtrip.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 01.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "ActiveFieldtrip.h"
#import "Project.h"

@implementation ActiveFieldtrip

- (void)initWithFieldtrip:(Project *)fieldtrip {
    
}

+ (NSString *)name {
    
    Project * activeFieldtrip = [ActiveFieldtrip activeFieldtrip];

    return (activeFieldtrip != nil) ? activeFieldtrip.name : NSLocalizedString(@"-", @"no active fieldtrip");
}

+ (Project *)activeFieldtrip {
    
    // getting the fieldtrip back from objectId url
    NSURL *fieldtripUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kActiveFieldtrip]];
    
    NSManagedObjectContext *managedObjectContext = [ApplicationDelegate managedObjectContext];
    NSPersistentStoreCoordinator *persistentStoreCoordinator = [managedObjectContext persistentStoreCoordinator];
    NSManagedObjectID *fieldtripID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:fieldtripUrl];

    if (fieldtripID == nil) {
        
        return nil;
    }
    
    NSError *error = nil;
    Project *fieldtrip = (Project *)[managedObjectContext existingObjectWithID:fieldtripID
                                                                         error:&error];
    return fieldtrip;
}

+ (void)setActiveFieldtrip:(Project *)fieldtrip {

    [[NSUserDefaults standardUserDefaults] setObject:[[self URLFromFieldtrip:fieldtrip] absoluteString]
                                              forKey:kActiveFieldtrip];
}

+ (BOOL)isActive:(Project *)fieldtrip {
    
    NSURL *fieldtripUrl = [self URLFromFieldtrip:fieldtrip];
    NSURL *activeFieldtripUrl = [self activeFieldtripUrl];
    
    return [fieldtripUrl isEqual:activeFieldtripUrl];
}

+ (NSURL *)activeFieldtripUrl {

    return [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:kActiveFieldtrip]];
}

+ (NSURL *)URLFromFieldtrip:(Project *)fieldtrip {
    
    return [[fieldtrip objectID] URIRepresentation];
}

@end
