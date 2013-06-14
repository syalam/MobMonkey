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
#import "MMPlaceSectionHeaderWrapper.h"
#import "MMPlaceActionWrapper.h"

@interface MMPlaceViewController : MMMapTableViewController <MMMapTableViewControllerDelegate> {
    MMPlaceInformationCellWrapper *wrapper;
    MMPlaceSectionHeaderWrapper * mediaSectionHeader;
    MMPlaceSectionHeaderWrapper * hotSpotSectionHeader;
    MMPlaceSectionHeaderWrapper * notificationSectionHeader;
    MMPlaceActionWrapper *requestActionWrapper;
    MMPlaceActionWrapper *liveVideoActionWrapper;
}

@property (nonatomic, strong) MMLocationInformation *locationInformation;

@property (nonatomic, strong) MMLocationInformation * newlyCreatedHotSpot;

@end
