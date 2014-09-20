#import "FieldtripDetailsCellProtocol.h"

@class Fieldtrip;

@interface FieldtripDetailsSpecimenNotesCell : UITableViewCell <FieldtripDetailsCellProtocol, UITextViewDelegate>

@property (strong, nonatomic) Fieldtrip *fieldtrip;

@property (weak, nonatomic) IBOutlet UITextView *specimenNotesTextView;

@end
