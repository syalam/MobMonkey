//
//  MMSubscriptionViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 12/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMAppDelegate.h"

@interface MMSubscriptionViewController : UIViewController {
    IBOutlet UIButton *subscribeButton;
    IBOutlet UIButton *dismissButton;
    IBOutlet UIScrollView *scrollView;
    
    MMAppDelegate *appDelegate;
}
- (IBAction) dismissButtonTapped:(id)sender;
- (IBAction)subscribeButtonTapped:(id)sender;

@end