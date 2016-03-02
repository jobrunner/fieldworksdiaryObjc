//
//  SettingsController.m
//  fieldworksdiary
//
//  Created by Jo Brunner on 25.02.16.
//  Copyright © 2016 Jo Brunner. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsController.h"
#import "FieldtripPicker.h"
#import "Project.h"
#import "ActiveFieldtrip.h"
#import "RecordStatistics.h"

@interface SettingsController ()

@end

@implementation SettingsController

- (void)viewDidAppear:(BOOL)animated {
    
    // better to take this to viewDidLoad and lisen to some notifications...
    
    _fieldtripsCountLabel.text = [NSString stringWithFormat:@"%ld", [RecordStatistics fieldtripCount]];
    
    _activeFieldtripLabel.text = [ActiveFieldtrip name];

    
    
//    // getting the fieldtrip back from objectId url
//    NSURL *fieldtripUrl = [NSURL URLWithString:[[NSUserDefaults standardUserDefaults] objectForKey:@"activeFieldtrip"]];
//    
//    NSManagedObjectContext *managedObjectContext = [ApplicationDelegate managedObjectContext];
//    NSPersistentStoreCoordinator *persistentStoreCoordinator = [managedObjectContext persistentStoreCoordinator];
//    NSManagedObjectID *fieldtripID = [persistentStoreCoordinator managedObjectIDForURIRepresentation:fieldtripUrl];
//    NSError *error = nil;
//    Project *fieldtrip = (Project *)[managedObjectContext existingObjectWithID:fieldtripID
//                                                                         error:&error];
//    _activeFieldtripLabel.text = fieldtrip.name;
}

- (void)viewDidLoad {

    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(receivedNotification:)
                                                 name:@"FieldtripPickerSelectActiveFieldtrip"
                                               object:nil];
}

- (void)didReceiveMemoryWarning {
    
    [super didReceiveMemoryWarning];
}

#pragma mark - Notification handling

// receiver for notifications from NotificationCenter we are listen to
- (void)receivedNotification:(NSNotification *) notification {
    
    if ([[notification name] isEqualToString:@"FieldtripPickerSelectActiveFieldtrip"]) {

        NSLog(@"FieldtripPickerSelectActiveFieldtrip received");
        
//        if (countrySelector != nil) {
//            NSDictionary * country  = [countrySelector valueForKey:@"country"];
//            self.country = country;
//            NSString * countryName = [country valueForKey:@"country"];
//            
//            id view = [self.tableView viewWithTag:100];
//            
//            if (view != nil) {
//                [view setText:countryName];
//            }
//        }
    }
}

#pragma mark - FieldtripPicker Delegate

- (void)fieldtripPicker:(FieldtripPicker *)picker
     didSelectFieldtrip:(Project *)fieldtrip {
    
    [ActiveFieldtrip setActiveFieldtrip:fieldtrip];

    _activeFieldtripLabel.text = fieldtrip.name;
}


#pragma mark - Table view data source

//- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
//#warning Incomplete implementation, return the number of sections
//    return 0;
//}
//
//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//#warning Incomplete implementation, return the number of rows
//    return 0;
//}

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

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([[segue identifier] isEqualToString:@"FieldtripPickerSegue"]) {

        FieldtripPicker * controller = segue.destinationViewController;
        controller.delegate = self;
    }


}

- (IBAction)locationIdentifierPrefixTextFieldEditingDidEnd:(UITextField *)sender {
        
}

@end
