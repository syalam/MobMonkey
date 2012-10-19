//
//  MMRequestViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/18/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMRequestViewController.h"
#import "MMTableViewCell.h"
#import "MMRequestMessageViewController.h"
#import "MMRequestScheduleViewController.h"

enum RequestDurationLengths {
    RequestDuration15Min = 0,
    RequestDuration30Min,
    RequestDuration60Min,
    RequestDuration180Min
    } RequestDurationLengths;

@interface MMRequestViewController ()

@property (weak, nonatomic) IBOutlet UISegmentedControl *mediaTypeSegmentedControl;
@property (strong, nonatomic) NSMutableDictionary *requestInfo;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSDate *scheduledDate;
@property (weak, nonatomic) IBOutlet MMTableViewCell *messageCell;
@property (weak, nonatomic) IBOutlet MMTableViewCell *scheduleCell;

- (IBAction)changeRequestDuration:(id)sender;
- (IBAction)changeMediaRequestType:(id)sender;
- (IBAction)sendRequest:(id)sender;
- (IBAction)cancelRequest:(id)sender;

@end

@implementation MMRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    CGRect frame = self.mediaTypeSegmentedControl.frame;
    frame.size.height = 64;
    self.mediaTypeSegmentedControl.frame = frame;
    [self.mediaTypeSegmentedControl setBackgroundImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *divider = [UIImage imageNamed:@"separator-gradient"];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    self.requestInfo = [NSMutableDictionary dictionary];
    [self.requestInfo setValue:[NSDate date] forKey:@"scheduleDate"];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if ([self.requestInfo valueForKey:@"message"] && [[self.requestInfo valueForKey:@"message"] length] > 0) {
        self.messageCell.textLabel.text = @"Edit Message";
        self.messageCell.detailTextLabel.text = [self.requestInfo valueForKey:@"message"];
    } else {
        self.messageCell.textLabel.text = @"Add Message";
        self.messageCell.detailTextLabel.text = @"";
    }
    self.scheduleCell.detailTextLabel.text = [[self.requestInfo valueForKey:@"scheduleDate"] description];
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setMediaTypeSegmentedControl:nil];
    [self setMessageCell:nil];
    [self setScheduleCell:nil];
    [super viewDidUnload];
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"MessageSegue"]) {
        MMRequestMessageViewController *messageVC = (MMRequestMessageViewController *)segue.destinationViewController;
        messageVC.requestInfo = self.requestInfo;
        return;
    }
    if ([segue.identifier isEqualToString:@"ScheduleSegue"]) {
        MMRequestScheduleViewController *messageVC = (MMRequestScheduleViewController *)segue.destinationViewController;
        messageVC.requestInfo = self.requestInfo;
        return;
    }
}

- (IBAction)sendRequest:(id)sender
{
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
    NSString *dateString = [dateFormatter stringFromDate:[self.requestInfo valueForKey:@"scheduleDate"]];
    
    [self.requestInfo setValue:dateString forKey:@"scheduleDate"];
    [self.requestInfo setValue:[_contentList valueForKey:@"providerId"] forKey:@"providerId"];
    [self.requestInfo setValue:[_contentList valueForKey:@"locationId"] forKey:@"locationId"];
    [self.requestInfo setValue:self.duration forKey:@"duration"];
    [self.requestInfo setValue:[NSNumber numberWithInt:100000] forKey:@"radiusInYards"];
    [self.requestInfo setValue:[NSNumber numberWithBool:NO] forKey:@"recurring"];
    
    [[MMAPI sharedAPI] requestMedia:@"image" params:self.requestInfo];

}

- (IBAction)changeMediaRequestType:(id)sender
{
}

- (IBAction)changeRequestDuration:(id)sender
{
    switch ([sender selectedSegmentIndex]) {
        case RequestDuration15Min:
            self.duration = @15;
            break;
        case RequestDuration30Min:
            self.duration = @30;
            break;
        case RequestDuration60Min:
            self.duration = @60;
            break;
        case RequestDuration180Min:
            self.duration = @180;
            break;
        default:
            break;
    }
}

- (IBAction)cancelRequest:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
