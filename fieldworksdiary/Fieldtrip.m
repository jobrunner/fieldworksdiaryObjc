@import CoreData;
@import CoreLocation;

#import "Fieldtrip.h"
#import "Image.h"
#import "Person.h"
#import "Project.h"
#import "Specimen.h"
#import "TimeZoneTransformer.h"
#import "Placemark.h"
#import "ActiveFieldtrip.h"
#import "ActiveDateSetting.h"


@implementation Fieldtrip

@dynamic administrativeArea;
@dynamic subAdministrativeArea;
@dynamic administrativeLocality;
@dynamic administrativeSubLocality;
@dynamic altitude;
@dynamic beginDate;
@dynamic country;
@dynamic countryCodeISO;
@dynamic endDate;
@dynamic horizontalAccuracy;
@dynamic humidity;
@dynamic inlandWater;
@dynamic isFullTime;
@dynamic isInDaylight;
@dynamic latitude;
@dynamic localityDescription;
@dynamic localityIdentifier;
@dynamic localityName;
@dynamic longitude;
@dynamic mapImageFilename;
@dynamic ocean;
@dynamic pressure;
@dynamic sectionIdentifier;
@dynamic specimenIdentifier;
@dynamic specimenNotes;
@dynamic sunrise;
@dynamic sunset;
@dynamic temperature;
@dynamic timeZone;
@dynamic twilightBegin;
@dynamic twilightEnd;
@dynamic verticalAccuracy;
@dynamic collector;
@dynamic findings;
@dynamic images;
@dynamic project;
@dynamic specimens;
@dynamic creationTime;
@dynamic updateTime;
@dynamic version;
@dynamic isMarked;
@dynamic isAutoPlacemark;
@dynamic internalLocationId;


+ (void)initialize {
    
	if (self == [Fieldtrip class]) {
		TimeZoneTransformer *transformer = TimeZoneTransformer.new;
		[NSValueTransformer setValueTransformer:transformer
                                        forName:@"TimeZoneTransformer"];
	}
}

- (void)awakeFromInsert {

    [super awakeFromInsert];

    NSDate *date = NSDate.date;
    [self setPrimitiveValue:date forKey:@"creationTime"];
    [self setPrimitiveValue:date forKey:@"updateTime"];
}

- (void)willSave {
    
    [super willSave];

    if (self.isDeleted) {

        return;
    }
    
    NSDate *date = NSDate.date;
    
    [self setPrimitiveValue:date
                     forKey:@"updateTime"];
        
    [self setPrimitiveValue:self.version
                     forKey:@"version"];
}

#pragma mark - Transient properties

- (NSString *)sectionIdentifier {
    
    return [Fieldtrip createSectionIdentifier:self.beginDate];
}

- (void)setBeginDate:(NSDate *)beginDate {

    // If the beginDate changes,
    // the section identifier become invalid.
    [self willChangeValueForKey:@"beginDate"];
    [self setPrimitiveValue:beginDate forKey:@"beginDate"];
    [self didChangeValueForKey:@"beginDate"];
    [self setPrimitiveValue:nil forKey:@"sectionIdentifier"];
}

#pragma mark - Key path dependencies

+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier {
    
    NSLog(@"keyPathsForValuesAffectingSectionIdentifier is called. %@", [NSSet setWithObject:@"beginDate"]);
    
    // If the value of beginDate changes,
    // the section identifier may change as well.
    return [NSSet setWithObject:@"beginDate"];
}

#pragma mark - Shared Generators

+ (NSString *)createSectionIdentifier:(NSDate *)date {
    
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [calendar setTimeZone:timeZone];
    
    NSDateComponents * dateComponents;
    
    // Sections on year/month basis:
    
    dateComponents = [calendar components:NSCalendarUnitYear | NSCalendarUnitMonth
                                 fromDate:date];
    
    // 20140000 <= 2014
    // 20140400 <= April 2014
    long identifierValue = [dateComponents year] * 10000 + [dateComponents month] * 100;
    
    NSString * sectionIdentifier = [NSString stringWithFormat:@"%ld", identifierValue];
    
    return sectionIdentifier;
}

// wenn man placemark als transientes property aufnimmt, wäre das Caching "einfacherer".
// Ausserdem wäre es mit einer bestimmten Unschärfe der Koordinaten wunderbar, um einen
// Fundort- und einen Specimen-Hash daraus zu erstellen, sofern bei der Erstellung schon reichlich
// Daten vorhanden wären. Sehr experimentell!
// Nachteil: Zusammenbau von Einzeldaten verhindert die Trennung von Daten und Layout.

- (Placemark *)placemark {
    
    Placemark *placemark = [[Placemark alloc] init];

    [placemark setValue:self.country forKey:@"country"];
    [placemark setValue:self.countryCodeISO forKey:@"ISOcountryCode"];
    [placemark setValue:self.administrativeArea forKey:@"administrativeArea"];
    [placemark setValue:self.subAdministrativeArea forKey:@"subAdministrativeArea"];
    [placemark setValue:self.administrativeLocality forKey:@"locality"];
    [placemark setValue:self.administrativeSubLocality forKey:@"subLocality"];
    [placemark setValue:self.ocean forKey:@"ocean"];
    [placemark setValue:self.inlandWater forKey:@"inlandWater"];
    
    return placemark;
}

- (void)setPlacemark:(Placemark *)placemark {
    
    if (placemark == nil) {
        self.country = nil;
        self.countryCodeISO = nil;
        self.administrativeArea = nil;
        self.subAdministrativeArea = nil;
        self.administrativeLocality = nil;
        self.administrativeSubLocality = nil;

        self.ocean = nil;
        self.inlandWater = nil;
        
        return;
    }
    
    // Administrative/Political Informations
    self.country = placemark.country;
    self.countryCodeISO = placemark.ISOcountryCode;
    self.administrativeArea = placemark.administrativeArea;
    self.subAdministrativeArea = placemark.subAdministrativeArea;
    self.administrativeLocality = placemark.locality;
    self.administrativeSubLocality = placemark.subLocality;
    
    // Geographic Informations
    self.ocean = placemark.ocean;
    self.inlandWater = placemark.inlandWater;
    
    // Landmark Informations
    //             NSArray * areasOfInterest = [placemark areasOfInterest];
    //             CLRegion * region = [placemark region];
    //             NSString * regionIdentifier = [region identifier];
}

- (CLLocation *)location {
    
    if (self.latitude == nil || self.longitude == nil) {
        
        return nil;
    }
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake([self.latitude doubleValue],
                                                               [self.longitude doubleValue]);
    return [[CLLocation alloc] initWithCoordinate:coords
                                         altitude:[self.altitude doubleValue]
                               horizontalAccuracy:[self.horizontalAccuracy doubleValue]
                                 verticalAccuracy:[self.verticalAccuracy doubleValue]
                                        timestamp:self.beginDate];
}

- (void)setLocation:(CLLocation *)location {
    
    self.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    self.altitude = [NSNumber numberWithDouble:location.altitude];
    self.verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
    self.horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
}

// more defaults will be added in the feature
- (void)defaultsWithLocalityName:(NSString *)localityName {
    
    Project *fieldtrip = [ActiveFieldtrip activeFieldtrip];
    
    return [self defaultsWithLocalityName:localityName
                                fieldtrip:fieldtrip];
}

// Standard Data for Model
- (void)defaultsWithLocalityName:(NSString *)localityName
                       fieldtrip:(Project *)fieldtrip {
    
    self.localityName = localityName;
    self.localityIdentifier = fieldtrip.locationPrefix;
    
    // self.localityIdentifier = nil;
    
    if (YES) {
        self.beginDate = [NSDate date];
    }
    else {
        // Only for testing purposes
        int x = (arc4random() % (365 * 2)) - 365;
        self.beginDate = [[NSDate date] dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * (double)x];
    }
    
    // Eine Stunde als Standard-Endzeit => konfigurieren!!!
    self.endDate = [self.beginDate dateByAddingTimeInterval:60.0 * 60.0];
    
    // Standard: Keine Zeitintervall (anzeigen).
    self.isFullTime = @([ActiveDateSetting isActiveAllday]);
    self.isMarked = @NO;
    self.timeZone = [NSTimeZone systemTimeZone];
    self.latitude = nil;
    self.longitude = nil;
    self.horizontalAccuracy = nil;
    self.verticalAccuracy = nil;
    self.altitude = nil;
    self.version = @0;

    // must be searched from a fieldtrip/specimens collection
    // Important precaution here:
    // Prefixes must complain to the real world, not to the beginning date. That means
    // that in a night excursion from 2200 to 0500 o'clock the prefix should be equal.
    // In Settings, the user should be abled to change and overwrite behaviour here.
    // There is still a todo for the settings.
    
    // use hard coded here specimenIdentifier template <YYMMDD>#<Lf#>
    self.specimenIdentifier = [self specimenIdentifierByDate:self.beginDate];

    // verwirrend: project ist eigentlich fieldtrip und fieldtrip eigentlich sample...
    self.project = fieldtrip;
}

/*!
 * Creates a hard coded but handy "unique" specimen identifier <YYMMDD>/<Number>, e.g. 140503/1 when the trip is on 3rd May 2014 and the first probe/specimen. Here specimenIdentifierMajor is <YYMMDD> the specimenIdentifierMinor is <Number> and the specimenIdentifierTemplate is '<specimenIdentifierMajor>/<specimenIdentifierMinor>
   Supporting a simple location number on a fieldtrip of one month, use it without generation. E.g. "Fo 1".
 *
 */
- (NSString *)specimenIdentifierByDate:(NSDate *)date {
    
    // move start time from 0000 to 0630 "Fieldwork day begins at 06:30 o'clock local time (and ends 06:30 next day)"
    // => For me: all between 06:00 - 05:59 is one identifier prefix. But this must be in the settings!
    NSNumber *specimenPrefixLocalTime = [NSNumber numberWithInteger:630];
    
    NSEntityDescription *entity;
    NSError *error = nil;
    NSUInteger count = 0;
    
    // fieldtrips
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // {{{ Amount of fieldtrips in the request...
    // ugly: cannot be tested!
    entity = [NSEntityDescription entityForName:@"Fieldtrip"
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];

    long prefixHour = [specimenPrefixLocalTime longValue] / 100;
    long prefixMinute = [specimenPrefixLocalTime longValue] - prefixHour * 100;

    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay | NSCalendarUnitHour | NSCalendarUnitMinute;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    
    if (comps.hour >= prefixHour && comps.minute >= prefixMinute) {
        comps.hour = prefixHour;
    }
    else {
        // current time is after mindnight but before
        // end of fieldwork day that ends at prefixHour:prefixMinute
        comps.hour = prefixHour - 24;
    }

    comps.minute = prefixMinute;
    comps.second = 0;

    NSDate *rangeStart = [calendar dateFromComponents:comps];
    NSDate *rangeEnd = [rangeStart dateByAddingTimeInterval:60*60*24];

    request.predicate = [NSPredicate predicateWithFormat:@"beginDate >= %@ AND beginDate < %@", rangeStart, rangeEnd];
    
    count = [self.managedObjectContext countForFetchRequest:request
                                                      error:&error];
    // A newly created object will be in the counting
    NSNumber *indentifierNumber = [NSNumber numberWithLong:count];
    
    NSDateFormatter *indentifierPrefixFormatter = [[NSDateFormatter alloc] init];
    indentifierPrefixFormatter.dateFormat = @"yyMMdd";
    
    NSString *indentifierPrefix = [indentifierPrefixFormatter stringFromDate:rangeStart];
    
    return [NSString stringWithFormat:@"%@/%@", indentifierPrefix, indentifierNumber];
}

@end