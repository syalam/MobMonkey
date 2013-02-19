//
//  MMTrendingCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol MMTrendingCellDelegate

-(void)locationNameButtonTapped:(id)sender;
-(void)moreButtonTapped:(id)sender;
-(void)imageButtonTapped:(id)sender;

@end


@interface MMTrendingCell : UITableViewCell

@property (nonatomic, retain) UIButton *locationNameButton;
@property (nonatomic, retain) UILabel *locationNameLabel;
@property (nonatomic, retain) UILabel *requestLabel;
@property (nonatomic, retain) UILabel *responseLabel;
@property (nonatomic, retain) UILabel *timeStampLabel;
@property (nonatomic, retain) TCImageView *locationImageView;
@property (nonatomic, retain) UIImageView *playButtonImageView;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UIButton *acceptButton;
@property (nonatomic, retain) UIButton *rejectButton;
@property (nonatomic, retain) UIImageView *clockImageView;
@property (nonatomic, assign) id<MMTrendingCellDelegate>delegate;

@end
