//
//  MMRequestInboxWrapper.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MMMediaObject.h"

@interface MMRequestInboxWrapper : NSObject

@property (nonatomic, strong) NSString * durationSincePost;
@property (nonatomic, strong) NSString * nameOfLocation;
@property (nonatomic, strong) NSString * nameOfParentLocation;
@property (nonatomic, strong) NSString * questionText;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, assign) MMMediaType mediaType;

@end


@interface MMMediaRequestInboxWrapper : MMRequestInboxWrapper

@property (nonatomic, strong) UIImage * placeholderImage;
@property (nonatomic, strong) NSString * mediaURL;

@end


@interface MMTextRequestInboxWrapper : MMRequestInboxWrapper

@property (nonatomic, strong) NSString * answerText;

@end
