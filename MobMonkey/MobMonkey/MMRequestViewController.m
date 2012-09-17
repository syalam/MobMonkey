//
//  MMRequestViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMRequestViewController.h"
#import "MMPresetMessagesViewController.h"
#import "MMSetTitleImage.h"
#import "MMScheduleRequestViewController.h"

@interface MMRequestViewController ()

@end

@implementation MMRequestViewController

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
    // Do any additional setup after loading the view from its nib.
    //self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    //Initialize segmented control selection vars
    photoVideoSegmentedControlSelection = 100;
    stayActiveSegmentedControlSelection = 100;
    scheduleItSegmentedControlSelection = 100;
    
    
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    /*UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoardGestureTapped:)];
    dismissKeyboard.delegate = self;
    [self.view addGestureRecognizer:dismissKeyboard];*/
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

#pragma mark - UINavBar Tap Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - IBAction Methods
- (IBAction)sendRequestButtonTapped:(id)sender {
    MMAPI *sendRequestApiCall = [[MMAPI alloc]init];
    sendRequestApiCall.delegate = self;
    
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}


- (IBAction)attachMessageButtonTapped:(id)sender {
    MMPresetMessagesViewController *presetMessagesVC = [[MMPresetMessagesViewController alloc]initWithNibName:@"MMPresetMessagesViewController" bundle:nil];
    presetMessagesVC.title = @"Attach a Message";
    presetMessagesVC.delegate = self;
    [self.navigationController pushViewController:presetMessagesVC animated:YES];
}

- (IBAction)clearTextButtonTapped:(id)sender {
    /*_placeholderLabel.hidden = NO;
    _requestTextView.text = @"";
    _characterCountLabel.text = @"0";*/
}

- (IBAction)scheduleRequestButtonTapped:(id)sender {
    MMScheduleRequestViewController *scheduleRequestVC = [[MMScheduleRequestViewController alloc]initWithNibName:@"MMScheduleRequestViewController"bundle:nil];
    scheduleRequestVC.title = @"Schedule Request";
    [self.navigationController pushViewController:scheduleRequestVC animated:YES];
}

#pragma mark - Gesture recognizer tap methods
- (void)dismissKeyBoardGestureTapped:(id)sender {
    MMMakeRequestCell *cell = (MMMakeRequestCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
    [cell.mmRequestMessageTextView resignFirstResponder];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    //return _contentList.count;
    if (_textEntered) {
        return 5;
    }
    else {
        return 4;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"Cell";
    MMMakeRequestCell *cell = (MMMakeRequestCell*)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell = nil;
    if (cell == nil) {
        cell = [[MMMakeRequestCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    switch (indexPath.row) {
        case 0:
            [cell.mmRequestPhotoVideoSegmentedControl setHidden:NO];
            if (photoVideoSegmentedControlSelection != 100) {
                NSLog(@"%d", photoVideoSegmentedControlSelection);
                cell.mmRequestPhotoVideoSegmentedControl.selectedSegmentIndex = photoVideoSegmentedControlSelection;
            }
            break;
        case 1:
            cell.textLabel.text = @"Attach Message";
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.selectionStyle = UITableViewCellSelectionStyleBlue;
            break;
        case 2:
            if (_textEntered) {
                [cell.mmRequestMessageTextView setHidden:NO];
                [cell.mmRequestClearTextButton setHidden:NO];
                cell.mmRequestMessageTextView.text = messageText;
            }
            else {
                [cell.mmRequestTextLabel setHidden:NO];
                [cell.mmRequestTextLabel setText:@"Stay Active For"];
                [cell.mmRequestStayActiveSegmentedControl setHidden:NO];
            }
            break;
        case 3:
            if (_textEntered) {
                [cell.mmRequestTextLabel setHidden:NO];
                [cell.mmRequestTextLabel setText:@"Stay Active For"];
                [cell.mmRequestStayActiveSegmentedControl setHidden:NO];
                
                if (stayActiveSegmentedControlSelection != 100) {
                    cell.mmRequestStayActiveSegmentedControl.selectedSegmentIndex = stayActiveSegmentedControlSelection;
                }
            }
            else {
                [cell.mmRequestScheduleSegmentedControl setHidden:NO];
                
                if (scheduleItSegmentedControlSelection != 100) {
                    cell.mmRequestScheduleSegmentedControl.selectedSegmentIndex = scheduleItSegmentedControlSelection;
                }
            }
            
            break;
        case 4:
            [cell.mmRequestScheduleSegmentedControl setHidden:NO];
            if (scheduleItSegmentedControlSelection != 100) {
                cell.mmRequestScheduleSegmentedControl.selectedSegmentIndex = scheduleItSegmentedControlSelection;
            }
            break;
        default:
            break;
    }
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.row) {
        case 1: {
            MMPresetMessagesViewController *presetMessagesVC = [[MMPresetMessagesViewController alloc]initWithNibName:@"MMPresetMessagesViewController" bundle:nil];
            presetMessagesVC.title = @"Attach a Message";
            presetMessagesVC.delegate = self;
            [self.navigationController pushViewController:presetMessagesVC animated:YES];
        }
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            return 55;
            break;
        case 1:
            return 44;
            break;
        case 2:
            return 90;
            break;
        case 3:
            return 75;
            break;
        case 4:
            return 55;
        default:
            return 44;
            break;
    }
}

#pragma mark - MMMakeRequestCellDelegate Methods
- (void)mmRequestPhotoVideoSegmentedControlTapped:(id)sender {
    MMMakeRequestCell *cell = (MMMakeRequestCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    photoVideoSegmentedControlSelection = cell.mmRequestPhotoVideoSegmentedControl.selectedSegmentIndex;
    if (cell.mmRequestPhotoVideoSegmentedControl.selectedSegmentIndex == 0) {
        NSLog(@"%@", @"photo selected");
    }
    else {
        NSLog(@"%@", @"video selected");
    }
}

- (void)mmRequestStayActiveSegmentedControlTapped:(id)sender {
    NSIndexPath *selectedIndexPath;
    if (_textEntered) {
        selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    else {
        selectedIndexPath = [NSIndexPath indexPathForRow:2 inSection:0];
    }
    MMMakeRequestCell *cell = (MMMakeRequestCell*)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    stayActiveSegmentedControlSelection = cell.mmRequestStayActiveSegmentedControl.selectedSegmentIndex;
    switch (cell.mmRequestStayActiveSegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"%@", @"15m");
            break;
        case 1:
            NSLog(@"%@", @"30m");
            break;
        case 2:
            NSLog(@"%@", @"1h");
            break;
        case 3:
            NSLog(@"%@", @"3h");
            break;
        default:
            break;
    }
}

- (void)mmRequestScheduleSegmentedControlTapped:(id)sender {
    NSIndexPath *selectedIndexPath;
    if (_textEntered) {
        selectedIndexPath = [NSIndexPath indexPathForRow:4 inSection:0];
    }
    else {
        selectedIndexPath = [NSIndexPath indexPathForRow:3 inSection:0];
    }
    MMMakeRequestCell *cell = (MMMakeRequestCell*)[self.tableView cellForRowAtIndexPath:selectedIndexPath];
    scheduleItSegmentedControlSelection = cell.mmRequestScheduleSegmentedControl.selectedSegmentIndex;
    switch (cell.mmRequestScheduleSegmentedControl.selectedSegmentIndex) {
        case 0:
            NSLog(@"%@", @"RequestNow");
            break;
        case 1: {
            NSLog(@"%@", @"Schedule Request");
            MMScheduleRequestViewController *scheduleRequestVC = [[MMScheduleRequestViewController alloc]initWithNibName:@"MMScheduleRequestViewController"bundle:nil];
            scheduleRequestVC.title = @"Schedule Request";
            [self.navigationController pushViewController:scheduleRequestVC animated:YES];
        }
            break;
        default:
            break;
    }
}

- (void)mmRequestClearTextButtonTapped:(id)sender {
    _textEntered = NO;
    messageText = nil;
    [self.tableView reloadData];
}

- (void)textViewDidChange:(UITextView *)textView {
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    dismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoardGestureTapped:)];
    dismissKeyboard.delegate = self;
    [self.view addGestureRecognizer:dismissKeyboard];
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    [self.view removeGestureRecognizer:dismissKeyboard];
}

#pragma mark - MMPresetMessageDelegate Methods
- (void)presetMessageSelected:(id)message {
    NSString *messageString = message;
    if (messageString.length > 0) {
        _textEntered = YES;
        messageText = messageString;
    }
    else {
        _textEntered = NO;
        messageText = nil;
    }
    [self.tableView reloadData];
}

@end
