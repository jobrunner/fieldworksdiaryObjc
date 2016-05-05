#import <UIKit/UIKit.h>

@class ImageScrollViewCell;

@protocol ImageScrollViewCellDelegate;


@interface ImageScrollViewCell : UITableViewCell<UIScrollViewDelegate>

/**
 *  Delegate object.
 */
@property (nonatomic, weak) id<ImageScrollViewCellDelegate> delegate;

/**
 * Dictionary with image paths
 */
@property (nonatomic, strong) NSMutableSet *images;
@property (nonatomic, strong) UIColor *backgroundColor;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

- (void)addImages:(NSArray *)images;

@end

@protocol ImageScrollViewCellDelegate <NSObject>

@optional

// Sinnvoller vielleicht, hier sowohl das Model des Bildes zu übergeben
- (void)imageScrollViewCell:(ImageScrollViewCell *)cell
             didSelectImage:(id)item;

@end