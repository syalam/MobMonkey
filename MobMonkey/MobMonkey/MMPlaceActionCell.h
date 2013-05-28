//
//  MMPlaceActionCell.h
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMPlaceActionView.h"
#import "MMPlaceActionWrapper.h"

@interface MMPlaceActionCell : UITableViewCell {
    MMPlaceActionView *placeActionView;
}

- (void)setPlaceActionWrapper:(MMPlaceActionWrapper *)newPlaceActionWrapper;
@property (nonatomic, retain) MMPlaceActionView *placeActionView;

- (void)redisplay;


@end
