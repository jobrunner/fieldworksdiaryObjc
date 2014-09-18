#import <Foundation/Foundation.h>
#import "MKNetworkEngine.h"


typedef void (^JsonResponseBlock)(NSDictionary *);
typedef void (^ErrorBlock)(NSError* error);

@interface GoogleGeocoder : MKNetworkEngine

@property (strong, nonatomic) NSString *language;

- (id)init;
- (id)initWidthLanguage:(NSString *)language;

- (MKNetworkOperation*) geocodeWithLatitude:(double)latitude
                                  longitude:(double) longitude
                                   language:(NSString*) language
                                 completion:(JsonResponseBlock) completionBlock
                                      error:(ErrorBlock) errorBlock;

@end
