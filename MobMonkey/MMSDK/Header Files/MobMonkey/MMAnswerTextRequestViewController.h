//
//  MMAnswerTextRequestViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 12/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAnswerTextRequestViewController : UIViewController <UITextViewDelegate> {
    IBOutlet UITextView* textView;
    IBOutlet UIButton*  submitButton;
}

- (IBAction)submitButtonTapped:(id)sender;

@property (nonatomic, retain) NSDictionary *requestObject;

@end
