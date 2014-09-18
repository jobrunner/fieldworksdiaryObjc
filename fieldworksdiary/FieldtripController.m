//
//  FieldtripViewTableViewController.m
//  sunrise
//
//  Created by Jo Brunner on 23.06.14.
//  Copyright (c) 2014 Jo Brunner. All rights reserved.
//

#import "FieldtripController.h"

@interface FieldtripController ()

@property (nonatomic, strong) NSMutableDictionary * form;
@property (strong, nonatomic) NSManagedObjectContext * managedObjectContext;

@end

@implementation FieldtripController


#pragma mark - ViewController Delegates -


- (void)viewDidLoad
{
    [super viewDidLoad];

    // ??? es ist gruselig, das über AppDelegate zu machen
    AppDelegate * appDelegate = [UIApplication sharedApplication].delegate;
    self.managedObjectContext = appDelegate.managedObjectContext;
    

    // register custom cell "TextFieldCell" for queueing
    [self.tableView registerNib:[UINib nibWithNibName:[TextFieldCell reuseIdentifier]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[TextFieldCell reuseIdentifier]];

    //
    [self.tableView registerNib:[UINib nibWithNibName:[FieldtripDetailsSummaryCell reuseIdentifier]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[FieldtripDetailsSummaryCell reuseIdentifier]];
    

    [self.tableView registerNib:[UINib nibWithNibName:[ImageViewCell reuseIdentifier]
                                               bundle:[NSBundle mainBundle]]
         forCellReuseIdentifier:[ImageViewCell reuseIdentifier]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
//    return [self.form[@"sections"] count];
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) return 3;
    if (section == 1) return 1; // Specimens-Count later

    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // FUNDORT
    if (indexPath.section == 0) {
        
        // locationName text field
        if (indexPath.row == 0) {

            TextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:[TextFieldCell reuseIdentifier]
                                                                  forIndexPath:indexPath];

            cell.textField.text = self.fieldtrip.localityName;

            return cell;
        }

        
        // Fieldtrip details
        if (indexPath.row == 1) {

            FieldtripDetailsSummaryCell *cell = [tableView dequeueReusableCellWithIdentifier:[FieldtripDetailsSummaryCell reuseIdentifier]
                                                                         forIndexPath:indexPath];
            
            cell.fieldtrip = self.fieldtrip;

            return cell;
        }
        
        
        // Image Map
        if (indexPath.row == 2) {
            ImageViewCell *cell = [tableView dequeueReusableCellWithIdentifier:[ImageViewCell reuseIdentifier]
                                                                  forIndexPath:indexPath];
            // das gehört weder in den Controller, noch in die Cell.
            // das gehört als transientes Zeug ins Model.
            // Und weil die MapView mit dem Thumbnail eh scheiße ist,
            // wäre ein eigens Model für die MapView angebracht.
            // Mit dem könnte man sowohl interaktive Karten darstellen als
            // auch für einen speziellen Fall eine kleine statische Karte...
            
            NSString *imageMapPath = [NSHomeDirectory() stringByAppendingPathComponent:[NSString stringWithFormat:@"Library/Caches/Maps/%@", self.fieldtrip.mapImageFilename]];
            
            NSData *imageMapData = [NSData dataWithContentsOfFile:imageMapPath];

            cell.viewImageView.image = [UIImage imageWithData:imageMapData];

            return cell;
        }

        // Images scroll view
        if (indexPath.row == 3) {

        }
    }

    // SPECIMENS
    if (indexPath.section == 1) {
    }
    
    
    UITableViewCell * dummyCell;
    dummyCell = [tableView dequeueReusableCellWithIdentifier:@"DummyCell"
                                                forIndexPath:indexPath];
    
    NSLog(@"class of used cell: %@", [dummyCell class]);
    
    dummyCell.textLabel.text = @"Dummy Cell";
    
    return dummyCell;
}


- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 44.0;
}

- (void)tableView:(UITableView *)tableView
willDisplayHeaderView:(UIView *)view
       forSection:(NSInteger)section
{
    if (section == 1) {
        CGRect frame = tableView.frame;
        
        UIButton *addSpecimenButton = [UIButton buttonWithType:UIButtonTypeContactAdd];
        
        addSpecimenButton.frame = CGRectMake(frame.size.width-60, 10, 50, 30);
        
        [addSpecimenButton addTarget:self
                              action:@selector(addSpecimenToucheUpInside)
                    forControlEvents:UIControlEventTouchUpInside];
        
        [view addSubview:addSpecimenButton];
    }
}


- (void)addSpecimenToucheUpInside
{
    [self performSegueWithIdentifier:@"addSpecimenSegue" sender:self];
}


- (NSString *)tableView:(UITableView *)tableView
titleForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return @"Locality";
    }
    
    if (section == 1) {
        return @"Specimen";
    }
    
    return @"";
}


- (CGFloat)tableView:(UITableView *)tableView
heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0 && indexPath.row == 1) {
        return 226;
    }
    
    if (indexPath.section == 0 && indexPath.row == 2) {
        return 174;
    }
    
    return 44;
}



/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Table view delegate

// In a xib-based application, navigation from a table can be handled in -tableView:didSelectRowAtIndexPath:
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here, for example:
    // Create the next view controller.
    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
    
    // Pass the selected object to the new view controller.
    
    // Push the view controller.
    [self.navigationController pushViewController:detailViewController animated:YES];
}
*/

@end
