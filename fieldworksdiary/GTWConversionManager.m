//
// Simple Objective-C wrapper to GeoTrans from National Geospatial-Intelligence Agency (NGA)
// The wrapper currently uses conversion only between geodetic, utm and mgrs coordinates
// and therefor needed modules from GeoTrans version 2.4.2 are used: mgrs, utm, ups, polarst and tranmerc.
//
// Wrapper is Copyright © 2016 Jo Brunner.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//
@import CoreLocation;
@import GLKit;

#import "GTWConversionManager.h"
#import "mgrs.h"
#import "utm.h"
#import "mgrsext.h"

@implementation GTWConversionManager

- (void)utmWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                 completionHandler:(nullable GTWConversionCompletionHandler)completionBlock {
    
    long   zone;
    char   hemisphere[1];
    double easting;
    double northing;
    
    double lat = GLKMathDegreesToRadians(coordinates.latitude);
    double lon = GLKMathDegreesToRadians(coordinates.longitude);
    long   err = Convert_Geodetic_To_UTM(lat, lon, &zone, hemisphere, &easting, &northing);

    NSDictionary *result;
    NSError *error;
    
    if (!err) {
        result = @{@"zone":@(zone),
                   @"hemisphere":@(hemisphere),
                   @"easting":@(easting),
                   @"northing":@(northing)};
        error = nil;
    }
    else {
        result = nil;
        error  = [NSError errorWithDomain:@"GeotransErrorDomain"
                                     code:err
                                 userInfo:nil];
    }
    
    completionBlock(result, error);
}

/**
 * Converts latitutde, longitude into UTM format.
 * No black api method.
 */
- (NSString *)utmWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                      formatWithGridZone:(BOOL)formatWithGridZone
                                   error:(NSError **)error {

    long   zone;
    char   hemisphere[1];
    double easting;
    double northing;

    double lat = GLKMathDegreesToRadians(coordinates.latitude);
    double lon = GLKMathDegreesToRadians(coordinates.longitude);
    long   err = Convert_Geodetic_To_UTM(lat, lon, &zone, hemisphere, &easting, &northing);
  
    if (UTM_NO_ERROR == err) {
        error  = nil;

        NSString *utmString;
        
        if (YES == formatWithGridZone) {

            int letters[3];
            char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            err = Get_Latitude_Letter(lat, &letters[0]);
            if (!err) {
                char letter = alphabet[letters[0]];
            
                NSString *zoneLetter = @(&letter);

                utmString = [NSString stringWithFormat:@"%@%@ %ld %ld",
                             @(zone),
                             zoneLetter,
                             (long)easting,
                             (long)northing];
                return utmString;
            }
        }
        else {
            NSString *hemisphereLetter = @(hemisphere);
            NSString *hemisphereLong = [hemisphereLetter isEqualToString:@"N*"] ? @"North" : @"South";
            
            utmString = [NSString stringWithFormat:@"%@%@ %ld %ld",
                         @(zone),
                         hemisphereLong,
                         (long)easting,
                         (long)northing];
            return utmString;
        }
    }
    
    NSDictionary *userInfo;
    
    if ((UTM_LAT_ERROR == (UTM_LAT_ERROR & err)) || MGRS_LAT_ERROR == (MGRS_LAT_ERROR & err)) {
        userInfo =
        @{
          NSLocalizedDescriptionKey:NSLocalizedString(@"Conversion into UTM was unsuccessful.", nil),
          NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Latitude outside of valid range.", nil),
          NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Is latitude inside -90 to 90 degrees?", nil)
          };
    }
    else if (UTM_LON_ERROR == (UTM_LON_ERROR & err)) {
        userInfo =
        @{
          NSLocalizedDescriptionKey:NSLocalizedString(@"Conversion into UTM was unsuccessful.", nil),
          NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Longitude outside of valid range.", nil),
          NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Is longitude inside -180 to 360 degrees?", nil)
          };
    }
    else {
        userInfo = nil;
    }
    
    *error = [NSError errorWithDomain:kGTWErrorDomain
                                 code:err
                             userInfo:userInfo];
    return @"";
}

- (void)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                  completionHandler:(nullable GTWConversionCompletionHandler)completionBlock {

    [self mgrsWithLocationCoordinates:coordinates
                            precision:5
                    completionHandler:completionBlock];
}

- (void)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                          precision:(NSUInteger)precision
                  completionHandler:(nullable GTWConversionCompletionHandler)completionBlock {

    double lat = GLKMathDegreesToRadians(coordinates.latitude);
    double lon = GLKMathDegreesToRadians(coordinates.longitude);
    
    char mgrs[16];
    long err = Convert_Geodetic_To_MGRS(lat, lon, precision, mgrs);
    
    NSDictionary *result;
    NSError *error;
    
    if (!err) {
        result = @{kGTWConversionMGRSString:@(mgrs)};
        error  = nil;
    }
    else {
        result = nil;
        error  = [NSError errorWithDomain:@"GeotransErrorDomain"
                                     code:err
                                 userInfo:nil];
    }
    
    completionBlock(result, error);
}
 
// ohne block api:
// in doing.
// INPUT: coordinaten + coordinatenSystem
// OUTPUT: NSDictionary mit allen Komponenten zur späteren Formattierung
- (NSString *)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                                precision:(NSUInteger)precision
                         formatWithSpaces:(BOOL)spaces
                                    error:(NSError **)error {
    
    double lat = GLKMathDegreesToRadians(coordinates.latitude);
    double lon = GLKMathDegreesToRadians(coordinates.longitude);
    
    char mgrs[16];
    long err = Convert_Geodetic_To_MGRS(lat, lon, precision, mgrs);
    
    if (MGRS_NO_ERROR == err) {
        error  = nil;

        // immer durchführen, um an die Komponenten zu kommen:
        if (YES == spaces) {

            // workaround
            long Zone;
            double Easting;
            double Northing;
            long letters[3];
            long in_precision;
            
            Break_MGRS_String(mgrs, &Zone, letters, &Easting, &Northing, &in_precision);
            
            char alphabet[] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            char zoneLetter = alphabet[letters[0]];
            char gridLowerLetter = alphabet[letters[1]];
            char gridHigherLetter = alphabet[letters[2]];

            NSString *mgrsWithSpaces = [NSString stringWithFormat:@"%ld%c %c%c %ld %ld",
                                        (long)Zone,
                                        zoneLetter,
                                        gridLowerLetter,
                                        gridHigherLetter,
                                        (long)Easting,
                                        (long)Northing];
            return mgrsWithSpaces;
        }
        
        return @(mgrs);
    }
    
    NSDictionary *userInfo;
        
    if (MGRS_LAT_ERROR == (MGRS_LAT_ERROR & err)) {
        userInfo =
        @{
            NSLocalizedDescriptionKey:NSLocalizedString(@"Conversion into MGRS was unsuccessful.", nil),
            NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Latitude outside of valid range.", nil),
            NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Is latitude inside -90 to 90 degrees?", nil)
        };
    }
    else if (MGRS_LON_ERROR == (MGRS_LON_ERROR & err)) {
        userInfo =
        @{
            NSLocalizedDescriptionKey:NSLocalizedString(@"Conversion into MGRS was unsuccessful.", nil),
            NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Longitude outside of valid range.", nil),
            NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Is longitude inside -180 to 360 degrees?", nil)
        };
    }
    else if (MGRS_PRECISION_ERROR == (MGRS_PRECISION_ERROR & err)) {
        userInfo =
        @{
            NSLocalizedDescriptionKey:NSLocalizedString(@"Conversion into MGRS was unsuccessful.", nil),
            NSLocalizedFailureReasonErrorKey:NSLocalizedString(@"Precision outside of valid range.", nil),
            NSLocalizedRecoverySuggestionErrorKey:NSLocalizedString(@"Is precision between 0 and 5 inclusive?", nil)
        };

    }
    else {
        userInfo = nil;
    }

    *error = [NSError errorWithDomain:kGTWErrorDomain
                                 code:err
                             userInfo:userInfo];
    return nil;
}



- (void)mgrsWithLatitute:(NSNumber *)latitude
               longitude:(NSNumber *)longitude
               precision:(NSInteger)precision
       completionHandler:(GTWConversionCompletionHandler)completionBlock {
    
    CLLocationCoordinate2D coords = CLLocationCoordinate2DMake(latitude.doubleValue,
                                                               longitude.doubleValue);
    [self mgrsWithLocationCoordinates:coords
                            precision:precision
                    completionHandler:completionBlock];
}

- (void)configureMgrsMajorAxis:(double)a
                    flattening:(double)f
                 ellipsoidCode:(NSString *)code
                         error:(NSError **)error {

    const char *c = [code UTF8String];
    
    long err = Set_MGRS_Parameters(a, f, strdup(c));
    
    if (!err) {
        *error = nil;
    }
    else {
        *error = [NSError errorWithDomain:@"GeotransErrorDomain"
                                        code:err
                                     userInfo:nil];
    }
}

- (NSDictionary *)mgrsParameters {

    double a;
    double f;
    char Ellipsoid_Code[2];
    Get_MGRS_Parameters(&a, &f, Ellipsoid_Code);

    return @{@"a":@(a),
             @"f":@(f),
             @"Ellipsoid_Code":@(Ellipsoid_Code)};
}

@end
