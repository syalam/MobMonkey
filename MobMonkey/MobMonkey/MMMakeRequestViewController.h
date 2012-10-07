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
    IBOutlet UIScrollView *scrollView;
    IBOutlet UIButton *videoButton;
    IBOutlet UIButton *photoButton;
    IBOutlet UIButton *addMessageButton;
    IBOutlet UIView *messageView;
    IBOutlet UILabel *messageLabel;
    IBOutlet UIView *secondSectionView;
    IBOutlet UIButton *fifteenMinButton;
    IBOutlet UIButton *thirtyMinButton;
    IBOutlet UIButton *oneHrButton;
    IBOutlet UIButton *threeHrButton;
    IBOutlet UILabel *segmentOneLabel;
    IBOutlet UILabel *segmentTwoLabel;
    IBOutlet UILabel *segmentThreeLabel;
    IBOutlet UILabel *segmentFourLabel;
    IBOutlet UIButton *scheduleButton;
    IBOutlet UIView *scheduleView;
    IBOutlet UILabel *scheduleLabel;
    IBOutlet UIView *sendRequestButtonView;
    IBOutlet UIButton *sendRequestButton;
    IBOutlet UILabel *requestButtonLabel;
    
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
