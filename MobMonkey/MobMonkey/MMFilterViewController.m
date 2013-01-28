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
#import "MMTableViewCell.h"

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
    
    if ([prefs valueForKey:@"savedSegmentValue"]) {
        switch ([[prefs valueForKey:@"savedSegmentValue"]intValue]) {
            case 880:
                [distancePicker setSelectedSegmentIndex:0];
                selectedRadius = [NSNumber numberWithInt:880];
                break;
                
            case 1760:
                [distancePicker setSelectedSegmentIndex:1];
                selectedRadius = [NSNumber numberWithInt:1760];

                break;
                
            case 8800:
                [distancePicker setSelectedSegmentIndex:2];
                selectedRadius = [NSNumber numberWithInt:8800];

                break;
                
            case 17600:
                [distancePicker setSelectedSegmentIndex:3];
                selectedRadius = [NSNumber numberWithInt:17600];

                break;
                
            case 35200:
                [distancePicker setSelectedSegmentIndex:4];
                selectedRadius = [NSNumber numberWithInt:35200];

                break;
                
            default:
                break;
        }
    } else {
        [distancePicker setSelectedSegmentIndex:2];
        selectedRadius = [NSNumber numberWithInt:8800];

    }
    
    if ([prefs boolForKey:@"liveFeedFilter"]) {
        liveFeedSwitch.on = YES;
    }
    else {
        liveFeedSwitch.on = NO;
    }
    
    for (id segment in [distancePicker subviews])
    {
        for (id label in [segment subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                [label setTextAlignment:UITextAlignmentCenter];
                [label setFont:[UIFont boldSystemFontOfSize:14]];
            }
        }
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

-(void)viewDidAppear:(BOOL)animated{
    
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - UIBarButtonItem Action Methods
- (void)backButtonTapped:(id)sender {
    switch (distancePicker.selectedSegmentIndex) {
        case 0:
            selectedRadius = [NSNumber numberWithInt:880];
            [prefs setObject:selectedRadius forKey:@"savedSegmentValue"];
            break;
            
        case 1:
            selectedRadius = [NSNumber numberWithInt:1760];
            [prefs setObject:selectedRadius forKey:@"savedSegmentValue"];
            break;
        
        case 2:
            selectedRadius = [NSNumber numberWithInt:8800];
            [prefs setObject:selectedRadius forKey:@"savedSegmentValue"];
            break;
            
        case 3:
            selectedRadius = [NSNumber numberWithInt:17600];
            [prefs setObject:selectedRadius forKey:@"savedSegmentValue"];
            break;
            
        case 4:
            selectedRadius = [NSNumber numberWithInt:35200];
            [prefs setObject:selectedRadius forKey:@"savedSegmentValue"];
            break;

        default:
            break;
    }
    [prefs synchronize];
    
    if (liveFeedSwitch.on) {
        [prefs setBool:YES forKey:@"liveFeedFilter"];
    }
    else {
        [prefs setBool:NO forKey:@"liveFeedFilter"];
    }
    selectedFilter = liveFeedSwitch.on;
    [prefs setBool:selectedFilter forKey:@"savedMediaFilter"];
    [prefs synchronize];
    
    [_delegate setFilters:[NSDictionary dictionaryWithObjectsAndKeys:selectedRadius, @"radius", [NSNumber numberWithBool:selectedFilter], @"liveStream", nil]];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IBAction Methods

- (IBAction)distanceSelected:(id)sender {
    for (id segment in [distancePicker subviews])
    {
        for (id label in [segment subviews])
        {
            if ([label isKindOfClass:[UILabel class]])
            {
                [label setTextAlignment:UITextAlignmentCenter];
                [label setFont:[UIFont boldSystemFontOfSize:14]];
            }
        }           
    }
}

@end
