//
//  MMNotificationSettingsViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/6/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMNotificationSettingsViewController.h"
#import "MMSetTitleImage.h"

@interface MMNotificationSettingsViewController ()

@end

@implementation MMNotificationSettingsViewController

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
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    NSMutableArray *pickerContentArray = [NSMutableArray arrayWithObjects:@"Today", @"One Day", @"One Week", @"Always", nil];
    [self setContentList:pickerContentArray];
    
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

#pragma mark - UINavigationBar button tap methods
- (void)backButtonTapped:(id)sender {
    [_delegate selectedSetting:@"Today"];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark UIPickerView Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    _selectedItem = [_contentList objectAtIndex:row];
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return _contentList.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [_contentList objectAtIndex:row];
}


@end
