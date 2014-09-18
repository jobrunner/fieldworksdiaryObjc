//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>
//#import "Fieldtrip.h"
//#import "Finding.h"
//#import "Specimen.h"


@class Fieldtrip, Finding, Image, Specimen;

@interface Image : NSManagedObject

@property (nonatomic, retain) NSString * filename;
@property (nonatomic, retain) NSNumber * type;
@property (nonatomic, retain) NSDate * created;
@property (nonatomic, retain) Fieldtrip *fieldtrip;
@property (nonatomic, retain) Finding *finding;
@property (nonatomic, retain) Specimen *specimen;
@property (nonatomic, retain) Image *representations;

@end
