#ifndef Enums_h
#define Enums_h

/*!
 *  CoordinateFormat
 *
 *  @const kFwdCoordinateFormatGeodeticDecimal Common geodetic fromat in decimal degrees without degree sign with plus/minus notation. E.g. "+49.234,-0.345"
 *
 *  @todo: document when implemented
 *
 *  @since 1.0
 */
typedef enum CoordinateFormat : NSUInteger {
    kCoordinateFormatGeodeticDecimal,
    kCoordinateFormatGeodeticDegreesShort,
    kCoordinateFormatGeodeticDegreesLong,
    kCoordinateFormatMGRSShort,
    kCoordinateFormatMGRSLong,
    kCoordinateFormatUTMShort,
    kCoordinateFormatUTMLong
} CoordinateFormat;

/*!
 *  UnitOfLength
 *
 *  @since 1.0
 */
typedef enum UnitOfLength : NSUInteger {
    kUnitOfLengthMeter
} UnitOfLength;

/*!
 *  MapDatum
 *
 *  @since 1.0
 */
typedef enum MapDatum : NSUInteger {
    kMapDatumWGS1984,
    kMapDatumRT90,
    kMapDatumPotsdam
} MapDatum;

#define kNotificationDateUpdate                  @"update@date"
#define kNotificationPlacemarkUpdate             @"update@placemark"
#define kNotificationPlacemarkFailure            @"failure@placemark"
#define kNotificationLocationUpdate              @"update@location"
#define kNotificationLocationFailure             @"failure@location"
#define kNotificationSunriseSunsetTwilightUpdate @"update@SunriseSunsetTwilight"

typedef NSString*                       kNotification;

#endif
