//
//  MettLocalityEditViewController.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "Conversion.h"
#import "Fieldtrip.h"
#import "Project.h"
#import "AppDelegate.h"
#import "SampleEditController.h"
#import "ActiveDateSetting.h"
#import "DateUtility.h"
#import "FieldtripsController.h"
#import "TimeZonePickerController.h"

@interface SampleEditController ()

@property (weak, nonatomic) IBOutlet UITextField *sampleIdentifierTextField;
@property (weak, nonatomic) IBOutlet UITextField *localityIdentifierTextField;
@property (weak, nonatomic) IBOutlet UITextField *localityNameTextField;

@property (weak, nonatomic) IBOutlet UILabel *coordinateSystemLabel;
@property (weak, nonatomic) IBOutlet UITextField *latituteTextField;
@property (weak, nonatomic) IBOutlet UITextField *longituteTextField;

@property (weak, nonatomic) IBOutlet UITextField *altitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *subAdministrativeAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeLocalityTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeSubLocalityTextField;

@property (weak, nonatomic) IBOutlet UILabel *alldayDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *alldaySwitch;
@property (weak, nonatomic) IBOutlet UITableViewCell *beginDateCell;
@property (weak, nonatomic) IBOutlet UILabel *beginDateCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *beginDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *beginDatePickerCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDateCell;
@property (weak, nonatomic) IBOutlet UILabel *endDateCaptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UITableViewCell *timeZoneCell;
@property (weak, nonatomic) IBOutlet UILabel *timeZoneLabel;
@property (weak, nonatomic) IBOutlet UILabel *fieldtripLabel;
@property (weak, nonatomic) IBOutlet UISwitch *markSampleSwitch;


@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

- (IBAction)alldaySwitchValueChanged:(UISwitch *)sender;
- (IBAction)beginDatePickerDidChange:(UIDatePicker *)sender;
- (IBAction)endDatePickerDidChange:(UIDatePicker *)sender;

- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;

- (IBAction)sampleIndifierTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)sampleIdendifierTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)localityIdentifierTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)localityNameTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)localityNameTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)countryTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)countryTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)administrativeAreaTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)administrativeAreaTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)subAdministrativeAreaTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)subAdministrativeAreaTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)localityTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)localityTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)sublocalityTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)sublocalityTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)latitudeTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)latitudeTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)longitudeTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)longitudeTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)altitudeTextFieldEditingChanged:(UITextField *)sender;
- (IBAction)altitudeTextFieldEditingDidEnd:(UITextField *)sender;

- (IBAction)markSampleSwitchValueChanged:(UISwitch *)sender;

@end

@implementation SampleEditController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    
    // self.notesTextView.delegate = self;
    
    [self showExistingModelForEditing];
    
    
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)showExistingModelForEditing {
    
//    self.isNewObject = NO;
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem.title = NSLocalizedString(@"Save", @"Save");
    self.navigationItem.rightBarButtonItem.enabled = false;
    
    [self loadFormData];
}

#pragma mark - Form Data handling

- (void)loadFormData {

    _sampleIdentifierTextField.text = _sample.specimenIdentifier;
    _localityIdentifierTextField.text = _sample.localityIdentifier;
    _localityNameTextField.text = _sample.localityName;
    
    _coordinateSystemLabel.text = @"Geodetic decimal (WGS84)";

    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
    [formatter setLocale:[NSLocale currentLocale]];
    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
    [formatter setAlwaysShowsDecimalSeparator:NO];
    [formatter setUsesGroupingSeparator:NO];

    _latituteTextField.text = [formatter stringFromNumber:_sample.latitude];
                                 
//    _latituteTextField.text = _sample.latitude.stringValue;

    
    
    _longituteTextField.text = _sample.longitude.stringValue;
    _altitudeTextField.text = _sample.altitude.stringValue;
    
    _countryTextField.text = _sample.country;
    _administrativeAreaTextField.text = _sample.administrativeArea;
    _subAdministrativeAreaTextField.text = _sample.subAdministrativeArea;
    _administrativeLocalityTextField.text = _sample.administrativeLocality;
    _administrativeSubLocalityTextField.text = _sample.administrativeSubLocality;
    
    _timeZoneLabel.text = _sample.timeZone.name;
    _fieldtripLabel.text = _sample.project.name;
    _markSampleSwitch.on = _sample.isMarked.boolValue;
    
    // init date picker cells
    self.hideSectionsWithHiddenRows = YES;
    
    // init date picker hidden
    [self cell:self.beginDatePickerCell setHidden:YES];
    [self cell:self.endDatePickerCell setHidden:YES];
    
    [self drawDateRangeSelector];
    
    [self reloadDataAnimated:NO];
}

- (void)saveFormToModel {
    
    // set model data
    _sample.specimenIdentifier = _sampleIdentifierTextField.text;
    _sample.localityIdentifier = _localityIdentifierTextField.text;
    _sample.localityName = _localityNameTextField.text;
    
    
//    NSNumberFormatter *formatter = [[NSNumberFormatter alloc] init];
//
//    [formatter setLocale:[NSLocale currentLocale]];
//    [formatter setNumberStyle:NSNumberFormatterDecimalStyle];
//    [formatter setAlwaysShowsDecimalSeparator:NO];
//    [formatter setUsesGroupingSeparator:NO];
//    
//    _sample.latitude = [formatter numberFromString:_latituteTextField.text];
    
//    _sample.latitude = [NSNumber numberWithDouble:_latituteTextField.text.doubleValue];

    
    
    _sample.longitude = [NSNumber numberWithDouble:_longituteTextField.text.doubleValue];
    _sample.altitude =  [NSNumber numberWithInteger:_altitudeTextField.text.integerValue];
    
    _sample.country = _countryTextField.text;
//    _sample.countryCodeISO = @"DE";
    
    _sample.administrativeArea = _administrativeAreaTextField.text;
    _sample.subAdministrativeArea = _subAdministrativeAreaTextField.text;
    _sample.administrativeLocality = _administrativeLocalityTextField.text;
    _sample.administrativeSubLocality = _administrativeSubLocalityTextField.text;
    
//    _sample.timeZone = [NSTimeZone timeZoneWithName:_timeZoneLabel.text];
    
    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }
}

#pragma mark - Date Range Stuff -

- (void)toogleEditingBeginDate {
    
    if ([self isBeginDateInEditMode] == YES) {
        [self stopEditingBeginDate];
    } else {
        [self startEditingBeginDate];
    }
    [self stopEditingEndDate];
}

- (void)toogleEditingEndDate {
    
    if ([self isEndDateInEditMode] == YES) {
        [self stopEditingEndDate];
    } else {
        [self startEditingEndDate];
    }
    
    [self stopEditingBeginDate];
}

- (void)showCellWithPicker:(UITableViewCell *)pickerCell {
    
    [self cell:pickerCell setHidden:NO];
    [self reloadDataAnimated:YES];
}

- (void)hideCellWithPicker:(UITableViewCell *)pickerCell {
    
    [self cell:pickerCell setHidden:YES];
    [self reloadDataAnimated:YES];
}

- (void)startEditingBeginDate {
    
    [self showCellWithPicker:self.beginDatePickerCell];
    
    [self drawDateRangeSelector];
}

- (void)stopEditingBeginDate {
    
    [self hideCellWithPicker:self.beginDatePickerCell];
    
    [self drawDateRangeSelector];
}

- (void)startEditingEndDate {
    
    [self showCellWithPicker:self.endDatePickerCell];
    
    [self drawDateRangeSelector];
}

- (void)stopEditingEndDate {
    
    [self hideCellWithPicker:self.endDatePickerCell];
    
    [self drawDateRangeSelector];
}

- (BOOL)isBeginDateInEditMode {
    
    return ([self cellIsHidden:self.beginDatePickerCell] == NO);
}

- (BOOL)isEndDateInEditMode {
    
    return ([self cellIsHidden:self.endDatePickerCell] == NO);
}

- (void)drawDateRangeSelector {
    
    // draw allday switch
    self.alldaySwitch.on = _sample.isFullTime.boolValue;

    // draw time zone cell
    [self cell:self.timeZoneCell setHidden:_sample.isFullTime.boolValue];
    [self reloadDataAnimated:YES];

    [self drawBeginDateCaption:_sample.beginDate
                      isAllday:_sample.isFullTime.boolValue
                  isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDateCaption:_sample.endDate
                    isAllday:_sample.isFullTime.boolValue
                isInEditMode:[self isEndDateInEditMode]
                   beginDate:_sample.beginDate];
    
    [self drawBeginDatePicker:_sample.beginDate
                     isAllday:_sample.isFullTime.boolValue
                 isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDatePicker:_sample.endDate
                   isAllday:_sample.isFullTime.boolValue
               isInEditMode:[self isEndDateInEditMode]];
}

/**
 * Configures and updates begin date picker
 */
- (void)drawBeginDatePicker:(NSDate *)beginDate
                   isAllday:(BOOL)isAllday
               isInEditMode:(BOOL)isInEditMode {

    if (isAllday == YES) {
        self.beginDatePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        self.beginDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    self.beginDatePicker.date = beginDate;
}

/**
 * Configures and updates end date picker
 */
- (void)drawEndDatePicker:(NSDate *)endDate
                 isAllday:(BOOL)isAllday
             isInEditMode:(BOOL)isInEditMode {
    
    if (isAllday == YES) {
        self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    }
    else {
        self.endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    self.endDatePicker.date = endDate;
}

/**
 * Updates begin date caption
 */
- (void)drawBeginDateCaption:(NSDate *)beginDate
                    isAllday:(BOOL)isAllday
                isInEditMode:(BOOL)isInEditMode {

    // striketrought whether endDate is before beginDate
    BOOL strikethrough = [beginDate compare:beginDate] == NSOrderedDescending;
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyleWithAllday:isAllday]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                           isAllday:isAllday
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter = [DateUtility dateFormatterWithAllday:isAllday
                                                       isEqualDayOmitting:NO];
    
    NSDateFormatter *timeFormatter = [DateUtility timeFormatterWithAllday:isAllday];
    
    // build the string together and render it
    NSString *beginDateString = [NSString stringWithFormat:@"\t%@\t%@",
                                 [dateFormatter stringFromDate:beginDate],
                                 [timeFormatter stringFromDate:beginDate]];
    
    NSAttributedString *attributetString = [[NSAttributedString alloc] initWithString:beginDateString
                                                                           attributes:attributes];
    
    self.beginDateLabel.attributedText = attributetString;
}

- (void)drawEndDateCaption:(NSDate *)endDate
                  isAllday:(BOOL)isAllday
              isInEditMode:(BOOL)isInEditMode
                 beginDate:(NSDate *)beginDate {
    
    // striketrought whether date and time is shown and endDate is before beginDate
    BOOL strikethrough = (isAllday == NO) && ([beginDate compare:endDate] == NSOrderedDescending);
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyleWithAllday:isAllday]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                           isAllday:isAllday
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter = [DateUtility dateFormatterWithAllday:isAllday
                                                       isEqualDayOmitting:[DateUtility isDateSameDay:beginDate
                                                                                              asDate:endDate]];
    NSDateFormatter *timeFormatter = [DateUtility timeFormatterWithAllday:isAllday];
    
    // build the string together and render it
    NSString *endDateString = [NSString stringWithFormat:@"\t%@\t%@",
                               [dateFormatter stringFromDate:endDate],
                               [timeFormatter stringFromDate:endDate]];
    
    NSAttributedString *attributetString = [[NSAttributedString alloc] initWithString:endDateString
                                                                           attributes:attributes];
    
    self.endDateLabel.attributedText = attributetString;
}

#pragma mark - generic DateRangePicker

- (void)setAllday:(BOOL)allday {
    
    _sample.isFullTime = @(allday);
}

- (NSParagraphStyle *)paragraphStyleWithAllday:(BOOL)isAllday {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    // Define tab stops that fits date and time parts
    NSTextTab *dateTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight
                                                         location:130
                                                          options:[NSDictionary dictionary]];
    
    NSTextTab *timeTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight
                                                         location:200
                                                          options:[NSDictionary dictionary]];
    if (isAllday == YES) {
        paragraphStyle.tabStops = @[timeTab];
    }
    else {
        paragraphStyle.tabStops = @[dateTab, timeTab];
    }
    
    return (NSParagraphStyle *)paragraphStyle;
}

- (NSDictionary *)attributesWithParagraphStyle:(NSParagraphStyle *)paragraphStyle
                                     tintColor:(UIColor *)color
                                 strikethrough:(BOOL)strikethrough
                                      isAllday:(BOOL)isAllday
                                  isInEditMode:(BOOL)isInEditMode {

    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    // tint caption when edditing
    if (isInEditMode == YES) {
        attributes[NSForegroundColorAttributeName] = color;;
    }
    else {
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor;
    }
    
    if (strikethrough){
        attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    }
    else {
        attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleNone];
    }
    
    return (NSDictionary *)attributes;
}

#pragma mark - Table view delegates

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

    NSIndexPath * beginIndexPath = [self.tableView indexPathForCell:self.beginDateCell];
    NSIndexPath * endIndexPath   = [self.tableView indexPathForCell:self.endDateCell];
    
    if ([indexPath isEqual:beginIndexPath]) {
        [self toogleEditingBeginDate];
    }
    
    if ([indexPath isEqual:endIndexPath]) {
        [self toogleEditingEndDate];
    }
}

#pragma mark - Navigation helper

- (void)goToPreviousViewController {
    
    UINavigationController *navigationController = self.navigationController;
    
    [navigationController popViewControllerAnimated:YES];
}

#pragma mark - IBActions

- (IBAction)alldaySwitchValueChanged:(UISwitch *)sender {
    
    _sample.isFullTime = @(sender.on);
    
    [self drawDateRangeSelector];
    [self formDidChanged:sender];
}

- (IBAction)beginDatePickerDidChange:(UIDatePicker *)picker {
    
    _sample.beginDate = picker.date;
    _sample.endDate = [_sample.beginDate dateByAddingTimeInterval:60.0 * 60.0]; // adding 1 hour to beginDate
    
    [self drawDateRangeSelector];
    [self formDidChanged:picker];
}

- (IBAction)endDatePickerDidChange:(UIDatePicker *)picker {
    
    _sample.endDate = picker.date;
    
    [self drawDateRangeSelector];
    [self formDidChanged:picker];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {

    [self saveFormToModel];
    [self goToPreviousViewController];
}

- (IBAction)cancelButton:(id)sender {

    [self goToPreviousViewController];
}

- (IBAction)sampleIndifierTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)sampleIdendifierTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)localityIdentifierTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)localityIdentifierTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)localityNameTextFieldEditingChanged:(UITextField *)sender {

    [self formDidChanged:sender];
}

- (IBAction)localityNameTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)countryTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)countryTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)administrativeAreaTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)administrativeAreaTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)subAdministrativeAreaTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)subAdministrativeAreaTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)localityTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)localityTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)sublocalityTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)sublocalityTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)latitudeTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)latitudeTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)longitudeTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)longitudeTextFieldEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)altitudeTextFieldEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)altitudeTextFieldEditingDidEnd:(UITextField *)sender {

    [self formDidChanged:sender];
}

- (IBAction)markSampleSwitchValueChanged:(UISwitch *)sender {
    
    _sample.isMarked = @(sender.on);
    [self formDidChanged:sender];
}

#pragma form helper

- (void)formDidChanged:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidEndEditing:(UITextView *)textView {

    [textView resignFirstResponder];
}

#pragma mark - FieldtripPickerDelegate

- (void)fieldtripPicker:(FieldtripsController *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    _sample.project = fieldtrip;
    _fieldtripLabel.text = _sample.project.name;

    [self formDidChanged:picker];
}

#pragma mark - TimeZonePickerDelegate

- (void)timeZonePicker:(TimeZonePickerController *)picker
     didSelectTimeZone:(NSTimeZone *)timeZone {
    
    _sample.timeZone = timeZone;
    _timeZoneLabel.text = timeZone.name;
    
    [self formDidChanged:picker];
}

#pragma mark - Segues

- (void)prepareForSegue:(UIStoryboardSegue *)segue
                 sender:(id)sender {
    
    if ([[segue identifier] isEqualToString:@"FieldtripPickerSegue"]) {
        
        FieldtripsController *controller = segue.destinationViewController;
        controller.delegate = self;
        controller.fieldtripUsage = kFieldtripUsagePicker;
    }
    
    if ([[segue identifier] isEqualToString:@"TimeZonePickerSegue"]) {
        
        TimeZonePickerController *controller = segue.destinationViewController;
        controller.delegate = self;
    }
}

@end