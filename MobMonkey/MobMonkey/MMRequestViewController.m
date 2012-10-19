//
//  MMRequestViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMRequestViewController.h"
#import "MMTableViewCell.h"

@interface MMRequestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *mediaTypeSegmentedControl;

- (IBAction)changeRequestDuration:(id)sender;
- (IBAction)changeMediaRequestType:(id)sender;

@end

@implementation MMRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.mediaTypeSegmentedControl.frame;
    frame.size.height = 64;
    self.mediaTypeSegmentedControl.frame = frame;
    [self.mediaTypeSegmentedControl setBackgroundImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *divider = [UIImage imageNamed:@"separator-gradient"];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 1) {
        return 3;
    }
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    MMTableViewCell *cell = nil;
    UIButton *removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [removeButton setBackgroundImage:[UIImage imageNamed:@"errorSmall"] forState:UIControlStateNormal];
    [removeButton setFrame:CGRectMake(0, 0, 13.0, 13.0)];
    switch (indexPath.section) {
        case 0:
            cell = [tableView dequeueReusableCellWithIdentifier:@"AddMessageCell"];
            break;
        case 1:
            if (indexPath.row == 0) {
                cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduleRequestCell"];
                break;
            }
            cell = [tableView dequeueReusableCellWithIdentifier:@"ScheduledRequestCell"];
            [cell setAccessoryView:removeButton];
            break;
        default:
            break;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat grey = 220.0/255.0;
    cell.backgroundView = nil;
    cell.backgroundColor = [UIColor colorWithRed:grey green:grey blue:grey alpha:1.0];
    return cell;
}


#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    if (indexPath.section == 0) {
        [self performSegueWithIdentifier:@"MessageSegue" sender:nil];
    }
}

- (void)viewDidUnload {
    [self setMediaTypeSegmentedControl:nil];
    [super viewDidUnload];
}
- (IBAction)changeMediaRequestType:(id)sender {
}
- (IBAction)changeRequestDuration:(id)sender {
}
@end
