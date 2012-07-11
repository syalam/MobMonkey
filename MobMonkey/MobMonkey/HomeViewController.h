//
//  HomeViewController.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface HomeViewController : UITableViewController {
    IBOutlet UIView *headerView;
}

@property (nonatomic, retain)NSString *screen;

- (void)setNavButtons;

@end
