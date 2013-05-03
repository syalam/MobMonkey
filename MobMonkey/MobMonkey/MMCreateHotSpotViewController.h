//
//  MMCreateHotSpotViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationInformation.h"

@interface MMCreateHotSpotViewController : UITableViewController {
    NSUInteger numberOfLocations;
}

@property (nonatomic, strong) NSArray *nearbyLocations;

@end
