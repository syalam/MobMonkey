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
    
    if ([prefs integerForKey:@"savedSegmentValue"]) {
        switch ([prefs integerForKey:@"savedSegmentValue"]) {
            case 880:
                [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOn"] forState:UIControlStateNormal];
                [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
                [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
                [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
                [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
                selectedRadius = [NSNumber numberWithInt:880];
                break;
                
            case 1760:
                [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
                [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOn"] forState:UIControlStateNormal];
                [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
                [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
                [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
                selectedRadius = [NSNumber numberWithInt:1760];

                break;
                
            case 8800:
                [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
                [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
                [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOn"] forState:UIControlStateNormal];
                [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
                [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
                selectedRadius = [NSNumber numberWithInt:8800];

                break;
                
            case 17600:
                [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
                [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
                [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
                [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOn"] forState:UIControlStateNormal];
                [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
                selectedRadius = [NSNumber numberWithInt:17600];

                break;
                
            case 35200:
                [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
                [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
                [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
                [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
                [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOn"] forState:UIControlStateNormal];
                selectedRadius = [NSNumber numberWithInt:35200];

                break;
                
            default:
                break;
        }
    } else {
        [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOn"] forState:UIControlStateNormal];
        [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
        [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
        [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
        [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
        selectedRadius = [NSNumber numberWithInt:880];
    }
    
    if ([prefs valueForKey:@"savedMediaFilter"]) {
        selectedFilter = [prefs valueForKey:@"savedMediaFilter"];
        
        if ([selectedFilter isEqualToString:@"mmUserVideo"]) {
            [videoButton setImage:[UIImage imageNamed:@"videoFilterOn"] forState:UIControlStateNormal];
            [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
            [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
            [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
        }
        else if ([selectedFilter isEqualToString:@"mmUserImage"]) {
            [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
            [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOn"] forState:UIControlStateNormal];
            [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
            [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
        }
        
        else if ([selectedFilter isEqualToString:@"mmLocationLiveStream"]) {
            [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
            [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
            [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOn"] forState:UIControlStateNormal];
            [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
        }
        
        else {
            [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
            [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
            [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
            [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOn"] forState:UIControlStateNormal];
        }
    } else {
        selectedFilter = @"mmUserVideo";
        [videoButton setImage:[UIImage imageNamed:@"videoFilterOn"] forState:UIControlStateNormal];
        [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
        [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
        [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
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
    [_delegate setFilters:[NSDictionary dictionaryWithObjectsAndKeys:selectedRadius, @"radius", selectedFilter, @"media type", nil]];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


#pragma mark - IBAction Methods

- (IBAction)halfMileButtonClicked:(id)sender {
    [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOn"] forState:UIControlStateNormal];
    [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
    [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
    [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
    [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
    
    selectedRadius = [NSNumber numberWithInt:880];
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)oneMileButtonClicked:(id)sender {
    [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
    [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOn"] forState:UIControlStateNormal];
    [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
    [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
    [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
    
    selectedRadius = [NSNumber numberWithInt:1760];
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)fiveMileButtonClicked:(id)sender {
    [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
    [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
    [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOn"] forState:UIControlStateNormal];
    [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
    [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
    
    selectedRadius = [NSNumber numberWithInt:8800];
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)tenMileButtonClicked:(id)sender {
    [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
    [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
    [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
    [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOn"] forState:UIControlStateNormal];
    [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOff"] forState:UIControlStateNormal];
    
    selectedRadius = [NSNumber numberWithInt:17600];
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)twentyMileButtonClicked:(id)sender {
    [halfMileButton setImage:[UIImage imageNamed:@"halfMileFilterOff"] forState:UIControlStateNormal];
    [oneMileButton setImage:[UIImage imageNamed:@"oneMileFilterOff"] forState:UIControlStateNormal];
    [fiveMileButton setImage:[UIImage imageNamed:@"fiveMileFilterOff"] forState:UIControlStateNormal];
    [tenMileButton setImage:[UIImage imageNamed:@"tenMileFilterOff"] forState:UIControlStateNormal];
    [twentyMileButton setImage:[UIImage imageNamed:@"twentyMileFilterOn"] forState:UIControlStateNormal];
    
    selectedRadius = [NSNumber numberWithInt:35200];
    [[NSUserDefaults standardUserDefaults]setObject:selectedRadius forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}

- (IBAction)videoButtonClicked:(id)sender {
    [videoButton setImage:[UIImage imageNamed:@"videoFilterOn"] forState:UIControlStateNormal];
    [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
    [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
    [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
    
    selectedFilter = @"mmUserVideo";
    [[NSUserDefaults standardUserDefaults]setObject:selectedFilter forKey:@"savedMediaFilter"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)pictureButtonClicked:(id)sender {
    [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
    [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOn"] forState:UIControlStateNormal];
    [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
    [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
    
    selectedFilter = @"mmUserImage";
    [[NSUserDefaults standardUserDefaults]setObject:selectedFilter forKey:@"savedMediaFilter"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)liveFeedButtonClicked:(id)sender {
    [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
    [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
    [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOn"] forState:UIControlStateNormal];
    [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOff"] forState:UIControlStateNormal];
    
    selectedFilter = @"mmLocationLiveStream";
    [[NSUserDefaults standardUserDefaults]setObject:selectedFilter forKey:@"savedMediaFilter"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}
- (IBAction)locationVideoButtonClicked:(id)sender {
    [videoButton setImage:[UIImage imageNamed:@"videoFilterOff"] forState:UIControlStateNormal];
    [pictureButton setImage:[UIImage imageNamed:@"pictureFilterOff"] forState:UIControlStateNormal];
    [liveFeedButton setImage:[UIImage imageNamed:@"liveFeedFilterOff"] forState:UIControlStateNormal];
    [locationVideoButton setImage:[UIImage imageNamed:@"locationVideoFilterOn"] forState:UIControlStateNormal];
    
    selectedFilter = @"mmLocationVideo";
    [[NSUserDefaults standardUserDefaults]setObject:selectedFilter forKey:@"savedMediaFilter"];
    [[NSUserDefaults standardUserDefaults]synchronize];
}


@end
