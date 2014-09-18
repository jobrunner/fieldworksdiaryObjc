@class Fieldtrip;

@protocol FieldtripDetailsCellProtocol <NSObject>

@property (strong, nonatomic) Fieldtrip *fieldtrip;

+ (NSString *)reuseIdentifier;

- (void)updateUserInterface;
- (void)setFieldtrip:(Fieldtrip *)fieldtrip;
- (Fieldtrip *)fieldtrip;

@end
