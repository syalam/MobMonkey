//
//  MMSectionHeaderCell.h
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceSectionHeaderWrapper.h"
#import "MMPlaceSectionHeaderView.h"


@class MMPlaceSectionHeaderView;
@class MMPlaceSectionHeaderWrapper;

@interface MMSectionHeaderCell : UITableViewCell {
    MMPlaceSectionHeaderView * placeSectionHeaderView;
}


- (void)setPlaceSectionHeaderWrapper:(MMPlaceSectionHeaderWrapper *)newPlaceSectionHeaderWrapper;
@property (nonatomic, retain) MMPlaceSectionHeaderView *placeSectionHeaderView;

- (void)redisplay;

@end
