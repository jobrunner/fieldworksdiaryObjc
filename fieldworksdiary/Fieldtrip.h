@class NSManagedObject;
@class CLLocation;
@class Image;
@class Person;
@class Project;
@class Specimen;
@class TimeZoneTransformer;
@class Placemark;

@class Fieldtrip, Image, Person, Project, Specimen;

@interface Fieldtrip : NSManagedObject

@property (nonatomic, retain) NSString *country;
@property (nonatomic, retain) NSString *countryCodeISO;
@property (nonatomic, retain) NSString *administrativeArea;
@property (nonatomic, retain) NSString *subAdministrativeArea;
@property (nonatomic, retain) NSString *administrativeLocality;
@property (nonatomic, retain) NSString *administrativeSubLocality;
@property (nonatomic, retain) NSNumber * altitude;
@property (nonatomic, retain) NSDate *beginDate;
@property (nonatomic, retain) NSDate *endDate;
@property (nonatomic, retain) NSNumber * horizontalAccuracy;
@property (nonatomic, retain) NSNumber * humidity;
@property (nonatomic, retain) NSString * inlandWater;
@property (nonatomic, retain) NSNumber * isFullTime;
@property (nonatomic, retain) NSNumber * isInDaylight;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSString * localityDescription;
@property (nonatomic, retain) NSString * localityIdentifier;
@property (nonatomic, retain) NSString * localityName;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * mapImageFilename;
@property (nonatomic, retain) NSString * ocean;
@property (nonatomic, retain) NSNumber * pressure;
@property (nonatomic, retain) NSString * sectionIdentifier;
@property (nonatomic, retain) NSString * specimenIdentifier;
@property (nonatomic, retain) NSString * specimenNotes;
@property (nonatomic, retain) NSDate * sunrise;
@property (nonatomic, retain) NSDate * sunset;
@property (nonatomic, retain) NSNumber * temperature;
@property (nonatomic, retain) NSTimeZone * timeZone;
@property (nonatomic, retain) NSDate * twilightBegin;
@property (nonatomic, retain) NSDate * twilightEnd;
@property (nonatomic, retain) NSNumber * verticalAccuracy;
@property (nonatomic, retain) Person *collector;
@property (nonatomic, retain) NSSet *findings;
@property (nonatomic, retain) NSSet *images;
@property (nonatomic, retain) Project *project;
@property (nonatomic, retain) NSSet *specimens;
@property (nonatomic, retain) NSDate * creationTime;
@property (nonatomic, retain) NSDate * updateTime;
@property (nonatomic, retain) NSNumber * version;
@property (nonatomic, retain) NSNumber * isMarked;
@property (nonatomic, retain) NSNumber * isAutoPlacemark;

@end

@interface Fieldtrip (CoreDataGeneratedAccessors)

- (void)addFindingsObject:(Fieldtrip *)value;
- (void)removeFindingsObject:(Fieldtrip *)value;
- (void)addFindings:(NSSet *)values;
- (void)removeFindings:(NSSet *)values;

- (void)addImagesObject:(Image *)value;
- (void)removeImagesObject:(Image *)value;
- (void)addImages:(NSSet *)values;
- (void)removeImages:(NSSet *)values;

- (void)addSpecimensObject:(Specimen *)value;
- (void)removeSpecimensObject:(Specimen *)value;
- (void)addSpecimens:(NSSet *)values;
- (void)removeSpecimens:(NSSet *)values;

// custom
- (void)createSectionIdentifier:(NSDate *)date;
- (Placemark *)placemark;
- (void)setPlacemark:(Placemark *)placemark;
- (CLLocation *)location;
- (CLLocation *)locationFromUndefined;
- (void)setLocation:(CLLocation *)location;
- (void)defaultsWithLocalityName:(NSString *)localityName;

@end
