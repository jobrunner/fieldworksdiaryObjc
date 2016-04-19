//
//  CoordinateSystemsController.h
//  fieldworksdiary
//
//  Created by Jo Brunner on 10.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

@class CoordinateSystem;

@protocol CoordinateSystemsListDelegate;

@interface CoordinateSystemsListController : UITableViewController

@property (nonatomic, weak) id<CoordinateSystemsListDelegate> delegate;

@end

@protocol CoordinateSystemsListDelegate <NSObject>

@optional

- (void)coordinateSystemsList:(CoordinateSystemsListController *)controller
    didSelectCoordinateSystem:(CoordinateSystem *)coordinateSystem;

@end