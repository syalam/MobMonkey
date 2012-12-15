//
//  MMSubscriptionViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 12/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMSubscriptionViewController : UIViewController {
    IBOutlet UIButton *subscribeButton;
}
- (IBAction) dismiss;
- (IBAction)subscribeButtonTapped:(id)sender;

@end
