//
//  MMTrendingCell.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMTrendingCellDelegate

- (void)toggleOverlayButtonTapped:(id)sender;
- (void)likeButtonTapped:(id)sender;
- (void)dislikeButtonTapped:(id)sender;
- (void)flagButtonTapped:(id)sender;
- (void)shareButtonTapped:(id)sender;

@end

@interface MMTrendingCell : UITableViewCell
@property(nonatomic, retain)UIImageView *cellBackgroundImage;
@property(nonatomic,retain)UILabel* locationNameLabel;
@property(nonatomic,retain)UILabel* timeLabel;
@property(nonatomic,retain)UIImageView* thumbnailImageView;
@property(nonatomic, retain)UIButton *toggleOverlayButton;
@property(nonatomic, retain)UIImageView *overlayBGImageView;
@property(nonatomic,retain)UIView* overlayButtonView;
@property(nonatomic, retain)UIButton *likeButton;
@property(nonatomic, retain)UIButton *dislikeButton;
@property(nonatomic, retain)UIButton *flagButton;
@property(nonatomic, retain)UIButton *shareButton;
@property(nonatomic,assign)id<MMTrendingCellDelegate> delegate;


@end
