//
//  MMFullScreenImageViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMFullScreenImageViewController : UIViewController <UIActionSheetDelegate, UIGestureRecognizerDelegate> {
    __weak IBOutlet UIImageView *imageView;
    __weak IBOutlet UIWebView *webView;
    __weak IBOutlet UIView *overlayButtonView;
    __weak IBOutlet UIButton *overlayToggleButton;
}

@property (nonatomic, weak) IBOutlet UIButton *closeButton;
@property (nonatomic, weak) IBOutlet UIButton *likeButton;
@property (nonatomic, weak) IBOutlet UIButton *dislikeButton;
@property (nonatomic, weak) IBOutlet UIButton *flagButton;
@property (nonatomic, weak) IBOutlet UIButton *shareButton;
@property (nonatomic, retain) UIImage *imageToDisplay;

- (IBAction)overlayToggleButtonTapped:(id)sender;
- (IBAction)closeButtonTapped:(id)sender;
- (IBAction)likeButtonTapped:(id)sender;
- (IBAction)dislikeButtonTapped:(id)sender;
- (IBAction)flagButtonTapped:(id)sender;
- (IBAction)shareButtonTapped:(id)sender;

@end
