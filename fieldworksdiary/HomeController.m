//
//  HomeViewController.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "SamplesController.h"
#import "SampleDetailsController.h"
#import "ProjectTableViewController.h"
#import "HomeController.h"
#import "Fieldtrip.h"
#import "ActiveFieldtrip.h"
#import "ActiveCollector.h"
#import "RecordStatistics.h"
#import "Formatter.h"

@interface HomeController ()

@property (weak, nonatomic) IBOutlet UIButton *addFieldtripButton;
@property (weak, nonatomic) IBOutlet UILabel *activeCollectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeFieldtripLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyLocalityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyIdentifiersLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfLocationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfFieldtripsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfSamplesLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfMarkedSamples;
@property (weak, nonatomic) IBOutlet UILabel *countOfPhotosLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *recentSampleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *samplesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *markedSamplesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *photosCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *calendarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *fieldtripsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *settingsCell;

@end

@implementation HomeController

// Hight of table view header.
CGFloat kTableViewHeaderHeight = 217.0;

// Extra view will be the stretchy header
UIView *headerView;

#pragma mark - TableViewController -

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self initStretchyTableViewHeader];
}

- (void)viewDidAppear:(BOOL)animated {

//    self.recentFieldtrip = [RecordStatistics recentSample];
//    
//    // take that Project, that is marked as "Use for new samples" (in settings)
//    _activeFieldtripLabel.text = [ActiveFieldtrip name];
//    
//    // take that user that is marked as "Use for new samples" (in settings)
//    _activeCollectorLabel.text = [ActiveCollector name];

    [self updateInfoboard];

    [self initTableViewValues];
    
    
//    NSUInteger fieldtripCount = [RecordStatistics fieldtripCount];
//    _countOfFieldtripsLabel.text = [formatter counter:fieldtripCount];
//    
//    // still dummy
//    NSUInteger locationsCount = 0;
//    _countOfLocationsLabel.text = [formatter counter:locationsCount];
//    
//    
//    
//    
//    // still dummy
//    NSUInteger photosCount = 0;
//    _countOfPhotosLabel.text = [formatter counter:photosCount];
//    
//    NSUInteger sampleCount = [RecordStatistics sampleCount];
//    _countOfSamplesLabel.text = [formatter counter:sampleCount];
//
//    _recentSampleCell.userInteractionEnabled = (sampleCount > 0);
//    _recentSampleCell.textLabel.enabled = (sampleCount > 0);
//    _recentSampleCell.imageView.alpha = (sampleCount > 0) ? 1.0 : 0.5;
//    
//    NSUInteger markedSampleCount = [RecordStatistics sampleCount];
//    _countOfMarkedSamples.text = [formatter counter:markedSampleCount];
    
    
    [self scrollToTop];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // let MKNetworking kill its cache
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Header / UIScrollView

- (void)updateInfoboard {
    
    self.recentFieldtrip = [RecordStatistics recentSample];
    
    // take that Project, that is marked as "Use for new samples" (in settings)
    _activeFieldtripLabel.text = [ActiveFieldtrip name];
    
    // take that user that is marked as "Use for new samples" (in settings)
    _activeCollectorLabel.text = [ActiveCollector name];
    
    if (self.recentFieldtrip == nil) {
        _recentlyLocalityNameLabel.text = @"-";
        _recentlyIdentifiersLabel.text = @"-";

        return ;
    }

    _recentlyLocalityNameLabel.text = self.recentFieldtrip.localityName;

    if (self.recentFieldtrip.specimenIdentifier && self.recentFieldtrip.localityIdentifier) {
        _recentlyIdentifiersLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                                          self.recentFieldtrip.specimenIdentifier,
                                          self.recentFieldtrip.localityIdentifier];
        return;
    }
    _recentlyIdentifiersLabel.text = [NSString stringWithFormat:@"%@ (%@)",
                                      @"---",
                                      @"---"];
    if (self.recentFieldtrip.specimenIdentifier) {
        _recentlyIdentifiersLabel.text = [NSString stringWithFormat:@"%@",
                                          self.recentFieldtrip.specimenIdentifier];
    }
    if (self.recentFieldtrip.localityIdentifier) {
        _recentlyIdentifiersLabel.text = [NSString stringWithFormat:@"%@",
                                          self.recentFieldtrip.localityIdentifier];
    }
}

- (void)initStretchyTableViewHeader {

    headerView = self.tableView.tableHeaderView;
    
    self.tableView.tableHeaderView = nil;
    
    [self.tableView addSubview:headerView];
    
    self.tableView.contentInset  = UIEdgeInsetsMake(kTableViewHeaderHeight, 0.0, 0.0, 0.0);
    self.tableView.contentOffset = CGPointMake(0, -kTableViewHeaderHeight);
    
    [self updateTableViewHeaderView];
}

- (void)updateTableViewHeaderView {

    CGRect headerRect = CGRectMake(0, -kTableViewHeaderHeight, self.tableView.bounds.size.width, kTableViewHeaderHeight);
    
    if (self.tableView.contentOffset.y < -kTableViewHeaderHeight) {
        headerRect.origin.y = self.tableView.contentOffset.y;
        headerRect.size.height = -self.tableView.contentOffset.y;
    }
    
    headerView.frame = headerRect;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {

    [self updateTableViewHeaderView];
}

-(void)scrollToTop {

    if ([self numberOfSectionsInTableView:self.tableView] > 0) {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound
                                              inSection:0];
        [self.tableView scrollToRowAtIndexPath:top
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - UI Initialization

- (void)initTableViewValues {
    
    Formatter *formatter = [Formatter new];
    
    [self initCellSamples:formatter];
    [self initCellMarkedSamples:formatter];
    [self initCellFieldtrips:formatter];
    [self initCellPhotos:formatter];
    [self initCellLocation:formatter];
}

- (void)initStaticCell:(UITableViewCell *)cell
         withCounter:(NSUInteger)count {

    cell.userInteractionEnabled = (count > 0);
    cell.textLabel.enabled = (count > 0);
    cell.imageView.alpha = (count > 0) ? 1.0 : 0.5;
}

- (void)initCellSamples:(Formatter *)formatter {
    
    NSUInteger sampleCount = [RecordStatistics sampleCount];
    _countOfSamplesLabel.text = [formatter counter:sampleCount];

    [self initStaticCell:_recentSampleCell
             withCounter:sampleCount];
    
//    _recentSampleCell.userInteractionEnabled = (sampleCount > 0);
//    _recentSampleCell.textLabel.enabled = (sampleCount > 0);
//    _recentSampleCell.imageView.alpha = (sampleCount > 0) ? 1.0 : 0.5;
}

- (void)initCellMarkedSamples:(Formatter *)formatter {
    
    NSUInteger markedSampleCount = [RecordStatistics markedSampleCount];
    _countOfMarkedSamples.text = [formatter counter:markedSampleCount];

    [self initStaticCell:_markedSamplesCell
             withCounter:markedSampleCount];
}

- (void)initCellFieldtrips:(Formatter *)formatter {
    
    NSUInteger fieldtripsCount = [RecordStatistics fieldtripCount];
    _countOfFieldtripsLabel.text = [formatter counter:fieldtripsCount];
    [self initStaticCell:_fieldtripsCell
             withCounter:fieldtripsCount];
}

- (void)initCellLocation:(Formatter *)formatter {
    
    // still dummy
    NSUInteger locationsCount = 0;
    _countOfLocationsLabel.text = [formatter counter:locationsCount];
    [self initStaticCell:_locationsCell
             withCounter:locationsCount];
}

- (void)initCellPhotos:(Formatter *)formatter {
    
    // still dummy
    NSUInteger photosCount = 0;
    _countOfPhotosLabel.text = [formatter counter:photosCount];
    [self initStaticCell:_photosCell
             withCounter:photosCount];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    // Prepare link to new sample
    if ([[segue identifier] isEqualToString:@"createSampleSegue"]) {
        SampleDetailsController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
    }

    // Prepare link to recent sample
    if ([[segue identifier] isEqualToString:@"openRecentSampleSegue"]) {

        SampleDetailsController * controller = segue.destinationViewController;
        controller.fieldtrip = self.recentFieldtrip;
    }

    // Prepare link to marked samples
    if ([[segue identifier] isEqualToString:@"openFavoritSamplesSegue"]) {
        
        SamplesController *controller = segue.destinationViewController;
        controller.sampleUsage = kSampleUsageFilteredByMarked;
    }
    
    // Prepare fieltrips > samples in fieldtrip
    if ([[segue identifier] isEqualToString:@"openFieldtripsSamplesSegue"]) {
        
        ProjectTableViewController *controller = segue.destinationViewController;
        controller.fieldtripUsage = kFieldtripUsageSampleFilter;
    }
}

@end