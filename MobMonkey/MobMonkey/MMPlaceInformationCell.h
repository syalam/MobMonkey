//
//  MMPlaceInformationCell.h
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceInformationCellWrapper.h"
#import "MMPlaceInformationCellView.h"

@class MMPlaceInformationCellWrapper;
@class MMPlaceInformationCellView;

@interface MMPlaceInformationCell : UITableViewCell {
	MMPlaceInformationCellView *placeInformationView;
}

- (void)setPlaceInformationWrapper:(MMPlaceInformationCellWrapper *)newPlaceInformationWrapper;
@property (nonatomic, retain) MMPlaceInformationCellView *placeInformationView;

- (void)redisplay;

@end
