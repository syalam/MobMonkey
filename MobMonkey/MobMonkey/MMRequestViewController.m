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
@property (weak, nonatomic) IBOutlet UISegmentedControl *stayActiveLengthSegmentedCell;
@property (strong, nonatomic) NSMutableDictionary *requestInfo;
@property (strong, nonatomic) NSString *message;
@property (strong, nonatomic) NSNumber *duration;
@property (strong, nonatomic) NSDate *scheduledDate;
@property (weak, nonatomic) IBOutlet MMTableViewCell *messageCell;
@property (weak, nonatomic) IBOutlet MMTableViewCell *scheduleCell;
@property (weak, nonatomic) IBOutlet UIButton *requestButton;

- (IBAction)changeRequestDuration:(id)sender;
- (IBAction)changeMediaRequestType:(id)sender;
- (IBAction)sendRequest:(id)sender;
- (IBAction)cancelRequest:(id)sender;
- (void)dismissRequestViewController;

@end

@implementation MMRequestViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(dismissRequestViewController) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    CGRect frame = self.mediaTypeSegmentedControl.frame;
    frame.size.height = 64;
    self.mediaTypeSegmentedControl.frame = frame;
    [self.mediaTypeSegmentedControl setBackgroundImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    UIImage *divider = [UIImage imageNamed:@"separator-gradient"];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    /*UIImage *selectedSegement = [[UIImage imageNamed:@"timeBtnSelected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    UIImage *deselectedSegement = [[UIImage imageNamed:@"timeBtnDeselected"] resizableImageWithCapInsets:UIEdgeInsetsMake(2, 2, 2, 2)];
    [self.stayActiveLengthSegmentedCell setBackgroundImage:deselectedSegement forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.stayActiveLengthSegmentedCell setBackgroundImage:selectedSegement forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [self.stayActiveLengthSegmentedCell setDividerImage:divider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.stayActiveLengthSegmentedCell setDividerImage:divider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];*/
    
    self.mediaTypeSegmentedControl.selectedSegmentIndex = 1;
    [self changeMediaRequestType:self.mediaTypeSegmentedControl];
    self.stayActiveLengthSegmentedCell.selectedSegmentIndex = 1;
    
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
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@" hh:mm a 'on' MM/dd/yyy"];
    NSString* dateString = [dateFormatter stringFromDate:[self.requestInfo valueForKey:@"scheduleDate"]];
    self.scheduleCell.detailTextLabel.text = dateString;
    [self.tableView reloadData];
}

- (void)viewDidUnload {
    [self setMediaTypeSegmentedControl:nil];
    [self setMessageCell:nil];
    [self setScheduleCell:nil];
    [self setRequestButton:nil];
    [self setStayActiveLengthSegmentedCell:nil];
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

- (void)dismissRequestViewController
{
    [self dismissViewControllerAnimated:YES completion:nil];
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
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)changeMediaRequestType:(id)sender
{
    if ([sender selectedSegmentIndex]) {
        [self.requestButton setTitle:@"Send Photo Request" forState:UIControlStateNormal];
        return;
    }
    [self.requestButton setTitle:@"Send Video Request" forState:UIControlStateNormal];
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
