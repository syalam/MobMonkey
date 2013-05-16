//
//  MMEditHotSpotViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/2/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMEditHotSpotViewController.h"
#import "MMTextFieldCell.h"
#import "UIAlertView+Blocks.h"
#import "UIActionSheet+Blocks.h"

@interface MMEditHotSpotViewController ()

@end

@implementation MMEditHotSpotViewController

@synthesize parentLocation = _parentLocation;
@synthesize sublocationInformation;

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
    
    self.tableView = [[TPKeyboardAvoidingTableView alloc] initWithFrame:self.view.frame style:UITableViewStyleGrouped];
    
    self.title = @"New Hot Spot";
    
    self.sublocationInformation = [[MMLocationInformation alloc] init];

    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    self.view.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    self.tableView.backgroundView = nil;
    
    
    self.mapSelectView = [[MMMapSelectView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 250)];
    self.tableView.tableHeaderView = self.mapSelectView;
    self.mapSelectView.parentLocation = self.parentLocation;
    self.mapSelectView.delegate =self;
    
    self.cellLabels = @[@"Name", @"Description", @"Range"];
    
    createSubLocationButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, self.view.frame.size.width - 40, 50)];
    
    UIImage *backgroundImage = [UIImage imageNamed:@"deselectedRectRed@2x"];
    [createSubLocationButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
    [createSubLocationButton setTitle:@"Create Hot Spot" forState:UIControlStateNormal];
    //createSubLocationButton.backgroundColor = [UIColor redColor];
    [createSubLocationButton addTarget:self action:@selector(createSubLocation:) forControlEvents:UIControlEventTouchUpInside];

    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 70)];
    
    [footerView addSubview:createSubLocationButton];
    self.tableView.tableFooterView = footerView;
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)createSubLocation:(id)sender{
    
    [self.view endEditing:YES];
    
    if(!sublocationInformation.latitude){
        sublocationInformation.latitude = [NSNumber numberWithDouble: self.mapSelectView.mapView.userLocation.coordinate.latitude];
    }
    
    if(!sublocationInformation.longitude){
         sublocationInformation.longitude = [NSNumber numberWithDouble: self.mapSelectView.mapView.userLocation.coordinate.longitude];
    }
    

    if (!self.nameText || self.nameText.length <= 0) {
        UIAlertView *noNameAlert = [[UIAlertView alloc] initWithTitle:@"Enter Name" message:@"Each Hot Spot must have a name" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noNameAlert show];
        return;
    }
    sublocationInformation.name =  self.nameText;
    
    sublocationInformation.details = self.descriptionText;
    
    if(!self.rangeText || self.rangeText.length <= 0){
        UIAlertView *noNameAlert = [[UIAlertView alloc] initWithTitle:@"Enter Range" message:@"Each Hot Spot must have a range" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [noNameAlert show];
        return;
    }
    
    sublocationInformation.parentLocation = self.parentLocation;
    sublocationInformation.locationID = nil;
    
    [SVProgressHUD showWithStatus:@"Creating Hot Spot"];
    
    [MMAPI createSubLocationWithLocationInformation:sublocationInformation success:^{
        
        [SVProgressHUD showSuccessWithStatus:@"Hot Spot Created"];
        [self.navigationController popToRootViewControllerAnimated:YES];
    
    } failure:^(NSError *error) {
    
        [SVProgressHUD showErrorWithStatus:@"Hot Spot Creation Failed"];
    
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)selectRange:(NSNumber*)rangeInMeters {
    
    MMTextFieldCell *cell = (MMTextFieldCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForItem:2 inSection:0]];
    
    NSString *rangeText = [NSString stringWithFormat:@"%d meters", rangeInMeters.integerValue];
    
    cell.textField.text = rangeText;
    
    self.rangeText = rangeText;
}
-(void)showRangeActionSheet {
    RIButtonItem *meter5 = [RIButtonItem itemWithLabel:@"5 meters"];
    RIButtonItem *meter10 = [RIButtonItem itemWithLabel:@"10 meters"];
    RIButtonItem *meter30 = [RIButtonItem itemWithLabel:@"30 meters"];
    RIButtonItem *meter50 = [RIButtonItem itemWithLabel:@"50 meters"];
    RIButtonItem *meter100 = [RIButtonItem itemWithLabel:@"100 meters"];
    
    RIButtonItem *cancelButton = [RIButtonItem itemWithLabel:@"Cancel"];
    
    [meter5 setAction:^{
        [self selectRange:@5];
    }];
    
    [meter10 setAction:^{
        [self selectRange:@10];
    }];
    
    [meter30 setAction:^{
        [self selectRange:@30];
    }];
    
    [meter50 setAction:^{
        [self selectRange:@50];
    }];
    
    [meter100 setAction:^{
        [self selectRange:@100];
    }];
    
    UIActionSheet *selectRangeAction = [[UIActionSheet alloc] initWithTitle:@"Select a Range" cancelButtonItem:cancelButton destructiveButtonItem:nil otherButtonItems:meter5, meter10, meter30, meter50, meter100, nil];
    
    [selectRangeAction showFromTabBar:self.tabBarController.tabBar];
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
    return self.cellLabels.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMTextFieldCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.textField.placeholder = [self.cellLabels objectAtIndex:indexPath.row];
    cell.textField.delegate = self;
    cell.textField.tag = indexPath.row;
    
    if(indexPath.row == 2){
        cell.selectionStyle = UITableViewCellSelectionStyleGray;
        cell.textField.enabled = NO;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textField.enabled = YES;
    }
    
    // Configure the cell...
    
    return cell;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Hot Spot Details";
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if(indexPath.section == 0 && indexPath.row == 2){
        NSLog(@"TOUCHED");
        [self showRangeActionSheet];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
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

#pragma mark - Map Select View Delegate
-(void)mapSelectView:(MMMapSelectView *)mapSelectView didSelectLocation:(CLLocationCoordinate2D)coordinate{
    
    self.sublocationInformation.latitude = [NSNumber numberWithFloat:coordinate.latitude];
    self.sublocationInformation.longitude = [NSNumber numberWithFloat:coordinate.longitude];

}
-(void)mapSelectViewUseCurrentLocation:(MMMapSelectView *)mapSelectView {
    self.sublocationInformation.latitude = nil;
    self.sublocationInformation.longitude = nil;
}

#pragma mark - TextField Delegate

-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    switch (textField.tag) {
        case 0:
            self.nameText = textField.text;
            break;
        case 1:
            self.descriptionText = textField.text;
            break;
        case 2:
            self.rangeText = textField.text;
            break;
            
        default:
            break;
    }
    

    
}
@end
