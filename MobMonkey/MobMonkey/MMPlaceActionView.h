//
//  MMPlaceActionView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceActionWrapper.h"
#import "CustomBadge.h"

@interface MMPlaceActionView : UIView {
    BOOL highlighted;
	BOOL editing;
    MMPlaceActionWrapper *cellWrapper;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) MMPlaceActionWrapper *cellWrapper;
@property (nonatomic, strong) CustomBadge *badge;

-(void)buttonPressed;

@end
