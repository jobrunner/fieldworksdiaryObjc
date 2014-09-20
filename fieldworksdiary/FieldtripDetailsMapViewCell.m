@import MapKit;

#import "FieldtripDetailsMapViewCell.h"
#import "Fieldtrip.h"
#import "Crypto.h"

@implementation FieldtripDetailsMapViewCell

@synthesize fieldtrip = _fieldtrip;


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
    [self initMapView];
}

#pragma mark - FieldtripDetailsCellProtocol -

- (void)setFieldtrip:(Fieldtrip *)fieldtrip
{
    _fieldtrip = fieldtrip;
    [self updateUserInterface];
}


- (Fieldtrip *)fieldtrip
{
    return _fieldtrip;
}


- (void)updateUserInterface
{
    [self drawMapFromModel];
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsMapViewCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsMapViewCell";
    
    return identifier;
}

- (void)initMapView
{
    // create an hidden mapView object
    self.mapView = [[MKMapView alloc] initWithFrame:self.staticMapImage.frame];
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
    self.mapView.delegate = self;
    
    [self.contentView addSubview:self.mapView];
}

- (void)drawMapFromModel
{
	NSString *imageMapPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/Maps/%@", self.fieldtrip.mapImageFilename]];
    
    NSLog(@"String to load: %@", imageMapPath);
    
	NSData *imageMapData = [NSData dataWithContentsOfFile:imageMapPath];
    
	if (imageMapData == nil) {
        NSLog(@"Fild couldn't be loaded. Must be regenerate from model data...");
        [self makeMapSnaphotFromModel];
    } else {
        self.staticMapImage.image = [UIImage imageWithData:imageMapData];
    }
}

- (void)makeMapSnaphotFromModel
{
    NSLog(@"makeMapSnapshot...");
    
    MKCoordinateRegion region;
    
    region.center.latitude = [self.fieldtrip.latitude doubleValue]; // location.coordinate.latitude;
    region.center.longitude = [self.fieldtrip.longitude doubleValue]; //  location.coordinate.longitude;
    
    region.span.longitudeDelta = 0.01; // ca. 111km / 0.001° => 100m
    region.span.latitudeDelta = 0.01;  // ca. 111km / 0.001° => 100m
    
    [self initMapView];
    [self.mapView setRegion:region animated:NO];
    
    MKMapSnapshotOptions *options = [[MKMapSnapshotOptions alloc] init];
    
    options.region = region;
    options.scale = [UIScreen mainScreen].scale;
    
    options.size = self.mapView.frame.size;
    
    MKMapSnapshotter *snapshotter = [[MKMapSnapshotter alloc] initWithOptions:options];
    
    [snapshotter startWithCompletionHandler:^(MKMapSnapshot *snapshot, NSError *error) {
        
        UIImage *image = snapshot.image;
        
        UIImage *imageWithCircle = [self imageByDrawingCircleOnImage:image];
        
        // show the map with the pure circle in it
        self.staticMapImage.image = imageWithCircle;
        
        // convert image to PNG file format
        NSData *pngImageData = UIImagePNGRepresentation(imageWithCircle);
        
        // create a filename based on sha1
        NSString *sha1Hash = [Crypto sha1WithBinary:pngImageData];
        NSString *filename = [NSString stringWithFormat:@"%@.png", sha1Hash];
        
        // Create Pictures in users Documents directory if it doesn't exist
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES);
        NSString *path = [[paths objectAtIndex:0] stringByAppendingPathComponent:@"Maps"];
        NSError *ioError;
        
        // Does directory already exist? No, then create it.
        if (![[NSFileManager defaultManager] fileExistsAtPath:path]) {
            if (![[NSFileManager defaultManager] createDirectoryAtPath:path
                                           withIntermediateDirectories:NO
                                                            attributes:nil
                                                                 error:&ioError]) {
                NSLog(@"Create directory error: %@", error);
            }
        }
        
        // create the full file path
        NSString *filePath = [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@", filename]];
        
        NSLog(@"Full path to store picture: %@", filePath);
        
        // store the png
        if ([pngImageData writeToFile:filePath
                           atomically:YES] == YES) {
            self.fieldtrip.mapImageFilename = filename;
            
        } else {
            NSLog(@"Failed to write map file to disc.");
            // alert the error
            self.fieldtrip.mapImageFilename = nil;
        }
    }];
}

- (void)mapViewDidFinishRenderingMap:(MKMapView *)mapView
                       fullyRendered:(BOOL)fullyRendered
{
    if (fullyRendered) {
        NSLog(@"MapView ist fertig gerendert. Jetzt SnapShot erstellen!");
    }
}

- (UIImage *)imageByDrawingCircleOnImage:(UIImage *)image
{
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
