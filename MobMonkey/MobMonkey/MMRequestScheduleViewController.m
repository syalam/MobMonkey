//
//  MMRequestScheduleViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/19/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMRequestScheduleViewController.h"

@interface MMRequestScheduleViewController ()

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;

- (IBAction)setSchedule:(id)sender;

@end

@implementation MMRequestScheduleViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    frequency = 86400000;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.requestInfo valueForKey:@"scheduleDate"]) {
        [self.datePicker setDate:[self.requestInfo valueForKey:@"scheduleDate"] animated:NO];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)setSchedule:(id)sender
{
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:[self.datePicker date] forKey:@"scheduleDate"];
    [self.requestInfo setValue:[self.datePicker date] forKey:@"scheduleDate"];
    
    if (recurringSwitch.on) {
        [params setValue:[NSNumber numberWithBool:YES] forKey:@"recurring"];
        
        if (frequency > 0) {
            [params setValue:[NSNumber numberWithInt:frequency] forKey:@"frequencyInMS"];
        }
    }
    else {
        [params setValue:[NSNumber numberWithBool:NO] forKey:@"recurring"];
    }
    
    [_delegate RequestScheduleSetWithDictionary:params];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}


#pragma mark - IBAction Methods
- (IBAction)frequencySelectorTapped:(id)sender {
    switch (frequencySelector.selectedSegmentIndex) {
        case 0:
            frequency = 86400000;
            break;
        case 1:
            frequency = 604800000;
            break;
        case 2:
            frequency = 2628000000;
        default:
            break;
    }
}

- (IBAction)recurringSwitchTapped:(id)sender {
    if (recurringSwitch.on) {
        [frequencySelector setEnabled:YES];
    }
    else {
        [frequencySelector setEnabled:NO];
    }
}
@end
