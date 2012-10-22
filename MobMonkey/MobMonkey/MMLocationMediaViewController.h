//
//  MMLocationMediaViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationMediaCell.h"

@interface MMLocationMediaViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource>

@property (nonatomic, retain) NSArray *contentList;

@end
