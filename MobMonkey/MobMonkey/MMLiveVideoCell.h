//
//  MMLiveVideoCell.h
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLiveVideoView.h"

@class MMLiveVideoWrapper;
@class MMLiveVideoView;

@interface MMLiveVideoCell : UITableViewCell {
    MMLiveVideoView *liveVideoView;
}

- (void)setLiveVideoWrapper:(MMLiveVideoWrapper *)newLiveVideoWrapper;
@property (nonatomic, retain) MMLiveVideoView *liveVideoView;

- (void)redisplay;

@end
