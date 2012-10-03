//
//  MMFullScreenImageViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMFullScreenImageViewController : UIViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate> {
    IBOutlet UIImageView *imageView;
    IBOutlet UIWebView *webView;
    IBOutlet UIView *overlayButtonView;
    IBOutlet UIButton *overlayToggleButton;
}

@property (nonatomic, retain) UIImage *imageToDisplay;
@property (nonatomic, retain)IBOutlet UIButton *closeButton;
@property (nonatomic, retain)IBOutlet UIButton *likeButton;
@property (nonatomic, retain)IBOutlet UIButton *dislikeButton;
@property (nonatomic, retain)IBOutlet UIButton *flagButton;
@property (nonatomic, retain)IBOutlet UIButton *shareButton;
@property (nonatomic) int rowIndex;


- (IBAction)overlayToggleButtonTapped:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
- (IBAction)likeButtonTapped:(id)sender;
- (IBAction)dislikeButtonTapped:(id)sender;
- (IBAction)flagButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;

@end
