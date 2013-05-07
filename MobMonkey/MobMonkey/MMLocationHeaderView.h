//
//  MMLocationHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

@class MMLocationHeaderView;

@protocol MMLocationHeaderViewDelegate <NSObject>

@optional
-(void)headerViewNeedsToBeSetOnSuperView:(MMLocationHeaderView *)headerView;

@end


#import <UIKit/UIKit.h>
#import "MMLocationMediaView.h"
#import "MMLocationViewController.h"

@interface MMLocationHeaderView : UIView {
    
    BOOL hasMedia;
    CGRect originalFrame;
    
}

@property (nonatomic, strong) UILabel * locationTitleLabel;
@property (nonatomic, strong) UIButton * makeARequestButton;
@property (nonatomic, strong) UILabel *makeARequestLabel;
@property (nonatomic, strong) UILabel *makeARequestSubLabel;
@property (nonatomic, strong) MMLocationMediaView *mediaView;
@property (nonatomic, strong) UIImageView *gradientSpacer;
@property (nonatomic, strong) UIView *loadingView;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;
@property (assign) id <MMLocationHeaderViewDelegate> delegate;


-(void)showMediaView;
-(void)hideMediaView;
-(void)showLoadingView;
-(void)hideLoadingViewShowMedia:(BOOL)showMedia;

@end
