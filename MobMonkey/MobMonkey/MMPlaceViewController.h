//
//  MMPlaceViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMMapTableViewController.h"
#import "MMPlaceInformationCellWrapper.h"

@interface MMPlaceViewController : MMMapTableViewController <MMMapTableViewControllerDelegate> {
    MMPlaceInformationCellWrapper *wrapper;
}

@end
