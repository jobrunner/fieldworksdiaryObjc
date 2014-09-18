//
//  InputTableViewCell.m
//  Fieldworksdiary
//
//  Created by Jo Brunner on 18.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "TextFieldCell.h"

@implementation TextFieldCell



- (NSString *)reuseIdentifier
{
    return [TextFieldCell reuseIdentifier];
}

+ (NSString *)reuseIdentifier
{
    return @"TextFieldCell";
}

@end
