//
//  ImageViewTableViewCell.h
//  sunrise
//
//  Created by Jo Brunner on 23.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ImageViewCell : UITableViewCell


@property (strong, nonatomic) IBOutlet UIImageView *viewImageView;


+ (NSString *)reuseIdentifier;

//- (void)setViewImage:(UIImage *)image;
//
//- (UIImage *)viewImage;

@end
