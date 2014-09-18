#import "TimeZoneTransformer.h"

@implementation TimeZoneTransformer

+ (Class)transformedValueClass
{
    return [NSData class];
}


+ (BOOL)allowsReverseTransformation
{
    return YES;
}


- (id)transformedValue:(id)value
{
    return [NSKeyedArchiver archivedDataWithRootObject:value];
}


- (id)reverseTransformedValue:(id)value
{
    return [NSKeyedUnarchiver unarchiveObjectWithData:value];
}

@end
