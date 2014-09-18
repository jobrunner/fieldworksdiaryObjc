//
//  ImageViewTableViewCell.m
//  sunrise
//
//  Created by Jo Brunner on 23.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "ImageViewCell.h"

@interface ImageViewCell()


@end

@implementation ImageViewCell


//- (void)setViewImage:(UIImage *)image
//{
//    _viewImageView.image = image;
//}
//
//- (UIImage *)viewImage
//{
//    return _viewImageView.image;
//}


- (NSString *)reuseIdentifier
{
    return [ImageViewCell reuseIdentifier];
}


+ (NSString *)reuseIdentifier
{
    return @"ImageViewCell";
}

@end
