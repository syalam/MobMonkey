//
//  MMLocationsViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationsViewController.h"
#import "MMLocationListCell.h"
#import "SVProgressHUD.h"

@interface MMLocationsViewController ()

@end

@implementation MMLocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.locations = @[];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    double latitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"latitude"]doubleValue];
    double longitude = [[[NSUserDefaults standardUserDefaults]objectForKey:@"longitude"]doubleValue];
    NSLog(@"%f, %f", latitude, longitude);
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setObject:[NSNumber numberWithDouble:latitude]forKey:@"latitude"];
    [params setObject:[NSNumber numberWithDouble:longitude]forKey:@"longitude"];
//    if ([filters valueForKey:@"radius"]) {
//        [params setObject:[filters valueForKey:@"radius"] forKey:@"radiusInYards"];
//    }
//    else {
        [params setObject:[NSNumber numberWithInt:200] forKey:@"radiusInYards"];
//    }
    
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:params
                                                       options:NSJSONWritingPrettyPrinted error:nil];
    id jsonObject = [NSJSONSerialization JSONObjectWithData:jsonData options:0 error:nil];
    
    NSLog(@"%@", jsonObject);
    [SVProgressHUD showWithStatus:@"Searching"];
    [MMAPI searchForLocation:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (!self.view.isHidden) {
            [SVProgressHUD dismiss];
            self.locations = responseObject;
            [self.tableView reloadData];
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD dismissWithError:[error description]];
    }];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.locations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.location = [self.locations objectAtIndex:indexPath.section];
    
    return cell;
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
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
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

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [[MMClientSDK sharedSDK]locationScreen:self locationDetail:[self.locations objectAtIndex:indexPath.section]];
}

@end
