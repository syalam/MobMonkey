//
//  MMRequestInboxWrapper.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    MMRequestCellStyleInbox = 1,
    MMRequestCellStyleTimeline
} MMRequestCellStyle;


#import <Foundation/Foundation.h>
#import "MMMediaObject.h"

@class MMRequestObject;

@interface MMRequestWrapper : NSObject

@property (nonatomic, strong) NSString * durationSincePost;
@property (nonatomic, strong) NSString * questionText;
@property (nonatomic, assign) BOOL isAnswered;
@property (nonatomic, strong) NSString * nameOfLocation;
@property (nonatomic, strong) NSString * nameOfParentLocation;
@property (nonatomic, assign) MMMediaType mediaType;
@property (nonatomic, assign) MMRequestCellStyle cellStyle;
@property (nonatomic, strong) MMRequestObject * requestObject;

//@property (nonatomic, readonly) CGFloat cellHeight;

@property (nonatomic, strong) UIFont * questionTextFont;
@property (nonatomic, assign,readonly) CGSize questionTextSize;


-(CGFloat)cellHeight;
-(id)initWithTableWidth:(CGFloat)tableWidth;

@end

@interface MMMediaRequestWrapper : MMRequestWrapper

@property (nonatomic, strong) UIImage * placeholderImage;
@property (nonatomic, strong) NSURL * mediaURL;
@property (nonatomic, readonly) CGSize imageSize;

@end


@interface MMTextRequestWrapper : MMRequestWrapper

@property (nonatomic, strong) NSString * answerText;
@property (nonatomic, assign) CGSize answerTextSize;
@property (nonatomic, strong) UIFont * answerTextFont;

@end
