@import MapKit;

#import "SampleDetailsMapViewCell.h"
#import "Fieldtrip.h"
#import "Crypto.h"

@implementation SampleDetailsMapViewCell

@synthesize sample = _sample;


//- (id)initWithStyle:(UITableViewCellStyle)style
//    reuseIdentifier:(NSString *)reuseIdentifier {
//    
//    self = [super initWithStyle:style
//                reuseIdentifier:reuseIdentifier];
//
//    if (self) {
//        // Initialization code
//    }
//    return self;
//}

- (void)awakeFromNib {
    
    // Initialization code
    [self initMapView];

    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(updateUserInterface)
                                                 name:kNotificationLocationUpdate
                                               object:nil];
}

#pragma mark - FieldtripDetailsCellProtocol -

- (void)setSample:(Fieldtrip *)sample {
    
    _sample = sample;
    
    [self updateUserInterface];
}

- (Fieldtrip *)sample {
    
    return _sample;
}

- (void)updateUserInterface {
    
    [self drawPreviewMap:_sample];
}

- (void)initMapView {
    
    // create an hidden mapView object
    self.mapView = [[MKMapView alloc] initWithFrame:self.staticMapImage.frame];
    self.mapView.delegate = self;
    self.mapView.hidden = YES;
    // Configure the small mapView object
    // There are three options for Apple Maps:
    // - MKMapTypeStandard (default)
    // - MKMapTypeSatellite
    // - MKMapTypeHybrid
    self.mapView.mapType = MKMapTypeStandard;
    self.mapView.zoomEnabled = NO;
    self.mapView.scrollEnabled = NO;
    self.mapView.contentScaleFactor = 2.0;
    
    [self.contentView addSubview:self.mapView];
}

- (void)drawPreviewMap:(Fieldtrip *)sample {

    MKCoordinateRegion region;
    [self region:&region
      fromSample:_sample];

    NSError *error = nil;
    NSString *cachedMapFilePath = [self mapFilenameFromRegion:region
                                              snapShotVersion:self.snapShotVersion
                                                        error:&error];
    NSLog(@"String to load: %@", cachedMapFilePath);
    
	NSData *imageMapData = [NSData dataWithContentsOfFile:cachedMapFilePath];
    
	if (imageMapData == nil) {

        NSLog(@"Map preview file couldn't be loaded. Must be regenerate.");

        [self makeMapSnaphot:sample
                       error:&error];
        if (error != nil) {
            // Hier könnte der Grund in einem anderen Text münden.
            // Z.B. "Weil keine Koordinaten verfügbar sind etc.
            // Aktuell reicht die Weitergabe des Fehler völlig.
            _noMapAvailableLabel.hidden = NO;
        }
        else {
            _noMapAvailableLabel.hidden =YES;
        }
        
    }
    else {
        _noMapAvailableLabel.hidden =YES;
        self.staticMapImage.image = [UIImage imageWithData:imageMapData];
    }
}

// auslagern, das brauchen alle und ist abhängig von der App selbst.
// Änderungen müssen nur gemacht werden, wenn sich etwas grundlegendes
// an den SnapShots ändert (z.B. der Marker), damit die Preview-Images nach einem
// App-Update neu erzeugt werden können.
- (NSUInteger)snapShotVersion {
    
    return 1;
}

- (NSString *)mapFilenameFromRegion:(MKCoordinateRegion)region
                    snapShotVersion:(NSUInteger)version
                              error:(NSError **)error {

    NSString *sha1Hash = [Crypto sha1WithString:[NSString stringWithFormat:@"%f%f%f%f%lu",
                                                 region.center.latitude,
                                                 region.center.longitude,
                                                 region.span.longitudeDelta,
                                                 region.span.latitudeDelta,
                                                 (unsigned long)version]];
    
    NSString *filename = [NSString stringWithFormat:@"%@.png", sha1Hash];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
    NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"maps"];
    NSFileManager *fileManager = [NSFileManager defaultManager];

    // Does directory maps in users cache directory already exist? If not, try to create it.
    if (![fileManager fileExistsAtPath:path]) {

        if (![fileManager createDirectoryAtPath:path
                    withIntermediateDirectories:NO
                                     attributes:nil
                                          error:error]) {
            return nil;
        }
    }
    
    // create the full file path
    NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
    
    *error = nil;

    return filePath;
}

- (void)region:(MKCoordinateRegion *)region
    fromSample:(Fieldtrip *)sample {

    if (sample.location == nil) {
        
        return;
    }

    // die Deltas muss ich mit in die Definition aufnehmen, weil der User
    // zu einem späteren Zeitpunkt ggf. den Ausschnitt selbst wählen kann
    // (zwar nicht implementiert, aber das betrifft sonst eine CoreData-Migration)
    // Zu beachten ist aber folgendes für den Ausschnitt. Die Angabe hier
    // wird für das Preview verwendet. 1° entspricht etwa 111km.
    // Bei 0.01° zeigt das Preview ca. 1000m.
    // Da ich an "einem" Ort verschiedene Samples erwarte, die dazu jedes Mal
    // einen geringfügig anderen Lat/Lng-Wert haben, muss für das Preview eine
    // geeignete Rundung der Kooridnaten gewählt werden. Und diese ist abhängig von der Range.

    // Testwerte:
    // 1° ~ 111km / 0.01° ~ 1000m / 0.001° => 100m
    double latitudeDelta = 0.1;        // 1000m
    double longitudeDelta = 0.1;        // 1000m
    
    double tolerance = 10.0/100.0;  // 10%

    region->center.latitude = [self round:sample.latitude.doubleValue
                                withDelta:latitudeDelta
                             andTolerance:tolerance];
    
    region->center.longitude = [self round:sample.longitude.doubleValue
                                 withDelta:longitudeDelta
                              andTolerance:tolerance];

    region->span.latitudeDelta = latitudeDelta;
    region->span.longitudeDelta = longitudeDelta;
}

// kann auch ausgelagert werden, weil ich das später für die Groupierung von
// Zusammenhängenden Samples benötige.
- (double)round:(double)coordinate
      withDelta:(double)delta
   andTolerance:(double)tolerance {

    double factor = delta * tolerance;

    return floor(coordinate / factor + 0.5) * factor;
}

- (void)makeMapSnaphot:(Fieldtrip *)sample
                 error:(NSError **)error {
    
    if (sample.location == nil) {
        
        NSDictionary *userInfo = @{
                                   NSLocalizedDescriptionKey:NSLocalizedString(@"Preview map needs a geographic position.", nil)
                                   };
        *error = [NSError errorWithDomain:kErrorDomainFieldworksDiary
                                     code:1
                                 userInfo:userInfo];
        return;
    }
    
    MKCoordinateRegion region;
    [self region:&region
      fromSample:sample];
    
    [self initMapView];
    
    [self.mapView setRegion:region
                   animated:NO];
    
    MKMapSnapshotOptions *options = MKMapSnapshotOptions.new;
    
    options.region = region;
    options.scale = UIScreen.mainScreen.scale;
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        if (error != nil) {

            NSLog(@"Failed to create snapshot of map preview:\n%@", error.description);
            return;
        }
        
        UIImage *image = snapshot.image;
        

        
        
        
        
        
        
        
        UIImage *imageWithCircle = [self imageByDrawingCircleOnImage:image];
        
        // show the map with the pure circle in it
        self.staticMapImage.image = imageWithCircle;
        
        // convert image to PNG file format
        NSData *pngImageData = UIImagePNGRepresentation(imageWithCircle);
        
        NSString *filePath = [self mapFilenameFromRegion:region
                                         snapShotVersion:self.snapShotVersion
                                                   error:&error];
        if (error != nil) {
            NSLog(@"Failed to retrieve cached file name and path for map preview:\n%@", error.description);

            return;
        }
        else {
            NSLog(@"Full path to store picture: %@", filePath);
        }
        
        // store the png
        if ([pngImageData writeToFile:filePath
                           atomically:YES] == YES) {
            NSLog(@"Successed to write map file to cache.");
            
        } else {
            NSLog(@"Failed to write map file to cache.");
            
            NSDictionary *userInfo = @{
                                       NSLocalizedDescriptionKey:NSLocalizedString(@"Failed to write map file to cache.", nil)
                                       };
            error = [NSError errorWithDomain:kErrorDomainFieldworksDiary
                                        code:2
                                    userInfo:userInfo];
        }
    }];
}

//- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView
//                       fullyRendered:(BOOL)fullyRendered {
//    
////    if (fullyRendered) {
//        NSLog(@"MapView ist fertig gerendert? Jetzt SnapShot erstellen! %i", fullyRendered);
////    }
//}

- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image {
    
    // UIImage *pinImage = [UIImage imageNamed:@"locations"];

    // begin a graphics context of sufficient size
	UIGraphicsBeginImageContext(image.size);

    
    

    
	// draw original image into the context
	[image drawAtPoint:CGPointZero];
    
	// get the context for CoreGraphics
	CGContextRef ctx = UIGraphicsGetCurrentContext();
    
	// set stroking color and draw circle
	[[UIColor blueColor] setStroke];
    
	// make circle rect 5 px from border
    CGRect circleRect = CGRectMake(image.size.width / 2 - 10,
                                   image.size.height / 2 - 10,
                                   20,
                                   20);
	
	circleRect = CGRectInset(circleRect, 5, 5);
    
    // Für Punkt-Koordinaten hätte ich gerne einen Kreis,
    // für MGRS ein Quadrat, dass die genauigkeit des referenzierten Grids wiederspiegelt!
	// draw circle
	CGContextStrokeEllipseInRect(ctx, circleRect);
    //    CGContextStrokeRect(ctx, circleRect);

    
    

    
	// make image out of bitmap context
	UIImage *retImage = UIGraphicsGetImageFromCurrentImageContext();
    
	// free the context
	UIGraphicsEndImageContext();
    
	return retImage;
}

@end
