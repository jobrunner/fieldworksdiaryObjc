#import "FieldtripDetailsProjectCell.h"

@implementation FieldtripDetailsProjectCell

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
}


- (NSString *)reuseIdentifier
{
    return [FieldtripDetailsProjectCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    static NSString *identifier = @"FieldtripDetailsProjectCell";
    
    return identifier;
}


@end
