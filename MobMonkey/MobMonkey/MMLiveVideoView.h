//
//  MMLiveVideoView.h
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLiveVideoWrapper.h"

@class MMLiveVideoWrapper;

@interface MMLiveVideoView : UIView{
    
    BOOL highlighted;
    BOOL editing;
    MMLiveVideoWrapper *cellWrapper;
    UIImageView * placeHolderImageView;
    UIImageView * playButtonOverlay;
}

@property (nonatomic, assign) BOOL highlighted;
@property (nonatomic, assign) BOOL editing;
@property (nonatomic, assign) CGRect messageTouchFrame;
@property (nonatomic, assign) CGRect messageFrame;
@property (nonatomic, strong) MMLiveVideoWrapper *cellWrapper;

-(void)buttonPressed;


@end
