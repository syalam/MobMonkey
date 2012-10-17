//
//  MMFilterViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMFilterViewController.h"
#import "MMSetTitleImage.h"
#import "MMAPI.h"
#import "MMCategoryCell.h"

@interface MMFilterViewController ()

@end

@implementation MMFilterViewController

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
    
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *sectionOneContent = [[NSMutableArray alloc]initWithObjects:@"", nil];
    NSMutableArray *sectionTwoContent = [NSMutableArray arrayWithObjects:@"MobMonkey User Image", @"MobMonkey User Video", @"MobMonkey Location Video", @"MobMonkey Location Live Streaming Video", nil];
    NSMutableArray *tableContent = [[NSMutableArray alloc]initWithObjects:sectionOneContent, sectionTwoContent, nil];
    [self setContentList:tableContent];
    
    if ([prefs integerForKey:@"savedSegmentValue"]) {
        segmentedControl.selectedSegmentIndex = [prefs integerForKey:@"savedSegmentValue"];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    segmentedControl.selectedSegmentIndex = [prefs integerForKey:@"savedSegmentValue"];
    [pickerView selectRow:[prefs integerForKey:@"savedPickerValue"] inComponent:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIBarButtonItem Action Methods
- (void)backButtonTapped:(id)sender {
    [_delegate setFilters:[NSDictionary dictionaryWithObjectsAndKeys:selectedRadius, @"radius", nil]];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IBAction Methods
- (IBAction)segmentedControlSelected:(id)sender {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            selectedRadius = [NSNumber numberWithInt:880];
            break;
        case 1:
            selectedRadius = [NSNumber numberWithInt:1760];
            break;
        case 2:
            selectedRadius = [NSNumber numberWithInt:8800];
            break;
        case 3:
            selectedRadius = [NSNumber numberWithInt:17600];
            break;
        case 4:
            selectedRadius = [NSNumber numberWithInt:35200];
            break;            
        default:
            break;
    }
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return _contentList.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    NSArray *sectionContent = [_contentList objectAtIndex:section];
    return sectionContent.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *sectionContent = [_contentList objectAtIndex:indexPath.section];
    id contentForThisRow = [sectionContent objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    if (indexPath.section == 0) {
        MMCategoryCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        cell = [[MMCategoryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.mmCategoryCellImageView.image = [UIImage imageNamed:@"monkey.jpg"];
        cell.mmCategoryTitleLabel.text = contentForThisRow;
        
        return cell;
    }
    else {
        UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Medium" size:14];
        cell.textLabel.lineBreakMode = UILineBreakModeWordWrap;
        cell.textLabel.numberOfLines = 2;
        cell.textLabel.text = contentForThisRow;
        return cell;
    }
}

#pragma mark - UITablview delegate
- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44;
    }
    else {
        return 60;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            selectedFilter = @"mmUserImage";
            break;
        case 1:
            selectedFilter = @"mmUserVideo";
            break;
        case 3:
            selectedFilter = @"mmLocationVideo";
            break;
        case 4:
            selectedFilter = @"mmLocationLiveStream";
            break;
        default:
            break;
    }
    
}

@end
