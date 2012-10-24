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
    [self.requestInfo setValue:[self.datePicker date] forKey:@"scheduleDate"];
    [self.navigationController popViewControllerAnimated:YES];
}
- (void)viewDidUnload {
    [self setDatePicker:nil];
    [super viewDidUnload];
}
@end
