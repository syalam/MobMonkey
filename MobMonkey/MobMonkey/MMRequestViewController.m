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
    
    //Add custom back button to the nav bar
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UITapGestureRecognizer *dismissKeyboard = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoardGestureTapped:)];
    dismissKeyboard.delegate = self;
    [self.view addGestureRecognizer:dismissKeyboard];
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
- (IBAction)attachMessageButtonTapped:(id)sender {
    MMPresetMessagesViewController *presetMessagesVC = [[MMPresetMessagesViewController alloc]initWithNibName:@"MMPresetMessagesViewController" bundle:nil];
    presetMessagesVC.title = @"Attach a Message";
    presetMessagesVC.delegate = self;
    [self.navigationController pushViewController:presetMessagesVC animated:YES];
}

- (IBAction)clearTextButtonTapped:(id)sender {
    _placeholderLabel.hidden = NO;
    _requestTextView.text = @"";
    _characterCountLabel.text = @"0";
}

- (IBAction)scheduleRequestButtonTapped:(id)sender {
    MMScheduleRequestViewController *scheduleRequestVC = [[MMScheduleRequestViewController alloc]initWithNibName:@"MMScheduleRequestViewController"bundle:nil];
    scheduleRequestVC.title = @"Schedule Request";
    [self.navigationController pushViewController:scheduleRequestVC animated:YES];
}


#pragma mark - UITextView Delegate Methods
- (void)textViewDidChange:(UITextView *)textView {
    if (textView.text.length > 0) {
        [_placeholderLabel setHidden:YES];
    }
    else {
        [_placeholderLabel setHidden:NO];
    }
    _characterCountLabel.text = [NSString stringWithFormat:@"%d", textView.text.length];
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText {
    
    NSString* newText = [textView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    if([aText isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    else if([newText length] > 100)
    {
        return NO; // can't enter more text
    }
    else
        return YES; // let the textView know that it should handle the inserted text
}

#pragma mark - Gesture recognizer tap methods
- (void)dismissKeyBoardGestureTapped:(id)sender {
    [_requestTextView resignFirstResponder];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if (touch.view == _videoButton || touch.view == _photoButton || touch.view == _attachMessageButton || touch.view == _clearTextButton || touch.view == _requestNowButton || touch.view == _scheduleButton || touch.view == _sendRequestButton || touch.view == _activeSegmentedControl || touch.view == _requestTextView) {
        return NO;
    }
    return YES;
}

#pragma mark - MMPresetMessageDelegate Methods
- (void)presetMessageSelected:(id)message {
    NSString *messageString = message;
    if (messageString.length > 0) {
        [_placeholderLabel setHidden:YES];
        [_requestTextView setText:messageString];
        _characterCountLabel.text = [NSString stringWithFormat:@"%d", _requestTextView.text.length];
    }
}

@end
