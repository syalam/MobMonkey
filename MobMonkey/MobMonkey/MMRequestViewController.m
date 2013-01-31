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
    
    self.mediaTypeSegmentedControl.selectedSegmentIndex = 0;
    [self changeMediaRequestType:self.mediaTypeSegmentedControl];
    //self.mediaTypeSegmentedControl.tintColor = [UIColor grayColor];
    self.stayActiveLengthSegmentedCell.selectedSegmentIndex = 1;
    
    self.requestInfo = [NSMutableDictionary dictionary];
    self.requestButton.titleEdgeInsets = UIEdgeInsetsMake(0.0, 1.0, 2.0, 0.0);
    
    //initialize duration to 30 minutes
    self.duration = @30;
    
    isRecurring = NO;
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
    [SVProgressHUD dismiss];
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
        messageVC.delegate = self;
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
    [self.requestInfo setValue:[NSNumber numberWithInt:50] forKey:@"radiusInYards"];
    [self.requestInfo setValue:[NSNumber numberWithBool:isRecurring] forKey:@"recurring"];
    
    
    NSString *mediaType;
    switch (_mediaTypeSegmentedControl.selectedSegmentIndex) {
        case 0:
            mediaType = @"video";
            break;
        case 1:
            mediaType = @"image";
            break;
        case 2:
            mediaType = @"text";
            break;
            
        default:
            break;
    }
    
    if ([mediaType isEqualToString:@"text"] && ![self.requestInfo valueForKey:@"message"]) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Text must be entered for a text request" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }

    else {
        NSLog(@"MMRequestViewController.m requestMedia %@", self.requestInfo);
        
        if ([[UIDevice currentDevice] respondsToSelector:@selector(isMultitaskingSupported)]) { //Check if our iOS version supports multitasking I.E iOS 4
            if ([[UIDevice currentDevice] isMultitaskingSupported]) { //Check if device supports mulitasking
                UIApplication *application = [UIApplication sharedApplication]; //Get the shared application instance
                __block UIBackgroundTaskIdentifier background_task; //Create a task object
                background_task = [application beginBackgroundTaskWithExpirationHandler: ^ {
                    [application endBackgroundTask: background_task]; //Tell the system that we are done with the tasks
                    background_task = UIBackgroundTaskInvalid; //Set the task to be invalid
                    //System will be shutting down the app at any point in time now
                }];
                //Background tasks require you to use asyncrous tasks
                dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
                    //Perform your tasks that your application requires
                    //NSLog(@"\n\nRunning in the background!\n\n");
                    [MMAPI requestMedia:mediaType params:self.requestInfo success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        NSLog(@"%@", responseObject);
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
                        
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        [SVProgressHUD showErrorWithStatus:@"Unable to make request. Please try again"];
                        NSLog(@"%@", operation.responseString);
                    }];
                });
            }
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (IBAction)changeMediaRequestType:(id)sender
{
  switch (_mediaTypeSegmentedControl.selectedSegmentIndex) {
    case 0:
      [self.requestButton setTitle:@"Send Video Request" forState:UIControlStateNormal];
      break;
    case 1:
      [self.requestButton setTitle:@"Send Photo Request" forState:UIControlStateNormal];
      break;
    case 2:
      [self.requestButton setTitle:@"Send Text Request" forState:UIControlStateNormal];
      break;
      
    default:
      break;
  }
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
    [[self.stayActiveLengthSegmentedCell.subviews objectAtIndex:[sender selectedSegmentIndex]] setTintColor:[UIColor grayColor]];
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

#pragma mark - MMRequestSchedule Delegate
- (void)RequestScheduleSetWithDictionary:(NSDictionary*)requestScheduleParams {
    if ([requestScheduleParams valueForKey:@"scheduleDate"]) {
        [self.requestInfo setValue:[requestScheduleParams valueForKey:@"scheduleDate"] forKey:@"scheduleDate"];
    }
    if ([requestScheduleParams valueForKey:@"frequencyInMS"]) {
        [self.requestInfo setValue:[requestScheduleParams valueForKey:@"frequencyInMS"] forKey:@"frequencyInMS"];
    }
    if ([requestScheduleParams valueForKey:@"recurring"]) {
        if ([[requestScheduleParams valueForKey:@"recurring"]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
            isRecurring = YES;
        }
        else {
            isRecurring = NO;
        }
    }
}

@end
