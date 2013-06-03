//
//  MMRequestInboxCell.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestInboxWrapper.h"
#import "MMRequestInboxView.h"

@interface MMRequestInboxCell : UITableViewCell

@property(nonatomic, strong) MMRequestInboxView * requestInboxView;

-(void)setRequestInboxWrapper:(MMRequestInboxWrapper *)wrapper;

-(void)redisplay;
@end
