//
//  MMFilterViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMFilterViewController.h"
#import "MMSetTitleImage.h"

@interface MMFilterViewController ()

@end

@implementation MMFilterViewController
@synthesize delegate;

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
    self.title = @"Filter/Search";
    
    self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchButtonClicked:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    prefs = [NSUserDefaults standardUserDefaults];
    
    NSMutableArray *tableContent = [NSMutableArray arrayWithObjects:@"MobMonkey User Image", @"MobMonkey User Video", @"MobMonkey Location Video", @"MobMonkey Location Live Streaming Video", nil];
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
- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IBAction Methods
- (IBAction)segmentedControlSelected:(id)sender {
    [prefs setInteger:segmentedControl.selectedSegmentIndex forKey:@"savedSegmentValue"];
    [prefs synchronize];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id contentForThisRow = [_contentList objectAtIndex:indexPath.row];
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
    cell.textLabel.text = contentForThisRow;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

@end
