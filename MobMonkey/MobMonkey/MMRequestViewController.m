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
    [backNavbutton addTarget:self.navigationController action:@selector(dismissModalViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    CGRect frame = self.mediaTypeSegmentedControl.frame;
    frame.size.height = 64;
    self.mediaTypeSegmentedControl.frame = frame;
    [self.mediaTypeSegmentedControl setBackgroundImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //UIImage *divider = [UIImage imageNamed:@"separator-gradient"];
    UIImage *divider = [UIImage imageNamed:@"segmentedControlSeparator"];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateSelected rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [self.mediaTypeSegmentedControl setDividerImage:divider forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    
    
    self.mediaTypeSegmentedControl.selectedSegmentIndex = 1;
    [self changeMediaRequestType:self.mediaTypeSegmentedControl];
    self.stayActiveLengthSegmentedCell.selectedSegmentIndex = 1;
    
    self.requestInfo = [NSMutableDictionary dictionary];
}

- (void)viewDidUnload {
    [self setMediaTypeSegmentedControl:nil];
    [self setRequestButton:nil];
    [self setStayActiveLengthSegmentedCell:nil];
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
    
    [MMAPI requestMedia:@"image" params:self.requestInfo success:nil failure:nil];
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

#pragma mark - Table View Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return ([self.requestInfo valueForKey:@"message"] && [[self.requestInfo valueForKey:@"message"] length] > 0) ? 2 : 1;
    }
    return [self.requestInfo valueForKey:@"scheduleDate"] ? 2 : 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    UIButton *removeButton;
    switch (indexPath.row) {
        case 0:
            if (indexPath.section == 0)
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"AddMessageCell"];
            else
                cell = [self.tableView dequeueReusableCellWithIdentifier:@"ScheduleRequestCell"];
            break;
        case 1:
            cell = [self.tableView dequeueReusableCellWithIdentifier:@"Cell"];
            removeButton = [UIButton buttonWithType:UIButtonTypeCustom];
            removeButton.frame = CGRectMake(0, 0, 13.0, 13.0);
            [removeButton setBackgroundImage:[UIImage imageNamed:@"errorSmall"] forState:UIControlStateNormal];
            [removeButton addTarget:self action:@selector(remove:) forControlEvents:UIControlEventTouchDown];
            cell.accessoryView = removeButton;
            
            if (indexPath.section == 0) {
                cell.accessoryView.tag = 10;
                cell.imageView.image = [UIImage imageNamed:@"clipboardIcn"];
                cell.textLabel.numberOfLines = 3;
                cell.textLabel.text = [self.requestInfo valueForKey:@"message"];
            } else {
                cell.accessoryView.tag = 20;
                cell.imageView.image = [UIImage imageNamed:@"calendarIcn"];
                NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                [dateFormatter setDateFormat:@" hh:mm a 'on' MM/dd/yyy"];
                NSString* dateString = [dateFormatter stringFromDate:[self.requestInfo valueForKey:@"scheduleDate"]];
                cell.textLabel.text = dateString;
            }
        default:
            break;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)remove:(id)sender
{
    NSIndexPath *indexPath;
    if ([sender tag] == 10) {
        [self.requestInfo setValue:nil forKey:@"message"];
        indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    } else {
        [self.requestInfo setValue:nil forKey:@"scheduleDate"];
        indexPath = [NSIndexPath indexPathForRow:1 inSection:1];
    }
    [self.tableView beginUpdates];
    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
    [self.tableView endUpdates];
}

@end
