//
//  MMSlideMenuViewController.m
//  MobMonkey_LVF
//
//  Created by Michael Kral on 4/17/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import "MMSlideMenuViewController.h"
#import "MMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMMenuItems.h"
#import "MMMenuItem.h"

@interface MMSlideMenuViewController ()

@end

@implementation MMSlideMenuViewController

@synthesize menuTableView, searchBar, menuItems;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

-(void)setupViews{
    
    [searchBar setBackgroundImage:[UIImage new]];
    [searchBar setTranslucent:YES];
    [searchBar setBackgroundColor:[UIColor colorWithWhite:0.1 alpha:0.600]];
    
    self.view.backgroundColor = [UIColor redColor];
    
    UIImage *image = [UIImage imageNamed:@"darkLinenBackground.png"];
    UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
    [imageView setFrame:self.menuTableView.bounds];
    [self.menuTableView setBackgroundView:imageView];
    [self.menuTableView setBackgroundColor:[UIColor clearColor]];
    self.menuTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self setupViews];
    
    MMMenuItems *menuItemsModel = [MMMenuItems menuItems];
    menuItems = [menuItemsModel allMenuItems];
    [menuTableView reloadData];
    
   
    
    
    
    [self.slidingViewController setAnchorRightRevealAmount:265.0f];
    
    self.slidingViewController.underLeftWidthLayout = ECFullWidth;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

/* The following is from http://blog.shoguniphicus.com/2011/06/15/working-with-uigesturerecognizers-uipangesturerecognizer-uipinchgesturerecognizer/ */

#pragma mark - Table View Data Source
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return menuItems.count;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"MenuCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        UIView *cellBackgroundView = [[UIView alloc] init];
        [cellBackgroundView setBackgroundColor:[UIColor colorWithWhite:0.3 alpha:0.500]];
        cell.opaque = NO;
        [cell setBackgroundView:cellBackgroundView];
        [cell.textLabel setTextColor:[UIColor whiteColor]];
        [cell.textLabel setTextAlignment:NSTextAlignmentRight];
    }
    
    MMMenuItem *menuItem = [self.menuItems objectAtIndex:indexPath.row];


    cell.imageView.image = menuItem.image;
    cell.textLabel.text = menuItem.title;
    
    return cell;
    
}











@end
