//
//  ProjectDetailsViewController.m
//

#import "ProjectDetailsViewController.h"
#import "ActiveFieldtrip.h"
#import "DateUtility.h"

@interface ProjectDetailsViewController ()

@property (weak, nonatomic) IBOutlet UIBarButtonItem *saveButton;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

- (IBAction)saveButton:(UIBarButtonItem *)sender;
- (IBAction)cancelButton:(UIBarButtonItem *)sender;


@property (weak, nonatomic) IBOutlet UITableViewCell *beginDatePickerCell;
@property (weak, nonatomic) IBOutlet UITableViewCell *endDatePickerCell;
@property (weak, nonatomic) IBOutlet UITextField *nameTextField;
@property (weak, nonatomic) IBOutlet UITextField *locationPrefixTextField;
@property (weak, nonatomic) IBOutlet UISwitch *isActiveSwitch;
@property (weak, nonatomic) IBOutlet UITextView *notesTextView;
@property (weak, nonatomic) IBOutlet UILabel *beginDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *endDateLabel;
@property (weak, nonatomic) IBOutlet UILabel *beginDateCaptionLabel;
@property (weak, nonatomic) IBOutlet UIDatePicker *beginDatePicker;
@property (weak, nonatomic) IBOutlet UIDatePicker *endDatePicker;
@property (weak, nonatomic) IBOutlet UILabel *endDateCaptionLabel;

- (IBAction)nameEditingDidEnd:(UITextField *)sender;
- (IBAction)nameEditingChanged:(UITextField *)sender;
- (IBAction)locationPrefixEditingDidEnd:(UITextField *)sender;
- (IBAction)locationPrefixEditingChanged:(UITextField *)sender;
- (IBAction)isActiveSwitchDidChanged:(UISwitch *)sender;

- (IBAction)beginDatePickerValueChanged:(UIDatePicker *)sender;
- (IBAction)endDatePickerValueChanged:(UIDatePicker *)sender;

- (IBAction)beginDateGestureRecognize:(UITapGestureRecognizer *)sender;

@property (strong, nonatomic) NSDate *beginDate;
@property (strong, nonatomic) NSDate *endDate;
@property (strong, nonatomic) UIAlertView *errorAlert;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;
@property BOOL isNewObject;

@end

@implementation ProjectDetailsViewController

#pragma mark - UIViewControllerDelegate

- (void)viewDidLoad {

    [super viewDidLoad];
    
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;

    self.notesTextView.delegate = self;
    
    if (self.fieldtrip == nil) {
        // create a new locality model
        [self createNewModelForEditing];
    } else {
        // show or edit a locality model
        [self showExistingModelForEditing];
    }
}

- (void)didReceiveMemoryWarning {

    [super didReceiveMemoryWarning];
}

#pragma mark - Form Data

- (void)showExistingModelForEditing {

    self.isNewObject = NO;
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem.title = @"Save";
    self.navigationItem.rightBarButtonItem.enabled = false;

    // wenn ein Wert verändert wurde: enablen.
    
    [self loadFormData];
}

- (void)createNewModelForEditing {
    
    self.isNewObject = YES;
    self.fieldtrip = [NSEntityDescription insertNewObjectForEntityForName:@"Project"
                                                   inManagedObjectContext:self.managedObjectContext];
    self.navigationItem.title = @"";
    self.navigationItem.rightBarButtonItem.title = @"Hinzufügen";
    self.navigationItem.rightBarButtonItem.enabled = false;

    // move to model logic:
    [self setModelWithDefaults];
    
    [self loadFormData];
}

#pragma mark - Form Data handling

- (void)loadFormData {
    
    self.nameTextField.text = self.fieldtrip.name;
    self.locationPrefixTextField.text = self.fieldtrip.locationPrefix;
    self.notesTextView.text = self.fieldtrip.notes;
    self.isActiveSwitch.on = [ActiveFieldtrip isActive:self.fieldtrip];
    self.beginDate = self.fieldtrip.beginDate;
    self.endDate = self.fieldtrip.endDate;
    
    // init date picker cells
    self.hideSectionsWithHiddenRows = YES;
    
    [self cell:self.beginDatePickerCell
     setHidden:YES];
    
    [self cell:self.endDatePickerCell
     setHidden:YES];
    
    [self reloadDataAnimated:NO];
    
    [self drawBeginDateCaption:_beginDate
                  isInEditMode:NO];
    [self drawEndDateCaption:_endDate
                isInEditMode:NO
                   beginDate:_beginDate];
    
    [self drawBeginDatePicker:_beginDate
                 isInEditMode:NO];
    
    [self drawEndDatePicker:_endDate
               isInEditMode:NO];
}

- (void)saveFormToModel {

    // set model data
    self.fieldtrip.name = self.nameTextField.text;
    self.fieldtrip.locationPrefix = self.locationPrefixTextField.text;
    self.fieldtrip.notes = self.notesTextView.text;
    self.fieldtrip.beginDate = self.beginDate;
    self.fieldtrip.endDate = self.endDate;

    NSError *error = nil;
    
    [self.managedObjectContext save:&error];
    
    if (error) {
        NSLog(@"Error: %@", [error localizedDescription]);
    }

    if ([ActiveFieldtrip isActive:self.fieldtrip] &&
        !self.isActiveSwitch.on) {

        [ActiveFieldtrip setActiveFieldtrip:nil];
    }
    else if (![ActiveFieldtrip isActive:self.fieldtrip] &&
        self.isActiveSwitch.on) {
        
        [ActiveFieldtrip setActiveFieldtrip:self.fieldtrip];
    }
}

// Standard Data for new Model
- (void)setModelWithDefaults {

    self.fieldtrip.name = nil;
    self.fieldtrip.beginDate = [DateUtility dateWithZeroSeconds:[NSDate date]];
    self.fieldtrip.endDate = [self.fieldtrip.beginDate dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * 8.0];
}

#pragma mark - UI Actions

- (void)formDidChanged:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = YES;
}

- (IBAction)nameEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)nameEditingChanged:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)locationPrefixEditingDidEnd:(UITextField *)sender {
    
    [self formDidChanged:sender];
}

- (IBAction)locationPrefixEditingChanged:(UITextField *)sender {

    [self formDidChanged:sender];
}

- (IBAction)isActiveSwitchDidChanged:(UISwitch *)sender {

    [self formDidChanged:sender];
}

- (IBAction)beginDatePickerValueChanged:(UIDatePicker *)sender {

    [self formDidChanged:sender];
    _beginDate = sender.date;
    _endDate = [_beginDate dateByAddingTimeInterval:60.0 * 60.0 * 24.0 * 8.0];
    [self drawDateRangeSelector];
}

- (IBAction)endDatePickerValueChanged:(UIDatePicker *)sender {

    [self formDidChanged:sender];
    _endDate = sender.date;
    [self drawDateRangeSelector];
}

- (IBAction)saveButton:(UIBarButtonItem *)sender {

    [self saveFormToModel];
    [self goToSettingsViewController];
}

- (IBAction)cancelButton:(UIBarButtonItem *)sender {

    [self goToSettingsViewController];
}

#pragma mark Navigation

- (void)goToSettingsViewController {
    
    UINavigationController *navigationController = self.navigationController;
    
    if (!self.isNewObject) {
        [navigationController popViewControllerAnimated:NO];
    }
    else if (self.isActiveSwitch.on) {
        [navigationController popViewControllerAnimated:NO];
    }
    
    [navigationController popViewControllerAnimated:YES];
}

#pragma mark - UITextViewDelegate -

- (void)textViewDidChange:(UITextView *)textView {

    [self formDidChanged:textView];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    
    [textView resignFirstResponder];
}

#pragma mark DateTime Range Interface Methods

- (IBAction)beginDateGestureRecognize:(UITapGestureRecognizer *)sender {
    
    [self toogleEditingBeginDate];
}

- (IBAction)endDateGestureRecognize:(UITapGestureRecognizer *)sender {

    [self toogleEditingEndDate];
}

#pragma mark - Date Range Stuff -

- (void)drawDateRangeSelector {
    
    [self drawBeginDateCaption:_beginDate
                  isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDateCaption:_endDate
                isInEditMode:[self isEndDateInEditMode]
                   beginDate:_beginDate];
    
    
    [self drawBeginDatePicker:_beginDate
                 isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDatePicker:_endDate
               isInEditMode:[self isEndDateInEditMode]];
}

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
    
    [self cell:pickerCell
     setHidden:NO];
    
    [self reloadDataAnimated:YES];
}

- (void)hideCellWithPicker:(UITableViewCell *)pickerCell {
    
    [self cell:pickerCell
     setHidden:YES];
    
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

- (void)drawBeginDatePicker:(NSDate *)beginDate
               isInEditMode:(BOOL)isInEditMode {
    
    self.beginDatePicker.datePickerMode = UIDatePickerModeDate;
    self.beginDatePicker.date = beginDate;
}

- (void)drawEndDatePicker:(NSDate *)endDate
             isInEditMode:(BOOL)isInEditMode {
    
    self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    self.endDatePicker.date = endDate;
}

- (void)drawBeginDateCaption:(NSDate *)beginDate
                isInEditMode:(BOOL)isInEditMode {

    // striketrought whether endDate is before beginDate
    BOOL strikethrough = [beginDate compare:beginDate] == NSOrderedDescending;
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyle]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter = [self dateFormatterEqualDayOmitting:NO];
    NSDateFormatter *timeFormatter = [self timeFormatter];
    
    // build the string together and render it
    NSString *beginDateString;
    beginDateString = [NSString stringWithFormat:@"\t%@\t%@",
                       [dateFormatter stringFromDate:beginDate],
                       [timeFormatter stringFromDate:beginDate]];
    
    NSAttributedString *attributetString;
    attributetString = [[NSAttributedString alloc] initWithString:beginDateString
                                                       attributes:attributes];
    
    self.beginDateLabel.attributedText = attributetString;
}

- (void)drawEndDateCaption:(NSDate *)endDate
              isInEditMode:(BOOL)isInEditMode
                 beginDate:(NSDate *)beginDate {
    
    BOOL strikethrough = ([beginDate compare:endDate] == NSOrderedDescending);
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyle]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter;
    dateFormatter = [self dateFormatterEqualDayOmitting:[DateUtility isDateSameDay:beginDate
                                                                            asDate:endDate]];
    
    NSDateFormatter *timeFormatter;
    timeFormatter = [self timeFormatter];
    
    // build the string together and render it
    NSString *endDateString;
    endDateString = [NSString stringWithFormat:@"\t%@\t%@",
                     [dateFormatter stringFromDate:endDate],
                     [timeFormatter stringFromDate:endDate]];
    
    NSAttributedString *attributetString;
    attributetString = [[NSAttributedString alloc] initWithString:endDateString
                                                       attributes:attributes];
    
    self.endDateLabel.attributedText = attributetString;
}

#pragma mark - generic DateRangePicker

- (NSDateFormatter *)dateFormatterEqualDayOmitting:(BOOL)isEqualDayOmitting {
    
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    dateFormatter.dateFormat = @"E, dd. MMMM Y";
    
    return dateFormatter;
}

- (NSDateFormatter *)timeFormatter {
    
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    
    timeFormatter.dateFormat = @"";
    
    return timeFormatter;
}

- (NSParagraphStyle *)paragraphStyle {
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
    
    NSTextTab *timeTab = [[NSTextTab alloc] initWithTextAlignment:NSTextAlignmentRight
                                                         location:200
                                                          options:[NSDictionary dictionary]];
    paragraphStyle.tabStops = @[timeTab];
    
    return (NSParagraphStyle *)paragraphStyle;
}

- (NSDictionary *)attributesWithParagraphStyle:(NSParagraphStyle *)paragraphStyle
                                     tintColor:(UIColor *)color
                                 strikethrough:(BOOL)strikethrough
                                  isInEditMode:(BOOL)isInEditMode {
    
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    if (isInEditMode == YES) {
        attributes[NSForegroundColorAttributeName] = color;;
    } else {
        attributes[NSForegroundColorAttributeName] = UIColor.blackColor;
    }
    
    if (strikethrough){
        attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleSingle];
    } else {
        attributes[NSStrikethroughStyleAttributeName] = [NSNumber numberWithInteger:NSUnderlineStyleNone];
    }
    
    return (NSDictionary *)attributes;
}

@end
