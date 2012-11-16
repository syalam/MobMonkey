//
//  MMAnsweredRequestsCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 11/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol MMAnsweredRequestsCellDelegate

-(void)locationNameButtonTapped:(id)sender;
-(void)moreButtonTapped:(id)sender;
-(void)acceptButtonTapped:(id)sender;
-(void)rejectButtonTapped:(id)sender;
-(void)imageButtonTapped:(id)sender;

@end

@interface MMAnsweredRequestsCell : UITableViewCell

@property (nonatomic, retain) UIButton *locationNameButton;
@property (nonatomic, retain) UILabel *locationNameLabel;
@property (nonatomic, retain) UILabel *timeStampLabel;
@property (nonatomic, retain) TCImageView *locationImageView;
@property (nonatomic, retain) UIButton *imageButton;
@property (nonatomic, retain) UIButton *moreButton;
@property (nonatomic, retain) UIButton *acceptButton;
@property (nonatomic, retain) UIButton *rejectButton;
@property (nonatomic, assign) id<MMAnsweredRequestsCellDelegate>delegate;

@end
