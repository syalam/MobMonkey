//
//  MMLocationMediaCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol MMLocationMediaCellDelegate

-(void)moreButtonTapped:(id)sender;
-(void)imageButtonTapped:(id)sender;

@end

@interface MMLocationMediaCell : UITableViewCell

@property (nonatomic, retain) TCImageView *locationImageView;
@property (nonatomic, retain) UIImageView *playButtonImageView;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UIImageView *clockImageView;
@property (nonatomic, retain) UILabel *timeStampLabel;
@property (nonatomic, assign) id<MMLocationMediaCellDelegate>delegate;

@end
