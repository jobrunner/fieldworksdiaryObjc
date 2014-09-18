#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Finding.h"

@class Finding;

@interface Collection : NSManagedObject

@property (nonatomic, retain) NSString * longName;
@property (nonatomic, retain) NSString * shortName;
@property (nonatomic, retain) Finding *findings;

@end
