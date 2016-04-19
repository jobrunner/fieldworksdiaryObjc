//
//  CoordinateSystemsController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 10.04.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "CoordinateSystemsListController.h"
#import "CoordinateSystem.h"

@implementation CoordinateSystemsListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

- (void)tableView:(UITableView *)tableView
didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NSLog(@"Selected: %ld", (long)indexPath.item);
    
    if ([self.delegate respondsToSelector:@selector(coordinateSystemsList:didSelectCoordinateSystem:)]) {

        CoordinateSystem *coordinateSystem;

        // hack
        NSLocale *locale = [NSLocale currentLocale];
        
        switch (indexPath.item) {
            // MGRS
            case 1:
                coordinateSystem = [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemMGRS
                                                                      datum:kMapDatumWGS1984
                                                                     format:kCoordinateFormatMGRSDefault
                                                          localeForDecimals:locale
                                                          leadingHemisphere:YES
                                                                  seperator:@" "];
                break;
                
            // UTM
            case 2:
                coordinateSystem = [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemUTM
                                                                      datum:kMapDatumWGS1984
                                                                     format:kCoordinateFormatUTMWithGridZone
                                                          localeForDecimals:locale
                                                          leadingHemisphere:YES
                                                                  seperator:@" "];
                break;
                
            // Geodetic
            case 0:
            default:
                coordinateSystem =
                [[CoordinateSystem alloc] initWithSystem:kCoordinateSystemGeodetic
                                                   datum:kMapDatumWGS1984
                                                  format:kCoordinateFormatGeodeticDecimalSign
                                       localeForDecimals:locale
                                       leadingHemisphere:YES
                                               seperator:@" "];
                break;
        }

        [self.delegate coordinateSystemsList:self
                   didSelectCoordinateSystem:coordinateSystem];
        
        UINavigationController *navigationController = self.navigationController;
        [navigationController popViewControllerAnimated:YES];
    }
}




/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:<#@"reuseIdentifier"#> forIndexPath:indexPath];
    
    // Configure the cell...
    
    return cell;
}
*/

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
