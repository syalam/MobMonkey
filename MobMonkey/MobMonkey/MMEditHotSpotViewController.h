//
//  MMEditHotSpotViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/2/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationInformation.h"
#import "MMMapSelectView.h"
#import "MMTextFieldCell.h"

@interface MMEditHotSpotViewController : UITableViewController<MMMapSelectViewDelegate, UITextFieldDelegate> {
    UIButton *createSubLocationButton;
}

@property (nonatomic, weak) MMLocationInformation *parentLocation;
@property (nonatomic, strong) NSArray *cellLabels;
@property (nonatomic, strong) MMMapSelectView *mapSelectView;
@property (nonatomic, strong) MMLocationInformation *sublocationInformation;

@property (nonatomic, strong) NSString *nameText;
@property (nonatomic, strong) NSString *descriptionText;
@property (nonatomic, strong) NSString *rangeText;

@end
