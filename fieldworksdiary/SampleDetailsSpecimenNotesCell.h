@class Fieldtrip;

@interface SampleDetailsSpecimenNotesCell : UITableViewCell <UITextViewDelegate>

@property (strong, nonatomic) Fieldtrip *sample;
@property (weak, nonatomic) IBOutlet UITextView *specimenNotesTextView;

// hack...
@property (strong, nonatomic) UITableView *tableView;

- (void)setSample:(Fieldtrip *)sample;
- (Fieldtrip *)sample;

@end
