//
//  MMRequestInboxView.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestWrapper.h"
//#import "MMRequestInboxCell.h"

@class MMRequestInboxView;
@class MMRequestInboxCell;


@protocol MMRequestInboxViewDelegate <NSObject>

-(void)requestInboxViewAcceptTapped:(MMRequestInboxView *)wrapper requestObject:(MMRequestObject *)requestObject;

-(void)requestInboxViewRejectTapped:(MMRequestInboxView *)wrapper requestObject:(MMRequestObject *)requestObject;

@end



@interface MMRequestInboxView : UIView 

@property (nonatomic, strong) MMRequestWrapper *wrapper;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) MMRequestCellStyle style;
@property (nonatomic, assign) MMMediaType mediaType;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UIImageView *videoOverlayView;
@property (nonatomic, strong) UIImage *requestIcon;
@property (nonatomic, strong) UIImage *responseIcon;
@property (assign) id <MMRequestInboxViewDelegate> delegate;

@end
