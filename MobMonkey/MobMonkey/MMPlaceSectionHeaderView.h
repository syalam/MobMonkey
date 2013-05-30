//
//  MMPlaceSectionHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceSectionHeaderWrapper.h"
#import "MMCoreGraphicsCommon.h"

@interface MMPlaceSectionHeaderView : UIView {
    BOOL highlighted;
	BOOL editing;
    MMPlaceSectionHeaderWrapper *cellWrapper;
    CGRect indicatorFrame;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) MMPlaceSectionHeaderWrapper *cellWrapper;

@end
