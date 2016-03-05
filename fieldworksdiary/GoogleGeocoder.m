

#import "GoogleGeocoder.h"
#import "MKNetworkEngine.h"

@implementation GoogleGeocoder

-(id)init {
    
    return [self initWidthLanguage:@"en"];
}

- (id)initWidthLanguage:(NSString *)language {
    
    if (self = [super initWithHostName:@"maps.googleapis.com"
                               apiPath:@"maps/api/geocode"
                    customHeaderFields:nil]) {
        
    }
    self.language = language;

    return self;
}

- (MKNetworkOperation*) geocodeWithLatitude:(double)latitude
                                  longitude:(double)longitude
                                   language:(NSString*)language
                                 completion:(JsonResponseBlock)completionBlock
                                      error:(ErrorBlock)errorBlock {
    
    NSString *latLngParam = [NSString stringWithFormat:@"%f,%f", latitude, longitude];
 
    NSLog(@"Now, adding Google-Geolocation Service Call to MKNetworks global operation queue");
    
    MKNetworkOperation *op = [self operationWithPath:[NSString stringWithFormat:@"json?sensor=true&latlng=%@&language=%@", latLngParam, language]
                                              params:nil
                                          httpMethod:@"GET"];
    
    [op addCompletionHandler:^(MKNetworkOperation *completedOperation) {
        
        NSDictionary *responseJSON = [completedOperation responseJSON];
        
        if (responseJSON && [[responseJSON objectForKey:@"status"] isEqualToString:@"OK"]) {
            completionBlock(responseJSON);
        } else {
            NSDictionary* errorDictionary = @{NSLocalizedDescriptionKey :@"Google geocode failed!"};
            NSError *error = [NSError errorWithDomain:@"Failed response" code:100 userInfo:errorDictionary];
            errorBlock(error);
        }
    } errorHandler:^(MKNetworkOperation *errorOperation, NSError *error) {
        NSLog(@" Errors occured: %@", error);
        errorBlock(error);
    }];
    
    [self enqueueOperation:op];
    
    return op;
}

@end