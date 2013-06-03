//
//  MMRequestInboxView.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxView.h"
#import "MMCoreGraphicsCommon.h"
@implementation MMRequestInboxView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    }
    return self;
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
    CGContextSetShadow(context, CGSizeMake(0.0, 1.0), 3.0);
    CGContextDrawPath(context, kCGPathFill);
    
    CGContextSetShadow(context, CGSizeMake(0.0, 0.0), 0.0);
    CGContextSetFillColorWithColor(context, [UIColor darkGrayColor].CGColor);
    
    CGPoint point = CGPointMake(FIRST_ROW_XOFFSET, FIRST_ROW_YOFFSET);
        
    
    [_wrapper.durationSincePost drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Light" size:14]];
    
    
    point = CGPointMake(SECOND_ROW_XOFFSET, SECOND_ROW_YOFFSET);
    
    [_wrapper.nameOfLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
    
    
    if(_wrapper.nameOfParentLocation && _wrapper.nameOfParentLocation.length > 0){
        
        point = CGPointMake(THIRD_ROW_XOFFSET, THIRD_ROW_YOFFSET);
        [_wrapper.nameOfParentLocation drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica" size:14]];
    }
    
    point = CGPointMake(FIRST_ROW_XOFFSET  , FORTH_ROW_YOFFSET);
    
    [@"Q:" drawAtPoint:point withFont:[UIFont fontWithName:@"Helvetica-Bold" size:24] ];
    
    point = CGPointMake(FORTH_ROW_SECOND_COLUMN_XOFFSET, FORTH_ROW_YOFFSET);
    
    CGRect frame = CGRectMake(FORTH_ROW_SECOND_COLUMN_XOFFSET, FORTH_ROW_YOFFSET , rect.size.width - 30 - FORTH_ROW_SECOND_COLUMN_XOFFSET, 30);

    [self.wrapper.questionText drawInRect:frame withFont:[UIFont fontWithName:@"Helvetica-LightOblique" size:14] lineBreakMode:NSLineBreakByWordWrapping];
    
    UIImage *image = [UIImage imageNamed:@"poolParty.jpg"];
    
    
    CGSize imageSize = image.size;
    CGSize viewSize = CGSizeMake(310, 310); // size in which you want to draw
    
    float hfactor = imageSize.width / viewSize.width;
    float vfactor = imageSize.height / viewSize.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = imageSize.width / factor;
    float newHeight = imageSize.height / factor;
    
    CGRect imageFrame = CGRectMake(5 ,frame.origin.y + frame.size.height + 10, newWidth, newHeight);
    
    CGContextSetShadow(context, CGSizeMake(0.0, 1.0), 3.0);
    [image drawInRect:imageFrame];
    

    
    
}


@end
