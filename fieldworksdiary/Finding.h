//
//  Finding.h
//  sunrise
//
//  Created by Jo Brunner on 19.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Image.h"
#import "Person.h"
#import "Project.h"


@class Finding, Image, Person, Project;

@interface Finding : NSManagedObject

@property (nonatomic, retain) NSNumber * count;
@property (nonatomic, retain) NSNumber * countFemale;
@property (nonatomic, retain) NSNumber * countMale;
@property (nonatomic, retain) NSDate * detDate;
@property (nonatomic, retain) NSString * taxon;
@property (nonatomic, retain) Person *determinator;
@property (nonatomic, retain) Finding *fieldtrip;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Project *project;
@end

@interface Finding (CoreDataGeneratedAccessors)

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
