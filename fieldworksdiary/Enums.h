#ifndef Enums_h
#define Enums_h

/*!
 *  Supported CoordinateSystems
 *
 *  @since 1.0
 */
typedef enum CoordinateSystems : NSUInteger {
    kCoordinateSystemGeodetic,
    kCoordinateSystemMGRS,
    kCoordinateSystemUTM
} CoordinateSystems;

/*!
 *  Supported MapDatums
 *
 *  @since 1.0
 */
typedef enum MapDatums : NSInteger {
    kMapDatumWGS1984,
    kMapDatumRT90,
    kMapDatumPotsdam
} MapDatums;

/*!
 *  Supported CoordinateFormats
 *
 *  @const kFwdCoordinateFormatGeodeticDecimal Common geodetic format in decimal degrees without degree sign with plus/minus notation. E.g. "+49.234,-0.345"
 *
 *  @todo: document when implemented
 *
 *  @since 1.0
 */
typedef enum CoordinateFormats : NSUInteger {
    kCoordinateFormatGeodeticDecimalSign,
    kCoordinateFormatGeodeticDecimalDirection,
    kCoordinateFormatGeodeticDegreesSign,
    kCoordinateFormatGeodeticDegreesDirection,
    kCoordinateFormatGeodeticDegreesMinutesSign,
    kCoordinateFormatGeodeticDegreesMinutesDirection,
    kCoordinateFormatGeodeticDegreesMinutesSecondsSign,
    kCoordinateFormatGeodeticDegreesMinutesSecondsDirection,

    kCoordinateFormatMGRSDefault,
    kCoordinateFormatMGRSWithSpaces,
    
    kCoordinateFormatUTMWithGridZone,
    kCoordinateFormatUTMWithDirection
} CoordinateFormats;

/*!
 *  UnitOfLength
 *
 *  @since 1.0
 */
typedef enum UnitOfLength : NSInteger {
    kUnitOfLengthMeter = 0,
    kUnitOfLengthFoot = 1
} UnitOfLength;

/** Usage of FieldtripsController */
typedef enum FieldtripUsage : NSInteger {
    kFieldtripUsageDetails,
    kFieldtripUsagePicker,
    kFieldtripUsageSampleFilter
} FieldtripUsage;

/** Usage of SamplesController */
typedef enum SampleUsage : NSInteger {
    kSampleUsageDetails,
    kSampleUsageFilteredByMarked,
    kSampleUsageFilteredByFieldtrip
} SampleUsage;

/** Actions for action sheet */
typedef enum SampleActionSheet : NSInteger {
    kSampleActionSheetMore = 100,
    kSampleActionSheetRemove = 200,
    kSampleActionSheetMark = 300
} SampleActionSheet;

typedef enum SwipeIconPadding : NSInteger {
    kSwipeIconPadding = 28
} SwipeIconPadding;

#define kNotificationDateUpdate                  @"update@date"
#define kNotificationPlacemarkUpdate             @"update@placemark"
#define kNotificationPlacemarkFailure            @"failure@placemark"
#define kNotificationLocationUpdate              @"update@location"
#define kNotificationLocationFailure             @"failure@location"
#define kNotificationSunriseSunsetTwilightUpdate @"update@SunriseSunsetTwilight"
#define kNotificationFieldtripUpdate             @"update@fieldtrip"

typedef NSString*                       kNotification;

#endif
