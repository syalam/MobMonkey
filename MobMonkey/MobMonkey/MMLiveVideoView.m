//
//  MMLiveVideoView.m
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLiveVideoView.h"
#import "MMCoreGraphicsCommon.h"
#import <QuartzCore/QuartzCore.h>
#import <MediaPlayer/MediaPlayer.h>
#import "BrowserViewController.h"
#import "UIBarButtonItem+NoBorder.h"

@implementation MMLiveVideoView

#define FIRST_ROW_XOFFSET 18
#define FIRST_ROW_YOFFSET 15

#define SECOND_ROW_XOFFSET 18
#define SECOND_ROW_YOFFSET 50
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.userInteractionEnabled = YES;
        self.backgroundColor = [UIColor clearColor];
        
        placeHolderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(5, 0, 310, 280)];
        placeHolderImageView.image = [UIImage imageNamed:@"liveStreamPlaceholder"];
        placeHolderImageView.layer.borderColor = [UIColor lightGrayColor].CGColor;
        placeHolderImageView.layer.borderWidth = 1.0;
        placeHolderImageView.userInteractionEnabled = YES;
        placeHolderImageView.contentMode = UIViewContentModeScaleAspectFill;
        placeHolderImageView.clipsToBounds = YES;
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(videoButtonTapped:)];
        
        [placeHolderImageView addGestureRecognizer:tapGesture];
        [self addSubview:placeHolderImageView];
        
        playButtonOverlay = [[UIImageView alloc] initWithFrame:CGRectZero];
        playButtonOverlay.image = [UIImage imageNamed:@"playBtnOverlay"];
        playButtonOverlay.contentMode = UIViewContentModeCenter;
        
        [self addSubview:playButtonOverlay];
        
        rightArrowView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        rightArrowView.contentMode = UIViewContentModeScaleAspectFit;
        rightArrowView.image = [UIImage imageNamed:@"arrowRight"];
        [self addSubview:rightArrowView];
        
        
        
    }
    return self;
}

-(void)videoButtonTapped:(id)sender{
    NSLog(@"tapped");
    NSURL *url = _cellWrapper.mediaObject.mediaURL;
    NSLog(@"%@", url);
    UIGraphicsBeginImageContext(CGSizeMake(1,1));
    MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
    [self.window.rootViewController presentMoviePlayerViewControllerAnimated:player];
    UIGraphicsEndImageContext();

    
}
-(void)messageTapped{

}
-(void)layoutSubviews {
    
    _messageFrame = CGRectMake((self.frame.size.width - 260)/2, SECOND_ROW_YOFFSET, _cellWrapper.messageStringSize.width , _cellWrapper.messageStringSize.height);
    
    _messageTouchFrame = CGRectInset(_messageFrame,  -5 , -5);
    _messageTouchFrame.size.width += 10;
    
    CGRect imageViewFrame = placeHolderImageView.frame;
    
    imageViewFrame.origin.y = _messageTouchFrame.origin.y + _messageTouchFrame.size.height + 17;
    
    placeHolderImageView.frame = imageViewFrame;
    playButtonOverlay.frame = imageViewFrame;
    
    CGRect rightArrowFrame = rightArrowView.frame;
    rightArrowFrame.origin.x = _messageTouchFrame.origin.x + _messageTouchFrame.size.width + 3;
    rightArrowFrame.origin.y = _messageTouchFrame.origin.y + (_messageTouchFrame.size.height - 25)/2;
    rightArrowView.frame = rightArrowFrame;
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    

    
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
    
    
    [self.cellWrapper.cameraName drawAtPoint:point forWidth:rect.size.width - 36 withFont:[UIFont fontWithName:@"Helvetica-Bold" size:18] fontSize:18 lineBreakMode:NSLineBreakByTruncatingTail baselineAdjustment:UIBaselineAdjustmentAlignBaselines];

    _messageFrame = CGRectMake((rect.size.width - 260)/2, SECOND_ROW_YOFFSET, _cellWrapper.messageStringSize.width , _cellWrapper.messageStringSize.height);
    
    _messageTouchFrame = CGRectInset(_messageFrame,  -5 , -5);
    _messageTouchFrame.size.width += 10;
    
    CGPathRef messageStrokePath = createRoundedCornerPath(_messageTouchFrame, 5);
    
    CGContextAddPath( context, messageStrokePath);
    
    CGContextSetStrokeColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    CGContextStrokePath(context);
    

    [self.cellWrapper.messageString drawInRect:_messageFrame withFont:self.cellWrapper.messageStringFont lineBreakMode:NSLineBreakByWordWrapping];
}
-(void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch =[touches anyObject];
    CGPoint startPoint =[touch locationInView:self];
    if(CGRectContainsPoint(_messageTouchFrame,startPoint))
    {
        if([self.delegate respondsToSelector:@selector(liveVideoView:messageURLClick:)]){
            [self.delegate liveVideoView:self messageURLClick:self.cellWrapper.messageURL];
        }
    }
    else
        [super touchesBegan:touches withEvent:event];
}

@end
