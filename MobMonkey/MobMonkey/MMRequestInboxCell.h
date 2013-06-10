//
//  MMRequestInboxCell.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestWrapper.h"
#import "MMRequestInboxView.h"

@class MMRequestInboxView;
@class MMRequestInboxCell;

@protocol MMRequestInboxCellDelegate <NSObject>

@optional
-(void)requestInboxCell:(MMRequestInboxCell *)cell mediaWasAccepted:(BOOL)accepted;

@end

@class MMRequestInboxView;

@interface MMRequestInboxCell : UITableViewCell <MMRequestInboxViewDelegate>

@property(nonatomic, strong) MMRequestInboxView * requestInboxView;

-(void)setRequestInboxWrapper:(MMRequestWrapper *)wrapper;

-(void)redisplay;
-(id)initWithStyle:(MMRequestCellStyle)style mediaType:(MMMediaType)mediaType reuseIdentifier:(NSString *)reuseIdentifier;


@end
