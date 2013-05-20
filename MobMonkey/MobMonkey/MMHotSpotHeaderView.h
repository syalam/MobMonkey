//
//  MMHotSpotHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WEPopoverController.h"



@interface MMHotSpotHeaderView : UIView {
    
    BOOL useCurrentLocation;
}

@property (nonatomic, strong) UIButton *createHotSpotButton;
@property (nonatomic, strong) UISearchBar *searchBar;
@property (nonatomic, strong) UIToolbar *toolbar;
@property (nonatomic, strong) UIBarButtonItem *locationButton;
@property (nonatomic, strong) WEPopoverController *popOverController;


@end
