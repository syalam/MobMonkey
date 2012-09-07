//
//  MMSettingsViewController.m
//  MobMonkey
//
//  Created by Sheehan Alam on 6/24/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMSettingsViewController.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMSetTitleImage.h"

@interface MMSettingsViewController ()

@end

@implementation MMSettingsViewController
@synthesize contentList = _contentList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];

    selectionDictionary = [[NSMutableDictionary alloc]init];
    
    
    NSMutableArray *tableContentArray = [NSMutableArray arrayWithObjects:@"My Info", @"My Rewards", @"Request Activity", @"Social Networks", @"Favorite Categories", nil];
    
    [self setContentList:tableContentArray];
    
    self.title = @"Settings";
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id contentForThisRow = [_contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    switch (indexPath.row) {
        case 1:
            cell.backgroundColor = [UIColor grayColor];
            cell.selectionStyle = UITableViewCellSelectionStyleNone;
            break;
            
        default:
            break;
    }
    
    cell.textLabel.text = contentForThisRow;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
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
        [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
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
    switch (indexPath.row) {
        case 0: {
            MMSignUpViewController *myInfoVc = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
            myInfoVc.title = @"My Info";
            [self.navigationController pushViewController:myInfoVc animated:YES];
        }
            
            break;
            
        default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - UINavBar Methods
- (IBAction)signInButtonTapped:(id)sender {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [self.navigationController presentViewController:navC animated:YES completion:NULL];
}

@end
