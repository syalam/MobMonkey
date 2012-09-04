//
//  MMRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/2/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPresetMessagesViewController.h"


@interface MMRequestViewController : UIViewController <UITextViewDelegate, UIGestureRecognizerDelegate, MMPresetMessageDelegate>

@property (nonatomic, retain) IBOutlet UITextView *requestTextView;
@property (nonatomic, retain) IBOutlet UILabel *placeholderLabel;
@property (nonatomic, retain) IBOutlet UILabel *characterCountLabel;
@property (nonatomic, retain) IBOutlet UIButton *videoButton;
@property (nonatomic, retain) IBOutlet UIButton *photoButton;
@property (nonatomic, retain) IBOutlet UIButton *attachMessageButton;
@property (nonatomic, retain) IBOutlet UIButton *requestNowButton;
@property (nonatomic, retain) IBOutlet UIButton *scheduleButton;
@property (nonatomic, retain) IBOutlet UIButton *sendRequestButton;
@property (nonatomic, retain) IBOutlet UIButton *clearTextButton;
@property (nonatomic, retain) IBOutlet UISegmentedControl *activeSegmentedControl;

- (IBAction)attachMessageButtonTapped:(id)sender;

@end
