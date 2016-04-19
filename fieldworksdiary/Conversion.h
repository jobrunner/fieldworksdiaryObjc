@class CLLocation;
@class CoordinateSystem;

@interface Conversion : NSObject

- (NSString *)locationToAltitude:(CLLocation *)location
                withUnitOfLength:(UnitOfLength)unitOfLength;

- (NSString *)locationToHorizontalAccuracy:(CLLocation *)location
                          withUnitOfLength:(UnitOfLength)unitOfLength;

- (NSString *)locationToVerticalAccuracy:(CLLocation *)location
                        withUnitOfLength:(UnitOfLength)unitOfLength;

- (NSString *)locationToCoordinates:(CLLocation *)location
                   coordinateSystem:(CoordinateSystem *)coordinateSystem;

- (NSString *)signumString:(float)value;

- (NSString *)signumStringWithNumber:(NSNumber *)value;

@end
