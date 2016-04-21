#import "TimeZonesController.h"
#import "TimeZoneCell.h"

@interface TimeZonesController ()

@property (nonatomic, strong) NSArray *timeZoneNames;

- (IBAction)cancelButton:(UIBarButtonItem *)sender;

@end

@implementation TimeZonesController

#pragma mark - UITableView Delegates

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    _timeZoneNames = [self timeZonesWithRegion:_regionNameFilter];
}

- (NSArray *)timeZonesWithRegion:(NSString *)region {

    NSPredicate* predicate = [NSPredicate predicateWithFormat:@"SELF BEGINSWITH %@", region];
    
    NSArray* filteredData = [[NSTimeZone knownTimeZoneNames] filteredArrayUsingPredicate:predicate];
    
    return [filteredData sortedArrayUsingSelector:@selector(compare:)];
}

#pragma mark - UITableViewController delegates

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        return [_timeZoneNames count];
    }
    
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellId = @"TimeZoneCell";
    
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
  willDisplayCell:(TimeZoneCell *)cell
forRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSString *timeZoneName = [_timeZoneNames objectAtIndex:indexPath.item];
    NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
    
    BOOL selected = ([timeZoneName isEqualToString:self.timeZone.name]);
    
    [cell configureWithTimeZone:timeZone
                    atIndexPath:indexPath
                       selected:selected];
}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if ([self.delegate respondsToSelector:@selector(timeZonesController:didSelectTimeZone:)]) {
        
        NSString *timeZoneName = [_timeZoneNames objectAtIndex:indexPath.item];
        NSTimeZone *timeZone = [NSTimeZone timeZoneWithName:timeZoneName];
        
        // call delegate method to inform about the change
        [self.delegate timeZonesController:self
                         didSelectTimeZone:timeZone];
    }
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

@end
