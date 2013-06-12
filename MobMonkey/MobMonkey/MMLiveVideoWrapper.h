//
//  MMLiveVideoWrapper.h
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMediaObject.h"

@interface MMLiveVideoWrapper : NSObject

@property (nonatomic, strong) NSString * cameraName;
@property (nonatomic, strong) NSString * messageString;
@property (nonatomic, strong) NSURL * messageURL;
@property (nonatomic, strong) UIImage * webcamPlaceholder;
@property (nonatomic, strong) NSURL * mediaURL;
@property (nonatomic, assign, readonly) CGSize messageStringSize;
@property (nonatomic, strong) UIFont * messageStringFont;
@property (nonatomic, strong) MMMediaObject * mediaObject;
-(CGFloat)cellHeight;

@end
