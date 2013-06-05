//
//  MMRequestInboxView.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestWrapper.h"
#import "MMRequestInboxCell.h"



@class MMRequestWrapper;

@interface MMRequestInboxView : UIView

@property (nonatomic, strong) MMRequestWrapper *wrapper;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) MMRequestCellStyle style;
@property (nonatomic, assign) MMMediaType mediaType;

@end
