//
//  ImageScrollCellTableViewCell.m
//  ThumbnailScroller
//
//  Created by Jo Brunner on 22.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "ImageScrollViewCell.h"

@interface ImageScrollViewCell()

@property NSMutableArray * imageWidths;
@property CGFloat lastContentOffset;

@end

@implementation ImageScrollViewCell
{
    struct {
        unsigned int didSelectImage:1;
    } delegateRespondsTo;
    
}

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    _scrollView.autoresizingMask = UIViewAutoresizingNone;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.backgroundColor = _backgroundColor;
    _scrollView.pagingEnabled = NO;
    _scrollView.bounces = YES;
    _scrollView.delegate = self;
}


- (void)setDelegate:(id <ImageScrollViewCellDelegate>)delegate {
    
    if (_delegate != delegate) {
        _delegate = delegate;
        
        delegateRespondsTo.didSelectImage = [_delegate respondsToSelector:@selector(imageScrollViewCell:didSelectImage:)];
    }
}


// Die Methode fügt UIImages hinzu.
// D.h. sowohl ins Model, als auch Runterrechnen und anzeigen etc.
- (void)setImages:(NSArray *)images {
    
    if (!images) {
        
        return;
    }
    
    for (UIView *v in self.scrollView.subviews) {
        if ([v isKindOfClass:[UIImageView class]] && v.tag > 0) {
            [v removeFromSuperview];
        }
    }
    
    CGFloat lastWidth = 0.0;
    NSInteger i = 0;

    for (UIImage *image in images) {
        
        // filenamen zu den originaldaten erzeugen
        // Image-Object mit Metadaten erzeugen
        // Image-Object an fieldtrip speichern
        //
        //        NSData *pngImageData = UIImagePNGRepresentation(image);
        
        // create a filename based on sha1
        //        NSString *sha1Hash = [Crypto sha1WithBinary:pngImageData];
        //        NSString *filename = [NSString stringWithFormat:@"%@.png", sha1Hash];
        
        // {{{ create Image object
        // siehe fieldworksdiary...
        // }}}
        
        float viewHeight = self.scrollView.frame.size.height;
        
        CGSize size = CGSizeMake(image.size.width * (viewHeight / image.size.height), viewHeight);
        
        UIImage *thumbnail = [self imageWithImage:image
                                     scaledToSize:size];
        
        UIImageView *imageView = [[UIImageView alloc] initWithImage:thumbnail];
        
        imageView.frame = CGRectMake(lastWidth, 0, size.width, size.height);
        
        lastWidth = lastWidth + size.width;
        
        imageView.userInteractionEnabled = YES;
        imageView.backgroundColor = _backgroundColor;
        imageView.tag = ++i;
        
        UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                        initWithTarget:self
                                                        action:@selector(handleTouch:)];
        [imageView addGestureRecognizer:tapGestureRecognizer];
        
        self.scrollView.contentSize = CGSizeMake(lastWidth, 44);
        [self.scrollView addSubview:imageView];
    }
}


- (IBAction)handleTouch:(UITapGestureRecognizer *)sender {
    
    UIImageView *imageView = (UIImageView *)sender.view;
    
    [self.delegate imageScrollViewCell:self
                    didSelectImage:imageView.image];
}


// Thumnbail berechnen. Muss in eine eigene Klasse oder als Kategorie hinzugefügt werden
- (UIImage *)imageWithImage:(UIImage *)image
               scaledToSize:(CGSize)newSize {
    
    if ([[UIScreen mainScreen] respondsToSelector:@selector(scale)]) {
        if ([[UIScreen mainScreen] scale] == 2.0) {
            UIGraphicsBeginImageContextWithOptions(newSize, YES, 2.0);
        } else {
            UIGraphicsBeginImageContext(newSize);
        }
    } else {
        UIGraphicsBeginImageContext(newSize);
    }
    [image drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
}
@end
