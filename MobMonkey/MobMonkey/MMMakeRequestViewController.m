//
//  MMMakeRequestViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/4/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMMakeRequestViewController.h"

@interface MMMakeRequestViewController ()

@end

@implementation MMMakeRequestViewController

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
    [messageView setHidden:YES];
    [scheduleView setHidden:YES];
    [scrollView setContentSize:CGSizeMake(320, 550)];
    tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard:)];
    tapGesture.numberOfTapsRequired = 1;
    [self.view addGestureRecognizer:tapGesture];
    [tapGesture setEnabled:NO];
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    //Defualt to photo request
    videoSelected = NO;
    [photoButton setImage:[UIImage imageNamed:@"selectedRectRed"] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction Methods
- (IBAction)videoButtonTapped:(id)sender {
    videoSelected = YES;
    [requestButtonLabel setText:@"Send The Video Request!"];
    [videoButton setImage:[UIImage imageNamed:@"selectedRectRed"] forState:UIControlStateNormal];
    [photoButton setImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal];
}
- (IBAction)photoButtonTapped:(id)sender {
    videoSelected = NO;
    [requestButtonLabel setText:@"Send The Photo Request!"];
    [photoButton setImage:[UIImage imageNamed:@"selectedRectRed"] forState:UIControlStateNormal];
    [videoButton setImage:[UIImage imageNamed:@"deselectedRectRed"] forState:UIControlStateNormal];
}
- (IBAction)addMessageButtonTapped:(id)sender {
    MMPresetMessagesViewController *presetMessagesVC = [[MMPresetMessagesViewController alloc]initWithNibName:@"MMPresetMessagesViewController" bundle:nil];
    presetMessagesVC.title = @"Attach a Message";
    presetMessagesVC.delegate = self;
    [self.navigationController pushViewController:presetMessagesVC animated:YES];
}
- (IBAction)clearMessageButtonTapped:(id)sender {
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelegate: self];
    [messageView setHidden:YES];
    [secondSectionView setFrame:CGRectMake(secondSectionView.frame.origin.x, secondSectionView.frame.origin.y - messageView.frame.size.height, secondSectionView.frame.size.width, secondSectionView.frame.size.height)];
    [sendRequestButtonView setFrame:CGRectMake(sendRequestButtonView.frame.origin.x, sendRequestButtonView.frame.origin.y - 72, sendRequestButtonView.frame.size.width, sendRequestButtonView.frame.size.height)];
    [UIView commitAnimations];
}
- (IBAction)stayActiveButtonTapped:(id)sender {
    UIButton *selectedItem = sender;
    
    [fifteenMinButton setImage:[UIImage imageNamed:@"timeBtnDeselected"] forState:UIControlStateNormal];
    [thirtyMinButton setImage:[UIImage imageNamed:@"timeBtnDeselected"] forState:UIControlStateNormal];
    [oneHrButton setImage:[UIImage imageNamed:@"timeBtnDeselected"] forState:UIControlStateNormal];
    [threeHrButton setImage:[UIImage imageNamed:@"timeBtnDeselected"] forState:UIControlStateNormal];
    
    UIColor *activeColor = [UIColor whiteColor];
    UIColor *inactiveColor = [UIColor darkGrayColor];
    
    [segmentOneLabel setTextColor:inactiveColor];
    [segmentTwoLabel setTextColor:inactiveColor];
    [segmentThreeLabel setTextColor:inactiveColor];
    [segmentFourLabel setTextColor:inactiveColor];
    
    switch (selectedItem.tag) {
        case 0:
            selectedDuration = [NSNumber numberWithInt:15];
            [segmentOneLabel setTextColor:activeColor];
            break;
        case 1:
            selectedDuration = [NSNumber numberWithInt:30];
            [segmentTwoLabel  setTextColor:activeColor];
            break;
        case 2:
            selectedDuration = [NSNumber numberWithInt:60];
            [segmentThreeLabel setTextColor:activeColor];
            break;
        case 3:
            selectedDuration = [NSNumber numberWithInt:180];
            [segmentFourLabel setTextColor:activeColor];
            break;
        default:
            break;
    }
    [selectedItem setImage:[UIImage imageNamed:@"timeBtnSelected"] forState:UIControlStateNormal];
}
- (IBAction)scheduleButtonTapped:(id)sender {
    MMScheduleRequestViewController *scheduleRequestVC = [[MMScheduleRequestViewController alloc]initWithNibName:@"MMScheduleRequestViewController"bundle:nil];
    scheduleRequestVC.title = @"Schedule Request";
    scheduleRequestVC.delegate = self;
    [self.navigationController pushViewController:scheduleRequestVC animated:YES];
}
- (IBAction)clearScheduleButtonTapped:(id)sender {
    [scheduleView setHidden:YES];
    CGContextRef context = UIGraphicsGetCurrentContext();
    [UIView beginAnimations:nil context:context];
    [UIView setAnimationCurve:UIViewAnimationCurveLinear];
    [UIView setAnimationDuration: 0.5];
    [UIView setAnimationDelegate: self];
    [secondSectionView setFrame:CGRectMake(secondSectionView.frame.origin.x, secondSectionView.frame.origin.y, secondSectionView.frame.size.width, secondSectionView.frame.size.height - 44)];
    [sendRequestButtonView setFrame:CGRectMake(sendRequestButtonView.frame.origin.x, sendRequestButtonView.frame.origin.y -44, sendRequestButtonView.frame.size.width, sendRequestButtonView.frame.size.height)];
    [UIView commitAnimations];
    
}
- (IBAction)sendRequestButtonTapped:(id)sender {
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    if (messagTextView.text && ![messagTextView.text isEqualToString:@""]) {
        [params setObject:messagTextView.text forKey:@"message"];
    }
    //HARDCODE PROVIDER ID AND LOCATION ID UNTIL WE CAN GET VALID DATA FROM SERVER
    [params setObject:@"222e736f-c7fa-4c40-b78e-d99243441fae" forKey:@"providerId"];
    [params setObject:@"eeb203e7-a4f0-4318-be8b-b00f613c7e37" forKey:@"locationId"];
    if (selectedDuration) {
        NSLog(@"%@", selectedDuration);
        [params setObject:selectedDuration forKey:@"duration"];
    }
    if (selectedScheduleDate) {
        NSLog(@"%@", selectedScheduleDate);
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss.SSSZ"];
        NSString *dateString = [dateFormatter stringFromDate:selectedScheduleDate];
        NSLog(@"%@", dateString);
        [params setObject:dateString forKey:@"scheduleDate"];
    }
    [params setObject:[NSNumber numberWithInt:1000] forKey:@"radiusInYards"];
    [params setObject:[NSNumber numberWithBool:NO] forKey:@"recurring"];
    
    [MMAPI sharedAPI].delegate = self;
    [[MMAPI sharedAPI]requestMedia:@"image" params:params];
}

- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)dismissKeyBoard:(id)sender {
    [messagTextView resignFirstResponder];
    [tapGesture setEnabled:NO];
}

#pragma mark - MMAPI Delegate Methods
- (void)MMAPICallSuccessful:(id)response {
    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Your request has been sent" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
    [alert show];
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation {
    NSString *responseString = operation.responseString;
    NSLog(@"%@", responseString);
}

#pragma mark - MMPresetMessageDelegate Methods
- (void)presetMessageSelected:(id)message {
    NSString *messageString = message;
    if (messageString.length > 0) {
        messagTextView.text = messageString;
        
        [messageView setHidden:NO];
        [secondSectionView setFrame:CGRectMake(secondSectionView.frame.origin.x, secondSectionView.frame.origin.y + 35, secondSectionView.frame.size.width, secondSectionView.frame.size.height)];
        [sendRequestButtonView setFrame:CGRectMake(sendRequestButtonView.frame.origin.x, sendRequestButtonView.frame.origin.y + sendRequestButtonView.frame.size.height - 30, sendRequestButtonView.frame.size.width, sendRequestButtonView.frame.size.height)];
    }
}

#pragma mark - MMScheduleRequest Delegate Methods
- (void)selectedScheduleDate:(NSDate*)scheduleDate recurring:(BOOL)recurring {
    selectedScheduleDate = scheduleDate;
    scheduleRequestDateSelected = YES;
    [scheduleView setHidden:NO];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"EEEE, MM/dd/yyy 'at' hh:mm a"];
    NSString* dateString = [dateFormatter stringFromDate:selectedScheduleDate];
    scheduleLabel.text = [NSString stringWithFormat:@"%@",dateString];
    [secondSectionView setFrame:CGRectMake(secondSectionView.frame.origin.x, secondSectionView.frame.origin.y, secondSectionView.frame.size.width, secondSectionView.frame.size.height + 44)];
    [sendRequestButtonView setFrame:CGRectMake(sendRequestButtonView.frame.origin.x, sendRequestButtonView.frame.origin.y + sendRequestButtonView.frame.size.height - 20, sendRequestButtonView.frame.size.width, sendRequestButtonView.frame.size.height)];
}

#pragma mark - UITextView Delegate Methods
- (void)textViewDidBeginEditing:(UITextView *)textView {
    [tapGesture setEnabled:YES];
}
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    if([text isEqualToString:@"\n"]) {
        [tapGesture setEnabled:NO];
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

@end
