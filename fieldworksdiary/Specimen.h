//#import <Foundation/Foundation.h>
//#import <CoreData/CoreData.h>
//#import "CollectingMethod.h"
//#import "Fieldtrip.h"
//#import "Image.h"
//#import "Person.h"
//#import "Project.h"
//#import "Specimen.h"

@class CollectingMethod, Fieldtrip, Image, Person, Project, Specimen;

@interface Specimen : NSManagedObject

@property (nonatomic, retain) NSString * administrativeArea;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSDate * beginDate;
@property (nonatomic, retain) NSString * country;
@property (nonatomic, retain) NSString * countryCodeISO;
@property (nonatomic, retain) NSDate * endDate;
@property (nonatomic, retain) NSNumber * horizontalAccuracy;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSString * inlandWater;
@property (nonatomic, retain) NSNumber * isFullTime;
@property (nonatomic, retain) NSNumber * isInDaylight;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * localityDescription;
@property (nonatomic, retain) NSString * localityMajorId;
@property (nonatomic, retain) NSString * localityMinorId;
@property (nonatomic, retain) NSString * localityName;
@property (nonatomic, retain) NSString * localityPrefixId;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * mapImageFilename;
@property (nonatomic, retain) NSString * ocean;
@property (nonatomic, retain) NSString * politicalLocality;
@property (nonatomic, retain) NSString * politicalSubLocality;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) NSString * specimenIdentifier;
@property (nonatomic, retain) NSString * specimenNotes;
@property (nonatomic, retain) NSString * subAdministrativeArea;
@property (nonatomic, retain) NSDate * sunrise;
@property (nonatomic, retain) NSDate * sunset;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSTimeZone * timeZone;
@property (nonatomic, retain) NSDate * twilightBegin;
@property (nonatomic, retain) NSDate * twilightEnd;
@property (nonatomic, retain) NSNumber * verticalAccuracy;
@property (nonatomic, retain) CollectingMethod *collectingMethod;
@property (nonatomic, retain) Person *collector;
@property (nonatomic, retain) Fieldtrip *fieldtrip;
@property (nonatomic, retain) NSSet *findings;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Project *project;
@end

@interface Specimen (CoreDataGeneratedAccessors)

- (void)addFindingsObject:(Specimen *)value;
- (void)removeFindingsObject:(Specimen *)value;
- (void)addFindings:(NSSet *)values;
- (void)removeFindings:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

@end
