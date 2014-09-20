@import CoreData;
@import CoreLocation;

#import "Fieldtrip.h"
#import "Image.h"
#import "Person.h"
#import "Project.h"
#import "Specimen.h"
#import "TimeZoneTransformer.h"
#import "Placemark.h"


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
@dynamic localityMajorId;
@dynamic localityMinorId;
@dynamic localityName;
@dynamic localityPrefixId;
@dynamic longitude;
@dynamic mapImageFilename;
@dynamic ocean;
@dynamic pressure;
@dynamic sectionIdentifier;
@dynamic specimenIdentifier;
@dynamic specimenMajorId;
@dynamic specimenMinorId;
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


+ (void)initialize
{
	if (self == [Fieldtrip class]) {
		TimeZoneTransformer *transformer = [[TimeZoneTransformer alloc] init];
		[NSValueTransformer setValueTransformer:transformer
                                        forName:@"TimeZoneTransformer"];
	}
}


#pragma mark - Transient properties


- (NSString *)sectionIdentifier
{
    NSString *sectionIdentifier = [Fieldtrip createSectionIdentifier:self.beginDate];
    return sectionIdentifier;
    
    
//    // Create and cache the section identifier on demand.
//    [self willAccessValueForKey:@"sectionIdentifier"];
//    
//    // liefert vor dem ersten Aufruf bereits nicht nil, sondern den Inhalt von administrativeLebel! ?!
//    NSString *sectionIdentifier = [self primitiveValueForKey:@"sectionIdentifier"];
//    [self didAccessValueForKey:@"sectionIdentifier"];
//    // End of
//
//    if (sectionIdentifier == nil) {
    
        
        
        
        // Sections are organized by month and year.
        // Create the section identifier as a string
        // representing the number (year * 1000) + month;
        // this way they will be correctly ordered chronologically
        // regardless of the actual name of the month.
        NSCalendar *calendar = [NSCalendar currentCalendar];
        NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
        
        [calendar setTimeZone:timeZone];
        
        NSDateComponents * dateComponents;
        
        // Sections on year/month basis:
        dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit
                                     fromDate:self.beginDate];
        
        // 20140000 <= 2014
        // 20140400 <= April 2014
        long identifierValue = [dateComponents year] * 10000 + [dateComponents month] * 100;
        
        sectionIdentifier = [NSString stringWithFormat:@"%ld", identifierValue];
        
        [self setPrimitiveValue:sectionIdentifier forKey:@"sectionIdentifier"];

        NSLog(@"Returning sectionIdentifier: %@", sectionIdentifier);
//    } else {
//        NSLog(@"Rückgabe eines gecacheter sectionIdentifier: %@", sectionIdentifier);
//    }
    

    return sectionIdentifier;
}


// Mir ist noch nicht ganz klar, ob ich das wirklich brauche!
// Außerdem verstehe ich es noch nicht.
- (void)setBeginDate:(NSDate *)beginDate
{
    // If the beginDate changes,
    // the section identifier become invalid.
    [self willChangeValueForKey:@"beginDate"];
    [self setPrimitiveValue:beginDate forKey:@"beginDate"];
    [self didChangeValueForKey:@"beginDate"];
    [self setPrimitiveValue:nil forKey:@"sectionIdentifier"];
}


#pragma mark - Key path dependencies


+ (NSSet *)keyPathsForValuesAffectingSectionIdentifier
{
    NSLog(@"keyPathsForValuesAffectingSectionIdentifier is called. %@", [NSSet setWithObject:@"beginDate"]);
    // If the value of beginDate changes,
    // the section identifier may change as well.
    return [NSSet setWithObject:@"beginDate"];
}


#pragma mark - Shared Generators

+ (NSString *)createSectionIdentifier:(NSDate *)date
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSTimeZone *timeZone = [NSTimeZone systemTimeZone];
    
    [calendar setTimeZone:timeZone];
    
    NSDateComponents * dateComponents;
    
    // Sections on year/month basis:
    dateComponents = [calendar components:NSYearCalendarUnit | NSMonthCalendarUnit
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

- (Placemark *)placemark
{
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

- (void)setPlacemark:(Placemark *)placemark
{
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


- (CLLocation *)location
{
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

- (void)setLocation:(CLLocation *)location
{
    self.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
    self.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    self.altitude = [NSNumber numberWithDouble:location.altitude];
    self.verticalAccuracy = [NSNumber numberWithDouble:location.verticalAccuracy];
    self.horizontalAccuracy = [NSNumber numberWithDouble:location.horizontalAccuracy];
//    self.locationTimestamp = [NSNumber numberWithDouble:location.timestamp];
}


// Standard Data for Model
- (void)defaultsWithLocalityName:(NSString *)localityName
{
    //    self.fieldtrip.localityName = [NSString stringWithFormat:@"Fundort #%ul", (unsigned int)self.fieldtripCount];
    self.localityName = localityName;
    
    if (YES) {
        self.beginDate = [NSDate date];
        
    } else {
        int x = (arc4random() % (365 * 2)) - 365;
        self.beginDate = [[NSDate date] dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * (double)x];
    }
    
    // Eine Stunde als Standard-Endzeit => konfigurieren!!!
    self.endDate = [self.beginDate dateByAddingTimeInterval:60.0 * 60.0];
    
    // Standard: Keine Zeitintervall (anzeigen).
    self.isFullTime = NO;
    
    self.timeZone = [NSTimeZone systemTimeZone];
    
    self.latitude = nil;
    self.longitude = nil;
    self.horizontalAccuracy = nil;
    self.verticalAccuracy = nil;
    self.altitude = nil;

    NSDateFormatter *specifierPrefixFormatter = [[NSDateFormatter alloc] init];
    specifierPrefixFormatter.dateFormat = @"yyMMdd";
    
    NSString *specifierPrefix = [specifierPrefixFormatter stringFromDate:self.beginDate];

    // must be searched from a fieldtrip/specimens collection
    // Important precaution here:
    // Prefixes must complain to the real world, not to the beginning date. That means
    // that in a night excursion from 2200 to 0500 o'clock the prefix should be equal.
    // In Settings, the user should be abled to change and overwrite behaviour here
    NSNumber * specifierNumber = [self specimenIdentifierByDate:self.beginDate];
    
    // specimenIdentifier template
    self.specimenIdentifier = [NSString stringWithFormat:@"%@#%@", specifierPrefix, specifierNumber];
    
    
    // ...
}

- (NSNumber *)specimenIdentifierByDate:(NSDate *)date
{
    NSEntityDescription *entity;
    NSError *error = nil;
    NSUInteger count = 0;
    
    // fieldtrips
    NSFetchRequest *request = [[NSFetchRequest alloc] init];
    
    // {{{ Amount of fieldtrips in the request...
    entity = [NSEntityDescription entityForName:@"Fieldtrip"
                         inManagedObjectContext:self.managedObjectContext];
    [request setEntity:entity];

    // todo: cache Components
    // todo: make and read user configuration for timeslots within a speciefier prefix equals
    
    unsigned unitFlags = NSCalendarUnitYear | NSCalendarUnitMonth |  NSCalendarUnitDay;
    NSCalendar *calendar = [NSCalendar currentCalendar];
    NSDateComponents *comps = [calendar components:unitFlags fromDate:date];
    comps.hour   = 0;
    comps.minute = 0;
    comps.second = 0;

    // assuming current specimens-number has the range 00:00 until 23:59
    NSDate *rangeStart = [calendar dateFromComponents:comps];
    NSDate *rangeEnd = [rangeStart dateByAddingTimeInterval:60*60*24];

//    NSLog(@"rangeStart: %@", rangeStart);
//    NSLog(@"rangeEnd: %@", rangeEnd);
    
    request.predicate = [NSPredicate predicateWithFormat:@"beginDate >= %@ AND beginDate < %@", rangeStart, rangeEnd];
    
    count = [self.managedObjectContext countForFetchRequest:request
                                                      error:&error];

    return [NSNumber numberWithLong:count + 1];
}

@end
