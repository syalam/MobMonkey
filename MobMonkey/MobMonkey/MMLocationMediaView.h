//
//  MMLocationMediaView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMLocationMediaView : UIView

//Media
@property (nonatomic, strong) IBOutlet UIImageView *playButtonOverlay;
@property (nonatomic, strong) IBOutlet UIImageView *mediaImageView;

//Media Buttons
@property (nonatomic, weak) IBOutlet UIButton *videosButton;
@property (nonatomic, weak) IBOutlet UIButton *photosButton;
@property (nonatomic, weak) IBOutlet UIButton *liveStreamButton;

//Media Count Labels
@property (nonatomic, strong) IBOutlet UILabel *liveStreamCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *videoCountLabel;
@property (nonatomic, strong) IBOutlet UILabel *photoCountLabel;

//Label Gradients
@property (nonatomic, strong) IBOutlet UIImageView *topGradientView;
@property (nonatomic, strong) IBOutlet UIImageView *bottomGradientView;

//Time Overlay
@property (nonatomic, strong) IBOutlet UIImageView *clockImageView;
@property (nonatomic, strong) IBOutlet UILabel *clockLabel;

//Other Options Button
@property (nonatomic, strong) IBOutlet UIButton *optionsButton;

@end
