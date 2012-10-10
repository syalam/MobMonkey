//
//  MMMakeRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/4/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAPI.h"
#import "MMPresetMessagesViewController.h"
#import "MMScheduleRequestViewController.h"
#import "MMMakeRequestViewController.h"

@interface MMMakeRequestViewController : UIViewController <MMAPIDelegate, MMPresetMessageDelegate, MMScheduleRequestDelegate, UIGestureRecognizerDelegate, UITextViewDelegate> {
    __weak IBOutlet UIScrollView *scrollView;
    __weak IBOutlet UIButton *videoButton;
    __weak IBOutlet UIButton *photoButton;
    __weak IBOutlet UIButton *addMessageButton;
    __weak IBOutlet UIView *messageView;
    __weak IBOutlet UILabel *messageLabel;
    __weak IBOutlet UIView *secondSectionView;
    __weak IBOutlet UIButton *fifteenMinButton;
    __weak IBOutlet UIButton *thirtyMinButton;
    __weak IBOutlet UIButton *oneHrButton;
    __weak IBOutlet UIButton *threeHrButton;
    __weak IBOutlet UILabel *segmentOneLabel;
    __weak IBOutlet UILabel *segmentTwoLabel;
    __weak IBOutlet UILabel *segmentThreeLabel;
    __weak IBOutlet UILabel *segmentFourLabel;
    __weak IBOutlet UIButton *scheduleButton;
    __weak IBOutlet UIView *scheduleView;
    __weak IBOutlet UILabel *scheduleLabel;
    __weak IBOutlet UIView *sendRequestButtonView;
    __weak IBOutlet UIButton *sendRequestButton;
    __weak IBOutlet UILabel *requestButtonLabel;
    
    NSNumber *selectedDuration;
    NSDate *selectedScheduleDate;
    
    BOOL videoSelected;
    BOOL scheduleRequestDateSelected;
    BOOL uiAdjustedForMessage;
    
    UITapGestureRecognizer *tapGesture;
}

- (IBAction)videoButtonTapped:(id)sender;
- (IBAction)photoButtonTapped:(id)sender;
- (IBAction)addMessageButtonTapped:(id)sender;
- (IBAction)clearMessageButtonTapped:(id)sender;
- (IBAction)stayActiveButtonTapped:(id)sender;
- (IBAction)scheduleButtonTapped:(id)sender;
- (IBAction)clearScheduleButtonTapped:(id)sender;
- (IBAction)sendRequestButtonTapped:(id)sender;


@property (nonatomic, retain)NSDictionary *contentList;

@end
