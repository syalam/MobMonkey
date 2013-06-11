//
//  MMRequestInboxView.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxView.h"
#import "MMCoreGraphicsCommon.h"
#import <QuartzCore/QuartzCore.h>
#import "UIImageView+AFNetworking.h"
#import "MMClientSDK.h"
#import <MediaPlayer/MediaPlayer.h>
@interface MMRequestInboxView ()

@property (nonatomic, strong) UIFont *questionTextFont;
@property (nonatomic, assign) CGRect acceptButtonFrame;
@property (nonatomic, assign) CGRect rejectButtonFrame;

@end

@implementation MMRequestInboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.userInteractionEnabled = YES;
        // Initialization code
        //self.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
        self.backgroundColor = [UIColor clearColor];
        self.questionTextFont = [UIFont fontWithName:@"Helvetica-LightOblique" size:14];
       
        _imageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _imageView.layer.borderWidth = 1.0f;
        _imageView.layer.borderColor = [UIColor colorWithRed:0.830 green:0.811 blue:0.820 alpha:1.000].CGColor;
        _imageView.clipsToBounds = YES;
        
        _videoOverlayView = [[UIImageView alloc] initWithFrame:CGRectZero];
        _videoOverlayView.contentMode = UIViewContentModeCenter;
        _videoOverlayView.image = [UIImage imageNamed:@"playBtnOverlay"];
        
        UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
        _imageView.userInteractionEnabled = YES;
        [_imageView addGestureRecognizer:tapGesture];
        
        _imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:_imageView];
        [self addSubview:_videoOverlayView];
    }
    return self;
}
-(void)imageTapped:(id)sender{
    if (_wrapper.mediaType == 1) {
        [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self.window.rootViewController imageToDisplay:_imageView.image locationName:_wrapper.nameOfLocation];
    }
    else {
        
        NSURL *url = _wrapper.requestObject.mediaObject.mediaURL;
        NSLog(@"%@", url);
        UIGraphicsBeginImageContext(CGSizeMake(1,1));
        MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self.window.rootViewController presentMoviePlayerViewControllerAnimated:player];
        UIGraphicsEndImageContext();
        
    }
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    CGRect imageViewFrame = CGRectMake((self.frame.size.width - 310)/2, 0, 310, 280);
    if(_wrapper.cellStyle == MMRequestCellStyleInbox || _wrapper.cellStyle == MMRequestCellStyleInboxNeedsReview){
        imageViewFrame.origin.y = 105;
        imageViewFrame.origin.y += _wrapper.questionTextSize.height;
    }else if(_wrapper.cellStyle == MMRequestCellStyleTimeline){
        imageViewFrame.origin.y = 45;
    }
    
    _imageView.frame = imageViewFrame;
    _videoOverlayView.frame = imageViewFrame;
    
    if(_wrapper.mediaType == MMMediaTypeLiveVideo || _wrapper.mediaType == MMMediaTypeVideo){
        _videoOverlayView.hidden = NO;
    }else{
        _videoOverlayView.hidden = YES;
    }
}

-(void)setWrapper:(MMRequestWrapper *)wrapper {
    
    if(_wrapper != wrapper){
        
        _wrapper = wrapper;
        
    }
    
    
    
    if([_wrapper isKindOfClass:[MMMediaRequestWrapper class]]){
        
        MMMediaRequestWrapper *mediaRequest = ((MMMediaRequestWrapper *)_wrapper);
        
        if(mediaRequest.placeholderImage){
            _imageView.hidden = NO;
        }else{
            _imageView.hidden = NO;
        }
       
        _imageView.image = mediaRequest.placeholderImage;
        
        
        [_imageView setImageWithURL:mediaRequest.mediaURL placeholderImage:nil];
        
    }else{
        _imageView.hidden = YES;
    }
    
  
    
    [self setNeedsDisplay];
}
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
#define FIRST_ROW_XOFFSET 18
#define FIRST_ROW_YOFFSET 15
    
#define SECOND_ROW_XOFFSET 35
#define SECOND_ROW_YOFFSET 40
    
#define  THIRD_ROW_XOFFSET 45
#define THIRD_ROW_YOFFSET 64
    
#define FORTH_ROW_YOFFSET 90
#define FORTH_ROW_SECOND_COLUMN_XOFFSET 54
    
    // Draw background color
    UIColor * backgroundColor = [UIColor whiteColor];
    UIColor * selectedBackgroundColor = [UIColor lightGrayColor];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    if(!self.highlighted){
        
        CGContextSetFillColorWithColor(context, backgroundColor.CGColor);
    
    }else{
    
        CGContextSetFillColorWithColor(context, selectedBackgroundColor.CGColor);

    }
        
    CGRect rectInset = CGRectInset(rect, 10, 10);
    
    CGPathRef roundedPath = createRoundedCornerPath(rectInset, 4.0);
    
    CGContextAddPath(context, roundedPath);
    //CGContextSetShadow(context, CGSizeMake(0.0, 1.0), 3.0);
    CGContextDrawPath(context, kCGPathFill);
    
    //CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    CGPoint point = CGPointMake(FIRST_ROW_XOFFSET, FIRST_ROW_YOFFSET);
    
   
        
    
    [_wrapper.durationSincePost drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    
    
    point = CGPointMake(SECOND_ROW_XOFFSET, SECOND_ROW_YOFFSET);
    
    
    if(_wrapper.cellStyle == MMRequestCellStyleInbox || _wrapper.cellStyle == MMRequestCellStyleInboxNeedsReview){
        
        [_wrapper.nameOfLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        
        if(_wrapper.nameOfParentLocation && _wrapper.nameOfParentLocation.length > 0){
            
            point = CGPointMake(THIRD_ROW_XOFFSET, THIRD_ROW_YOFFSET);
            [_wrapper.nameOfParentLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica" size:14]];
        }
        
        point = CGPointMake(FIRST_ROW_XOFFSET  , FORTH_ROW_YOFFSET);
        
    }
    
    point = CGPointMake(FIRST_ROW_XOFFSET, point.y);
    
    

    CGRect frame = CGRectMake(point.x, point.y
                              ,0 , 0);
    if(![self.wrapper.questionText isEqual:[NSNull null]] && self.wrapper.questionText.length > 0){
        
        [@"Q:" drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:24] ];
        
        point = CGPointMake(FORTH_ROW_SECOND_COLUMN_XOFFSET, point.y);
        
        NSLog(@"FLOAT: %f", _wrapper.questionTextSize.height);
        frame = CGRectMake(point.x, point.y + 7 , self.frame.size.width - 70, _wrapper.questionTextSize.height <= 25 ? 25 : _wrapper.questionTextSize.height);
        
        
        
        [self.wrapper.questionText drawInRect:frame withFont:self.questionTextFont lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    
    
    
    
    /*if([_wrapper isKindOfClass:[MMMediaRequestWrapper class]]){
        
        MMMediaRequestWrapper *mediaRequest = ((MMMediaRequestWrapper *)_wrapper);
        
        CGRect imageFrame = CGRectMake((self.frame.size.width - mediaRequest.imageSize.width)/2 ,frame.origin.y + frame.size.height + 10, mediaRequest.imageSize.width, mediaRequest.imageSize.height);
        [mediaRequest.placeholderImage drawInRect:imageFrame];
    }*/
    
    if([_wrapper isKindOfClass:[MMTextRequestWrapper class]]){
        MMTextRequestWrapper *textWrapper = (MMTextRequestWrapper *)_wrapper;
        
        if(textWrapper.answerText && textWrapper.answerText.length > 0){
            point = CGPointMake(FIRST_ROW_XOFFSET, frame.origin.y + frame.size.height +10);
            [@"A:" drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:24]];
            
            point = CGPointMake(FORTH_ROW_SECOND_COLUMN_XOFFSET, point.y + 7);
            
            frame = CGRectMake(point.x, point.y, textWrapper.answerTextSize.width, textWrapper.answerTextSize.height);
            
            [textWrapper.answerText drawInRect:frame withFont:textWrapper.answerTextFont lineBreakMode:NSLineBreakByWordWrapping];
        }
        
        
    }
    
    
    //Draw Accept / Reject Button if needed
    if(_wrapper.cellStyle == MMRequestCellStyleInboxNeedsReview){
        
        if(!self.imageView.hidden){
            point
            .y += 290;
        }
        
        _acceptButtonFrame = CGRectMake(FIRST_ROW_XOFFSET, point.y + frame.size.height + 10, (rect.size.width - (FIRST_ROW_XOFFSET * 2) - (15))/2, 34);
        _rejectButtonFrame = CGRectMake(_acceptButtonFrame.origin.x + _acceptButtonFrame.size.width + 15, _acceptButtonFrame.origin.y, _acceptButtonFrame.size.width, _acceptButtonFrame.size.height);
        
        CGContextSetStrokeColorWithColor(context, [UIColor colorWithRed:0.8 green:0.8 blue:0.8 alpha:1.000].CGColor);
    
        
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.268 green:0.822 blue:0.410 alpha:1.000].CGColor);
        
        CGPathRef acceptPath = createRoundedCornerPath(_acceptButtonFrame, 3);
        CGPathRef rejectPath = createRoundedCornerPath(_rejectButtonFrame, 3);
        
        CGContextAddPath(context, acceptPath);
        
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        CGContextSetFillColorWithColor(context, [UIColor colorWithRed:0.854 green:0.208 blue:0.208 alpha:1.000].CGColor);
        CGContextAddPath(context, rejectPath);
        CGContextDrawPath(context, kCGPathFillStroke);
        
        
        
        CGRect acceptTextFrame = _acceptButtonFrame;
        acceptTextFrame.size.height -= 14;
        acceptTextFrame.origin.y += 5;
        
        CGRect rejectTextFrame = _rejectButtonFrame;
        rejectTextFrame.size.height -= 14;
        rejectTextFrame.origin.y += 5;
        
        UIFont *acceptFont = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        
        CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
        
        [@"Accept" drawInRect:acceptTextFrame withFont:acceptFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];

        [@"Reject" drawInRect:rejectTextFrame withFont:acceptFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    }
    
    
    
    

}

-(CGFloat)heightForView {
    CGFloat height = 0;
    
    //Add Height for duration label
    height += FIRST_ROW_YOFFSET + 14 + 5;
    
    if(_wrapper.cellStyle == MMRequestCellStyleInbox){
        height += FORTH_ROW_YOFFSET - SECOND_ROW_YOFFSET;
    }
    
    if(_wrapper.questionText && _wrapper.questionText.length > 0) {
        CGSize textSize = [_wrapper.questionText sizeWithFont:self.questionTextFont minFontSize:14 actualFontSize:14 forWidth:self.frame.size.width - 30 - FORTH_ROW_SECOND_COLUMN_XOFFSET lineBreakMode:NSLineBreakByWordWrapping];
        
        if(textSize.height < 30){
            height += 40;
        }else{
            height += textSize.height += 10;
        }
    }
    
    if(_wrapper.isAnswered){
        
        if([_wrapper isKindOfClass:[MMMediaRequestWrapper class]]){
            
            height += 310;
            
        }else if([_wrapper isKindOfClass:[MMTextRequestWrapper class]]){
            
            NSString *answerText = ((MMTextRequestWrapper *)_wrapper).answerText;
            
            CGSize textSize = [answerText sizeWithFont:[UIFont fontWithName:@"Helvetica" size:14] minFontSize:14 actualFontSize:14 forWidth:self.frame.size.width - 30 - FORTH_ROW_SECOND_COLUMN_XOFFSET lineBreakMode:NSLineBreakByWordWrapping];
            
            if(textSize.height < 30){
                height += 30;
            }else{
                height += textSize.height + 10;
            }
            
        }
        
    }else{
        height += 10;
    }
    
    
    return height;
    
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    CGPoint startPoint =[touch locationInView:self];
    if(CGRectContainsPoint(_acceptButtonFrame,startPoint))
    {
        if([self.delegate respondsToSelector:@selector(requestInboxViewAcceptTapped:requestObject:)]){
            [self.delegate requestInboxViewAcceptTapped:self requestObject:self.wrapper.requestObject];
        }
    }else if(CGRectContainsPoint(_rejectButtonFrame, startPoint)){
        if([self.delegate respondsToSelector:@selector(requestInboxViewRejectTapped:requestObject:)]){
            [self.delegate requestInboxViewRejectTapped:self requestObject:self.wrapper.requestObject];
        }
    }
    else
        [super touchesBegan:touches withEvent:event];
}

@end
