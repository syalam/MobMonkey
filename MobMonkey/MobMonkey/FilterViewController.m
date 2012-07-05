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
    
    pickerArray = [[NSMutableArray alloc]initWithObjects:@"Bars", @"Clubs", @"Restaurants", @"Coffee Shops", @"Kids Stores", nil];
    [pickerView selectRow:2 inComponent:0 animated:NO];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonClicked:)];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithTitle:@"Search" style:UIBarButtonItemStyleDone target:self action:@selector(searchButtonClicked:)];
    self.navigationItem.rightBarButtonItem = searchButton;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
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
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction Methods
- (IBAction)segmentedControlSelected:(id)sender {
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            rangeSelection = @"5 blocks";
            break;
        case 1:
            rangeSelection = @"1 mi";
            break;
        case 2:
            rangeSelection = @"5 mi";
            break;
        case 3:
            rangeSelection = @"10 mi";
            
        default:
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
