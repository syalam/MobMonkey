//
//  MMRequestInboxView.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxView.h"
#import "MMCoreGraphicsCommon.h"

@interface MMRequestInboxView ()

@property (nonatomic, strong) UIFont *questionTextFont;

@end

@implementation MMRequestInboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
        //self.backgroundColor = [UIColor clearColor];
        self.questionTextFont = [UIFont fontWithName:@"Helvetica-LightOblique" size:14];
    }
    return self;
}

-(void)setWrapper:(MMRequestWrapper *)wrapper {
    
    if(_wrapper != wrapper){
        
        _wrapper = wrapper;
        
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
    
    
    if(_wrapper.cellStyle == MMRequestCellStyleInbox){
        
        [_wrapper.nameOfLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        
        
        if(_wrapper.nameOfParentLocation && _wrapper.nameOfParentLocation.length > 0){
            
            point = CGPointMake(THIRD_ROW_XOFFSET, THIRD_ROW_YOFFSET);
            [_wrapper.nameOfParentLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica" size:14]];
        }
        
        point = CGPointMake(FIRST_ROW_XOFFSET  , FORTH_ROW_YOFFSET);
        
    }
    
    point = CGPointMake(FIRST_ROW_XOFFSET, point.y);
    
    [@"Q:" drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:24] ];
    
    point = CGPointMake(FORTH_ROW_SECOND_COLUMN_XOFFSET, point.y);
    
    NSLog(@"FLOAT: %f", _wrapper.questionTextSize.height);
    CGRect frame = CGRectMake(point.x, point.y + 7 , self.frame.size.width - 70, _wrapper.questionTextSize.height <= 25 ? 25 : _wrapper.questionTextSize.height);

    [self.wrapper.questionText drawInRect:frame withFont:self.questionTextFont lineBreakMode:NSLineBreakByWordWrapping];
    
    
    
    
    if([_wrapper isKindOfClass:[MMMediaRequestWrapper class]]){
        
        MMMediaRequestWrapper *mediaRequest = ((MMMediaRequestWrapper *)_wrapper);
        
        CGRect imageFrame = CGRectMake((self.frame.size.width - mediaRequest.imageSize.width)/2 ,frame.origin.y + frame.size.height + 10, mediaRequest.imageSize.width, mediaRequest.imageSize.height);
        [mediaRequest.placeholderImage drawInRect:imageFrame];
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


@end
