//
//  Person.h
//  Fieldworksdiary
//
//  Created by Jo Brunner on 04.05.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Fieldtrip.h"
#import "Finding.h"
#import "Specimen.h"

@class Fieldtrip, Finding, Specimen;

@interface Person : NSManagedObject

@property (nonatomic, retain) NSString * addressBookId;
@property (nonatomic, retain) NSString * displayName;
@property (nonatomic, retain) NSString * firstName;
@property (nonatomic, retain) NSString * lastName;
@property (nonatomic, retain) NSString * middleName;
@property (nonatomic, retain) Specimen *collected;
@property (nonatomic, retain) Fieldtrip *defaultCollected;
@property (nonatomic, retain) Finding *determinded;

@end
