//
//  FilterViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/5/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "FilterViewController.h"

@interface FilterViewController ()

@end

@implementation FilterViewController
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
    
    pickerArray = [[NSMutableArray alloc]initWithObjects:@"Food & Beverage", @"Shopping", @"legal & financial", @"business & professional services", @"real estate & home improvement", @"education", @"travel & tourism", @"community & government",
                   @"health & medicine", @"personal care & services", @"automotive", @"arts, entertainment, & nightlife", 
                   @"sports & recreation", nil];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchButtonClicked:)];
    self.navigationItem.rightBarButtonItem = searchButton;
    prefs = [NSUserDefaults standardUserDefaults];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    segmentedControl.selectedSegmentIndex = [prefs integerForKey:@"savedSegmentValue"];
    [pickerView selectRow:[prefs integerForKey:@"selectedPickerValue"] inComponent:0 animated:NO];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIBarButtonItem Action Methods
- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)searchButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:^(void){
        [delegate performSearchFromFilteredQuery];
    }];
}

#pragma mark - IBAction Methods
- (IBAction)segmentedControlSelected:(id)sender {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            rangeSelection = @"5 blocks";
            [prefs setDouble:10.0 forKey:@"filteredRadius"];
            [prefs synchronize];
            break;
        case 1:
            rangeSelection = @"1 mi";
            [prefs setDouble:1609.0 forKey:@"filteredRadius"];
            [prefs synchronize];
            break;
        case 2:
            rangeSelection = @"5 mi";
            [prefs setDouble:8046.0 forKey:@"filteredRadius"];
            [prefs synchronize];
            break;
        case 3:
            rangeSelection = @"10 mi";
            [prefs setDouble:16093.0 forKey:@"filteredRadius"];
            [prefs synchronize];
            
        default:
            [prefs setInteger:segmentedControl.selectedSegmentIndex forKey:@"savedSegmentValue"];
            [prefs synchronize];
            break;
    }
}

#pragma mark UIPickerView Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    [prefs setValue:[pickerArray objectAtIndex:row] forKey:@"filteredCategory"];
    [prefs setInteger:row forKey:@"savedPickerValue"];
    [prefs synchronize];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [pickerArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [pickerArray objectAtIndex:row];
}


@end
