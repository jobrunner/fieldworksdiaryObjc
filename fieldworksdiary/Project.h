
//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>
//#import "Fieldtrip.h"
//#import "Finding.h"
//#import "Specimen.h"


@class Fieldtrip, Finding, Specimen;

@interface Project : NSManagedObject

@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * isDefaultProject;
@property (nonatomic, retain) NSString * notes;
@property (nonatomic, retain) NSString * projectId;
@property (nonatomic, retain) NSString * projectLongName;
@property (nonatomic, retain) NSString * projectPrefixId;
@property (nonatomic, retain) NSString * projectShortName;
@property (nonatomic, retain) NSOrderedSet *fieldtrips;
@property (nonatomic, retain) NSOrderedSet *findings;
@property (nonatomic, retain) NSOrderedSet *specimens;
@end

@interface Project (CoreDataGeneratedAccessors)

- (void)insertObject:(Fieldtrip *)value inFieldtripsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFieldtripsAtIndex:(NSUInteger)idx;
- (void)insertFieldtrips:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFieldtripsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFieldtripsAtIndex:(NSUInteger)idx withObject:(Fieldtrip *)value;
- (void)replaceFieldtripsAtIndexes:(NSIndexSet *)indexes withFieldtrips:(NSArray *)values;
- (void)addFieldtripsObject:(Fieldtrip *)value;
- (void)removeFieldtripsObject:(Fieldtrip *)value;
- (void)addFieldtrips:(NSOrderedSet *)values;
- (void)removeFieldtrips:(NSOrderedSet *)values;
- (void)insertObject:(Finding *)value inFindingsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFindingsAtIndex:(NSUInteger)idx;
- (void)insertFindings:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFindingsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFindingsAtIndex:(NSUInteger)idx withObject:(Finding *)value;
- (void)replaceFindingsAtIndexes:(NSIndexSet *)indexes withFindings:(NSArray *)values;
- (void)addFindingsObject:(Finding *)value;
- (void)removeFindingsObject:(Finding *)value;
- (void)addFindings:(NSOrderedSet *)values;
- (void)removeFindings:(NSOrderedSet *)values;
- (void)insertObject:(Specimen *)value inSpecimensAtIndex:(NSUInteger)idx;
- (void)removeObjectFromSpecimensAtIndex:(NSUInteger)idx;
- (void)insertSpecimens:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeSpecimensAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInSpecimensAtIndex:(NSUInteger)idx withObject:(Specimen *)value;
- (void)replaceSpecimensAtIndexes:(NSIndexSet *)indexes withSpecimens:(NSArray *)values;
- (void)addSpecimensObject:(Specimen *)value;
- (void)removeSpecimensObject:(Specimen *)value;
- (void)addSpecimens:(NSOrderedSet *)values;
- (void)removeSpecimens:(NSOrderedSet *)values;
@end
