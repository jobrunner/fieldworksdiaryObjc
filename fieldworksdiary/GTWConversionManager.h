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
#import <Foundation/Foundation.h>


@import CoreLocation;

NS_ASSUME_NONNULL_BEGIN

#define kGTWConversionUTMZone           @"zone"
#define kGTWConversionUTMHemisphere     @"hemisphere"
#define kGTWConversionUTMEasting        @"easting"
#define kGTWConversionUTMNorthing       @"northing"
#define kGTWConversionMGRSString        @"mgrs"
#define kGTWConversionGeodeticLatitude  @"latitude"
#define kGTWConversionGeodeticLongitude @"longitude"

#define kGTWErrorDomain                 @"GTWErrorDomain"


/*
*          MGRS_NO_ERROR          : No errors occurred in function
*          MGRS_LAT_ERROR         : Latitude outside of valid range
*                                    (-90 to 90 degrees)
*          MGRS_LON_ERROR         : Longitude outside of valid range
*                                    (-180 to 360 degrees)
*          MGRS_STR_ERROR         : An MGRS string error: string too long,
*                                    too short, or badly formed
*          MGRS_PRECISION_ERROR   : The precision must be between 0 and 5
*                                    inclusive.
*          MGRS_A_ERROR           : Semi-major axis less than or equal to zero
*          MGRS_INV_F_ERROR       : Inverse flattening outside of valid range
*									                  (250 to 350)
*          MGRS_EASTING_ERROR     : Easting outside of valid range
*                                    (100,000 to 900,000 meters for UTM)
*                                    (0 to 4,000,000 meters for UPS)
*          MGRS_NORTHING_ERROR    : Northing outside of valid range
*                                    (0 to 10,000,000 meters for UTM)
*                                    (0 to 4,000,000 meters for UPS)
*          MGRS_ZONE_ERROR        : Zone outside of valid range (1 to 60)
*          MGRS_HEMISPHERE_ERROR  : Invalid hemisphere ('N' or 'S')
*/



typedef void (^ _Nullable GTWConversionCompletionHandler)(NSDictionary * __nullable result,
                                                          NSError * __nullable error);
@interface GTWConversionManager : NSObject

- (NSString *)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                                precision:(NSUInteger)precision
                         formatWithSpaces:(BOOL)spaces
                                    error:(NSError **)error;

- (NSString *)utmWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                      formatWithGridZone:(BOOL)spaces
                                   error:(NSError **)error;

- (void)utmWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                 completionHandler:(nullable GTWConversionCompletionHandler)completionBlock;

- (void)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                  completionHandler:(nullable GTWConversionCompletionHandler)completionBlock;

- (void)mgrsWithLocationCoordinates:(CLLocationCoordinate2D)coordinates
                          precision:(NSUInteger)precision
                  completionHandler:(nullable GTWConversionCompletionHandler)completionBlock;

- (void)mgrsWithLatitute:(nonnull NSNumber *)latitude
               longitude:(nonnull NSNumber *)longitude
               precision:(NSInteger)precision
       completionHandler:(nullable GTWConversionCompletionHandler)completionBlock;

//- (void)configureMgrsMajorAxis:(double)a
//                    flattening:(double)f
//                 ellipsoidCode:(NSString *)code
//                         error:(NSError **)error;

- (nonnull NSDictionary *)mgrsParameters;

@end

NS_ASSUME_NONNULL_END
