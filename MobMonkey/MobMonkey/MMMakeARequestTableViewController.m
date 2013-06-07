//
//  MMMakeARequestTableViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMakeARequestTableViewController.h"
#import "MMIconTitleSubTextTableViewCell.h"
#import "MMRequestMessageViewController.h"

@interface MMMakeARequestTableViewController ()

@property (nonatomic, strong) NSString * messageString;
@property (nonatomic, strong) NSString * scheduleString;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIFont *scheduleFont;
@property (nonatomic, strong) UIButton *makeRequestButton;
@end

@implementation MMMakeARequestTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 50)];
    _segmentControl = [[UISegmentedControl alloc] initWithItems:@[@"Video", @"Photo", @"Text"]];
    _segmentControl.frame = CGRectMake(5, 3, self.view.frame.size.width - 10, 50 - 6);
    _segmentControl.selectedSegmentIndex = 0;
    [_segmentControl addTarget:self action:@selector(mediaToggleChanged:) forControlEvents:UIControlEventValueChanged];
    [headerView addSubview:_segmentControl];
    self.tableView.tableHeaderView = headerView;
    
    UINib *nib = [UINib nibWithNibName:@"MMIconTitleSubTextTableViewCell" bundle:nil];
    [[self tableView] registerNib:nib forCellReuseIdentifier:@"IconTitleSubTextCell"];
    
    
    self.messageString = @"Please show me what's happening there, thank you!!";
    self.scheduleString = @"Today, 4:45pm, Not Recurring";
    
    self.messageFont = [UIFont fontWithName:@"Helvetica" size:14];
    self.scheduleFont = [UIFont fontWithName:@"Helvetica-LightOblique" size:14];
    
    self.makeRequestButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [self.makeRequestButton setTitle:@"Make Video Request" forState:UIControlStateNormal];
    self.makeRequestButton.frame = CGRectMake(25, 25, self.tableView.frame.size.width - 50, 40);
    
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 70)];
    
    [footerView addSubview:_makeRequestButton];
    
    self.tableView.tableFooterView = footerView;
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)mediaToggleChanged:(UISegmentedControl *)sender{
    
    if(sender.selectedSegmentIndex == 0 ){
        [self.makeRequestButton setTitle:@"Make Video Request" forState:UIControlStateNormal];
    }else if(sender.selectedSegmentIndex == 1){
        [self.makeRequestButton setTitle:@"Make Photo Request" forState:UIControlStateNormal];
    }else if(sender.selectedSegmentIndex == 2){
        [self.makeRequestButton setTitle:@"Make Text Request" forState:UIControlStateNormal];
    }
    
}
-(void)viewWillLayoutSubviews {
    [super viewWillLayoutSubviews];
    
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"IconTitleSubTextCell";
    MMIconTitleSubTextTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMIconTitleSubTextTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    switch (indexPath.row) {
        case 0:
            cell.titleLabel.text = @"Include Message";
            cell.accessoryLabel.text = nil;
            cell.textView.text = self.messageString;
            cell.iconView.image = [UIImage imageNamed:@"compose2"];
            break;
        case 1:
            cell.titleLabel.text = @"Schedule Request";
            cell.accessoryLabel.text = nil;
            cell.textView.text = self.scheduleString;
            cell.iconView.image = [UIImage imageNamed:@"calendar"];
            break;
        case 2:
            cell.titleLabel.text = @"Duration";
            cell.accessoryLabel.text = @" 30 mins";
            cell.iconView.image = [UIImage imageNamed:@"clock"];
            cell.textView.text = nil;
        default:
            break;
    }
    
    // Configure the cell...
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    CGFloat cellHeight = 50;
    
    if(indexPath.row == 0){
        CGSize messageSize = [self.messageString sizeWithFont:self.messageFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 35, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        cellHeight += messageSize.height + 10;
        
    }else if(indexPath.row == 1){
        CGSize scheduleSize = [self.scheduleString sizeWithFont:self.scheduleFont constrainedToSize:CGSizeMake(self.tableView.frame.size.width - 35, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
        
        cellHeight += scheduleSize.height + 10;
    }
    return cellHeight;
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
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
    switch (indexPath.row) {
        case 0: {
            
            break;
        }
            
        default:
            break;
    }
    
}

@end
