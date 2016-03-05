//
//  HomeViewController.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 07.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"
#import "SamplesController.h"
#import "FieldtripDetailsViewController.h"
#import "ProjectTableViewController.h"
#import "HomeController.h"
#import "Fieldtrip.h"
#import "ActiveFieldtrip.h"
#import "ActiveCollector.h"
#import "RecordStatistics.h"

@interface HomeController ()

@property (weak, nonatomic) IBOutlet UIButton *addFieldtripButton;
@property (weak, nonatomic) IBOutlet UILabel *activeCollectorLabel;
@property (weak, nonatomic) IBOutlet UILabel *activeProjectLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyLocalityNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *recentlyIdentifiersLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfLocationsLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfSamplesLabel;
@property (weak, nonatomic) IBOutlet UILabel *countOfPhotosLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *recentSampleCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *locationsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *samplesCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *photosCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *calendarCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *projectsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *tagsCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *peopleCell;
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
    
    self.recentFieldtrip = [RecordStatistics recentSample];
    
    // still dummy
    // take that Project, that is marked as "Use for new samples" (in settings)
    _activeProjectLabel.text = [ActiveFieldtrip name];
    
    // still dummy
    // take that user that is marked as "Use for new samples" (in settings)
    _activeCollectorLabel.text = [ActiveCollector name];
    
    // still dummy
    NSUInteger locationCount = 0;
    _countOfLocationsLabel.text = [NSString stringWithFormat:@"%lu", locationCount];
    
    // still dummy
    NSUInteger photosCount = 0;
    _countOfPhotosLabel.text = [NSString stringWithFormat:@"%lu", photosCount];
    
    NSUInteger sampleCount = [RecordStatistics sampleCount];
    _recentSampleCell.userInteractionEnabled = (sampleCount > 0);
    _recentSampleCell.textLabel.enabled = (sampleCount > 0);
    _recentSampleCell.imageView.alpha = (sampleCount > 0) ? 1.0 : 0.5;
    _countOfSamplesLabel.text = [NSString stringWithFormat:@"%lu", sampleCount];
    
    [self updateInfoboard];
    
    [self scrollToTop];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    
    // let MKNetworking kill its cache
    // Dispose of any resources that can be recreated.
}

#pragma mark - TableView Header / UIScrollView -

- (void)updateInfoboard {
    
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

-(void) scrollToTop {

    if ([self numberOfSectionsInTableView:self.tableView] > 0) {
        NSIndexPath* top = [NSIndexPath indexPathForRow:NSNotFound
                                              inSection:0];
        [self.tableView scrollToRowAtIndexPath:top
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
    }
}

#pragma mark - Segues -

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {

    if ([[segue identifier] isEqualToString:@"createSampleSegue"]) {
        FieldtripDetailsViewController * controller = segue.destinationViewController;
        controller.fieldtrip = nil;
    }

    // Show the most recent sample
    if ([[segue identifier] isEqualToString:@"openRecentSampleSegue"]) {

        FieldtripDetailsViewController * controller = segue.destinationViewController;
        
        controller.fieldtrip = self.recentFieldtrip;
    }

    if ([[segue identifier] isEqualToString:@"openFavoritSamplesSegue"]) {
        
        SamplesController *controller = segue.destinationViewController;
        
        controller.showOnlyMarkedAsFavorits = YES;
    }
}

@end