//
//  MMRequestInboxView.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMRequestInboxWrapper.h"

@interface MMRequestInboxView : UIView

@property (nonatomic, strong) MMRequestInboxWrapper *wrapper;
@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;

@end
