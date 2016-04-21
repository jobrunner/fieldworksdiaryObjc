#import "TimeZonePickerController.h"
#import "TimeZonesController.h"
#import "RegionCell.h"

@interface TimeZonePickerController ()

@property (nonatomic, strong) NSString *timeZoneRegion;
@property (nonatomic, strong) NSArray *regionNames;

- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

@implementation TimeZonePickerController

#pragma mark - UITableView Delegates

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _timeZoneRegion = [[_timeZone.name componentsSeparatedByString:@"/"] firstObject];
    _regionNames = self.timeZoneRegions;
}

- (NSArray *)timeZoneRegions {

    NSMutableArray *timeZoneRegions = NSMutableArray.new;
    NSArray *timeZoneNames = [NSTimeZone knownTimeZoneNames];
    for (NSString *name in timeZoneNames) {
        
        NSArray *parts = [name componentsSeparatedByString:@"/"];
        if (![timeZoneRegions containsObject:[parts firstObject]]) {
            if (![[parts firstObject] isEqualToString:@"GMT"]) {
                [timeZoneRegions addObject:[parts firstObject]];
            }
        }
    }
    
    return timeZoneRegions.copy;
}


#pragma mark - UITableViewController delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {

    if (section == 0) {
        return [_regionNames count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"RegionCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    
    if (!cell) {
        [tableView registerNib:[UINib nibWithNibName:cellId
                                              bundle:nil]
        forCellReuseIdentifier:cellId];
        
        cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView
  willDisplayCell:(RegionCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *regionName = [_regionNames objectAtIndex:indexPath.item];
    
    BOOL selected = ([regionName isEqualToString:_timeZoneRegion]);

    [cell configureWithRegion:regionName
                  atIndexPath:indexPath
                     selected:selected];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSString *regionName = [_regionNames objectAtIndex:indexPath.item];
    
    [self performSegueWithIdentifier:@"TimeZonesSelectorSeque"
                              sender:regionName];
}

// Dosn't support native editing of table view cells.
- (BOOL)tableView:(UITableView *)tableView
canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

// Dosn't support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView
canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    
    return NO;
}

#pragma mark - IBActions

- (IBAction)cancelButton:(UIBarButtonItem *)sender {

    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - TimeZonesControllerDelegate

- (void)timeZonesController:(TimeZonesController *)controller
          didSelectTimeZone:(NSTimeZone *)timeZone {
    
    if ([self.delegate respondsToSelector:@selector(timeZonePicker:didSelectTimeZone:)]) {
        
        // call delegate method to inform about the change
        [self.delegate timeZonePicker:self
                    didSelectTimeZone:timeZone];
    }
    
    
    [self.navigationController popViewControllerAnimated:NO];
    [self.navigationController popViewControllerAnimated:YES];
}


#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"TimeZonesSelectorSeque"]) {
        
        TimeZonesController *controller = segue.destinationViewController;
        controller.regionNameFilter = (NSString *)sender;
        controller.timeZone = _timeZone;
        controller.delegate = self;
    }
}
@end
