//
//  MMPlaceInformationCell.h
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceInformationCellWrapper.h"

@interface MMPlaceInformationCellView : UIView {
    BOOL highlighted;
	BOOL editing;
    MMPlaceInformationCellWrapper *cellWrapper;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, strong) MMPlaceInformationCellWrapper *cellWrapper;

@end
