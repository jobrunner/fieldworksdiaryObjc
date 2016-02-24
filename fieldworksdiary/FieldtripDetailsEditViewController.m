//
//  MettLocalityEditViewController.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 05.04.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "FieldtripDetailsEditViewController.h"

@interface FieldtripDetailsEditViewController ()

@property (weak, nonatomic) IBOutlet UITextField *localityNameTextField;
@property (weak, nonatomic) IBOutlet UITextField *latituteTextField;
@property (weak, nonatomic) IBOutlet UITextField *longituteTextField;
@property (weak, nonatomic) IBOutlet UITextField *altitudeTextField;
@property (weak, nonatomic) IBOutlet UITextField *countryTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *subAdministrativeAreaTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeLocalityTextField;
@property (weak, nonatomic) IBOutlet UITextField *administrativeSubLocalityTextField;


///////////
@property (weak, nonatomic) IBOutlet UILabel *alldayDateLabel;
@property (weak, nonatomic) IBOutlet UISwitch *alldayDateSwitch;

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



- (IBAction)alldayDateChanges:(UISwitch *)sender;
- (IBAction)beginDateGestureRecognize:(UITapGestureRecognizer *)sender;
- (IBAction)endDateGestureRecognize:(UITapGestureRecognizer *)sender;
- (IBAction)beginDatePickerDidChange:(UIDatePicker *)sender;
- (IBAction)endDatePickerDidChange:(UIDatePicker *)sender;


@end

@implementation FieldtripDetailsEditViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    
    // read behavouir whether user preferes fulltime date ranges or not
    BOOL isFulltime = [self isAlldayDefaultForDateRange];
    
    // init date picker cells
    self.hideSectionsWithHiddenRows = YES;
    [self cell:self.beginDatePickerCell setHidden:YES];
    [self cell:self.endDatePickerCell setHidden:YES];
    [self reloadDataAnimated:NO];
    
    
    // setup fulltime switch
    self.alldayDateSwitch.on = isFulltime;
    
//    [self drawDateRangeSelector];
    
    [self drawBeginDateCaption:self.fieldtrip.beginDate isAllday:isFulltime isInEditMode:NO];
    
    [self drawEndDateCaption:self.fieldtrip.endDate isAllday:isFulltime isInEditMode:NO beginDate:self.fieldtrip.beginDate];
    
    [self drawBeginDatePicker:self.fieldtrip.beginDate isAllday:isFulltime isInEditMode:NO];
    
    [self drawEndDatePicker:self.fieldtrip.endDate isAllday:isFulltime isInEditMode:NO];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
//{
//#warning Potentially incomplete method implementation.
//    // Return the number of sections.
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
//{
//#warning Incomplete method implementation.
//    // Return the number of rows in the section.
//    return 0;
//}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


#pragma mark - Date Range Stuff -


- (void)drawDateRangeSelector
{
// Direkte Ansprache vom Model gefällt mir hier nicht!!!
    
    [self drawBeginDateCaption:self.fieldtrip.beginDate
                      isAllday:[self isAlldayMode]
                  isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDateCaption:self.fieldtrip.endDate
                    isAllday:[self isAlldayMode]
                isInEditMode:[self isEndDateInEditMode]
                   beginDate:self.fieldtrip.beginDate];
    
    
    [self drawBeginDatePicker:self.fieldtrip.beginDate
                     isAllday:[self isAlldayMode]
                 isInEditMode:[self isBeginDateInEditMode]];
    
    [self drawEndDatePicker:self.fieldtrip.endDate
                   isAllday:[self isAlldayMode]
               isInEditMode:[self isEndDateInEditMode]];
}

- (void)toogleEditingBeginDate
{
    if ([self isBeginDateInEditMode] == YES) {
        [self stopEditingBeginDate];
    } else {
        [self startEditingBeginDate];
    }
    [self stopEditingEndDate];
}


- (void)toogleEditingEndDate
{
    if ([self isEndDateInEditMode] == YES) {
        [self stopEditingEndDate];
    } else {
        [self startEditingEndDate];
    }
    [self stopEditingBeginDate];
}


- (void)showCellWithPicker:(UITableViewCell *)pickerCell
{
    [self cell:pickerCell setHidden:NO];
    [self reloadDataAnimated:YES];
}


- (void)hideCellWithPicker:(UITableViewCell *)pickerCell
{
    [self cell:pickerCell setHidden:YES];
    [self reloadDataAnimated:YES];
}


- (void)startEditingBeginDate
{
    [self showCellWithPicker:self.beginDatePickerCell];
    
    [self drawDateRangeSelector];
}


- (void)stopEditingBeginDate
{
    [self hideCellWithPicker:self.beginDatePickerCell];
    
    [self drawDateRangeSelector];
}


- (void)startEditingEndDate
{
    [self showCellWithPicker:self.endDatePickerCell];
    
    [self drawDateRangeSelector];
}


- (void)stopEditingEndDate
{
    [self hideCellWithPicker:self.endDatePickerCell];
    
    [self drawDateRangeSelector];
}


// assumeed the preference is set in settings bundle
- (BOOL)isAlldayDefaultForDateRange
{
    // Read and use the default behaviour for presenting date ranges
    NSUserDefaults *preferences = [NSUserDefaults standardUserDefaults];
    
    if (nil == [preferences objectForKey:@"locationDateFulltime"]) {
        [preferences setBool:NO forKey:@"locationDateFulltime"];
    }
    
    return [preferences boolForKey:@"locationDateFulltime"];
}


- (BOOL)isBeginDateInEditMode
{
    return ([self cellIsHidden:self.beginDatePickerCell] == NO);
}


- (BOOL)isEndDateInEditMode
{
    return ([self cellIsHidden:self.endDatePickerCell] == NO);
}


- (void)drawBeginDatePicker:(NSDate *)beginDate
                   isAllday:(BOOL)isAllday
               isInEditMode:(BOOL)isInEditMode
{
    if (isAllday == YES) {
        self.beginDatePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        self.beginDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    [self.beginDatePicker setDate:beginDate];
}


- (void)drawEndDatePicker:(NSDate *)endDate
                 isAllday:(BOOL)isAllday
             isInEditMode:(BOOL)isInEditMode
{
    if (isAllday == YES) {
        self.endDatePicker.datePickerMode = UIDatePickerModeDate;
    } else {
        self.endDatePicker.datePickerMode = UIDatePickerModeDateAndTime;
    }
    
    [self.endDatePicker setDate:endDate];
}




- (void)drawBeginDateCaption:(NSDate *)beginDate
                    isAllday:(BOOL)isAllday
                isInEditMode:(BOOL)isInEditMode
{
    // striketrought whether endDate is before beginDate
    BOOL strikethrough = [beginDate compare:beginDate] == NSOrderedDescending;
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyleWithAllday:isAllday]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                           isAllday:isAllday
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter;
    dateFormatter= [self dateFormatterWithAllday:isAllday
                              isEqualDayOmitting:NO];
    
    NSDateFormatter *timeFormatter;
    timeFormatter = [self timeFormatterWithAllday:isAllday];
    
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
                  isAllday:(BOOL)isAllday
              isInEditMode:(BOOL)isInEditMode
                 beginDate:(NSDate *)beginDate
{
    // striketrought whether date and time is shown and endDate is before beginDate
    BOOL strikethrough = (isAllday == NO) && ([beginDate compare:endDate] == NSOrderedDescending);
    
    NSDictionary * attributes;
    attributes = [self attributesWithParagraphStyle:[self paragraphStyleWithAllday:isAllday]
                                          tintColor:self.view.tintColor
                                      strikethrough:strikethrough
                                           isAllday:isAllday
                                       isInEditMode:isInEditMode];
    
    NSDateFormatter *dateFormatter;
    dateFormatter= [self dateFormatterWithAllday:isAllday
                              isEqualDayOmitting:[self isDateSameDay:beginDate
                                                              asDate:endDate]];
    
    NSDateFormatter *timeFormatter;
    timeFormatter = [self timeFormatterWithAllday:isAllday];
    
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


- (BOOL)isAlldayMode
{
    if ([self.fieldtrip.isFullTime isEqual:@YES]) {
        return YES;
    } else {
        return NO;
    }
}


- (NSDateFormatter *)dateFormatterWithAllday:(BOOL)isAllday
                          isEqualDayOmitting:(BOOL)isEqualDayOmitting
{
    NSDateFormatter *dateFormatter = [NSDateFormatter new];
    
    if (isAllday == YES) {
        dateFormatter.dateFormat = @"E, dd. MMMM Y";
    } else {
        // Ausnahme für endDate:
        if (isEqualDayOmitting == YES) {
            dateFormatter.dateFormat = @"";
        } else {
            dateFormatter.dateFormat = @"dd. MMMM Y";
        }
    }
    
    return dateFormatter;
}


- (NSDateFormatter *)timeFormatterWithAllday:(BOOL)isAllday
{
    NSDateFormatter *timeFormatter = [NSDateFormatter new];
    
    if (isAllday == YES) {
        timeFormatter.dateFormat = @"";
    } else {
        timeFormatter.dateFormat = @"HH:mm";
    }
    
    return timeFormatter;
}


- (NSParagraphStyle *)paragraphStyleWithAllday:(BOOL)isAllday
{
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
    } else {
        paragraphStyle.tabStops = @[dateTab, timeTab];
    }
    
    return (NSParagraphStyle *)paragraphStyle;
}


- (NSDictionary *)attributesWithParagraphStyle:(NSParagraphStyle *)paragraphStyle
                                     tintColor:(UIColor *)color
                                 strikethrough:(BOOL)strikethrough
                                      isAllday:(BOOL)isAllday
                                  isInEditMode:(BOOL)isInEditMode
{
    NSMutableDictionary *attributes = [NSMutableDictionary dictionary];
    
    attributes[NSParagraphStyleAttributeName] = paragraphStyle;
    
    // tint caption when edditing
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



#pragma mark - Date Utils -


- (BOOL)isDateSameDay:(NSDate *)firstDate asDate:(NSDate *)secondDate
{
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *firstDateComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                       fromDate:firstDate];
    
    NSDateComponents *secondDateComponent = [calendar components:NSDayCalendarUnit|NSMonthCalendarUnit|NSYearCalendarUnit
                                                        fromDate:secondDate];
    
    return ([firstDateComponent isEqual:secondDateComponent]);
}


- (NSDate *)dateWithZeroSeconds:(NSDate *)date
{
    NSTimeInterval time = floor([date timeIntervalSinceReferenceDate] / 60.0) * 60.0;
    
    return  [NSDate dateWithTimeIntervalSinceReferenceDate:time];
}




#pragma mark - Date Picker IBActions

- (IBAction)beginDateGestureRecognize:(UITapGestureRecognizer *)sender
{
    [self toogleEditingBeginDate];
}

- (IBAction)endDateGestureRecognize:(UITapGestureRecognizer *)sender
{
    [self toogleEditingEndDate];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSIndexPath * beginIndexPath = [self.tableView indexPathForCell:self.beginDateCell];

    NSIndexPath * endIndexPath = [self.tableView indexPathForCell:self.endDateCell];
    
    if (indexPath == beginIndexPath) {
        [self toogleEditingBeginDate];
    }
    if (indexPath == endIndexPath) {
        [self toogleEditingEndDate];
    }
}


- (IBAction)alldayDateChanges:(UISwitch *)sender
{
//    self.fieldtrip.isFullTime = sender.on;
    
    if (sender.on == YES) {
        self.fieldtrip.isFullTime = @YES;
    } else {
        self.fieldtrip.isFullTime = @NO;
    }
    
//    _isAllday = sender.on;
    
    [self drawDateRangeSelector];
}


- (IBAction)beginDatePickerDidChange:(UIDatePicker *)picker
{
    self.fieldtrip.beginDate = picker.date;
    self.fieldtrip.endDate = [self.fieldtrip.beginDate dateByAddingTimeInterval:60.0 * 60.0]; // adding 1 hour to beginDate
    
    [self drawDateRangeSelector];
}


- (IBAction)endDatePickerDidChange:(UIDatePicker *)picker
{
    self.fieldtrip.endDate = picker.date;
    
    [self drawDateRangeSelector];
}


@end
