//
//  RecordStatistics.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 02.03.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "RecordStatistics.h"
#import "Fieldtrip.h"
#import "Project.h"

@implementation RecordStatistics

#pragma mark - Model operations

+ (Fieldtrip *)recentSample {
    
    NSManagedObjectContext *managedObjectContext;
    NSError *error = nil;
    
    managedObjectContext = ApplicationDelegate.managedObjectContext;
    
    // count of all fieldtrips
    NSEntityDescription * entityDesc = [NSEntityDescription entityForName:@"Fieldtrip"
                                                   inManagedObjectContext:managedObjectContext];
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    [request setEntity:entityDesc];
    
    NSUInteger count = [managedObjectContext countForFetchRequest:request
                                                            error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    // limit the fetch request to one object
    [request setFetchLimit:1];
    
    // and set got through offset to the last object
    [request setFetchOffset:(count - 1)];
    
    NSArray *results = [managedObjectContext executeFetchRequest:request
                                                           error:&error];
    
    if (error) {
        NSLog(@"%@", [error localizedDescription]);
    }
    
    Fieldtrip *sample = [results firstObject];
    
    return sample;
}

+ (NSUInteger)sampleCount {

    return [RecordStatistics recordCount:@"Fieldtrip"];
}

+ (NSUInteger)markedSampleCount {
    
    NSPredicate *predicate;
    predicate = [NSPredicate predicateWithFormat:@"isMarked=YES"];
    
    return [RecordStatistics recordCount:@"Fieldtrip"
                           withPredicate:predicate];
}

+ (NSUInteger)fieldtripCount {
    
    return [RecordStatistics recordCount:@"Project"];
}

+ (NSUInteger)recordCount:(NSString *)entityForName {
    
    return [RecordStatistics recordCount:entityForName
                           withPredicate:nil];
}

+ (NSUInteger)recordCount:(NSString *)entityForName
            withPredicate:(NSPredicate *)predicate {

    NSManagedObjectContext *managedObjectContext;
    NSEntityDescription *entity;
    NSError *error = nil;
    
    managedObjectContext = ApplicationDelegate.managedObjectContext;
    
    // fieldtrips
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // Amount of samples (aka fieldtrips) in the request...
    entity = [NSEntityDescription entityForName:entityForName
                         inManagedObjectContext:managedObjectContext];
    
    [request setEntity:entity];

    if (predicate) {
        [request setPredicate:predicate];
    }
    
    NSUInteger recordCount;
    recordCount = [managedObjectContext countForFetchRequest:request
                                                       error:&error];
    return recordCount;
}

@end
