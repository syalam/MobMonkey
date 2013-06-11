//
//  MMPlaceActionView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceActionView.h"
#import "MMCoreGraphicsCommon.h"
#import "CustomBadge.h"

@interface MMPlaceActionView()

@property (nonatomic, assign) CGRect originalBadgeFrame;

@end

@implementation MMPlaceActionView

@synthesize cellWrapper, highlighted, editing;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        _badge = [CustomBadge customBadgeWithString:@"1" withStringColor:[UIColor whiteColor] withInsetColor:self.cellWrapper.backgroundColor withBadgeFrame:YES withBadgeFrameColor:[UIColor whiteColor] withScale:0.8 withShining:NO];
        _badge.badgeShadow = NO;
        _originalBadgeFrame = _badge.frame;
        [self addSubview:_badge];
        
    }
    return self;
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    _badge.badgeInsetColor = cellWrapper.backgroundColor;
    
    _badge.frame = CGRectMake(self.frame.size.width - _originalBadgeFrame.size.width - 12, (self.frame.size.height - _originalBadgeFrame.size.height)/2 , _originalBadgeFrame.size.width + 4, _originalBadgeFrame.size.height);
    
    

}

-(void)buttonPressed {
    self.highlighted = YES;
    
    [self setNeedsDisplay];
    
    [self performSelector:@selector(setHighlighted:) withObject:NO afterDelay:0.1];
    [self performSelector:@selector(setNeedsDisplay) withObject:nil afterDelay:0.1];
    
}

-(void)setCellWrapper:(MMPlaceActionWrapper *)newCellWrapper {
    if(cellWrapper != newCellWrapper){
        cellWrapper = newCellWrapper;
    }
    [self setNeedsDisplay];
}

-(void)drawRect:(CGRect)rect {
    
    
    
    
#define FIRST_COLUMN_OFFSET 10
#define SECOND_COLUMN_OFFSET 23
    
    
    
    CGFloat bottomCellAdjustment = 0;
    
   
    CGFloat labelTop = (rect.size.height - 20)/2;
    
    NSString * string = @"Watch Live Video";
    UIImage * image = [UIImage imageNamed:@"play"];
    UIColor *fontColor = [UIColor colorWithRed:0.176 green:0.196 blue:0.322 alpha:1.000];
    
    [cellWrapper.backgroundColor set];
    
    UIFont * font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
    
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    //CGContextSetShadow(context, CGSizeMake(1.0f, 1.0f), 3.0f);
    
    
    CGSize imageSize = cellWrapper.image.size;
    CGSize viewSize = CGSizeMake(32, 32); // size in which you want to draw
    
    float hfactor = imageSize.width / viewSize.width;
    float vfactor = imageSize.height / viewSize.height;
    
    float factor = fmax(hfactor, vfactor);
    
    // Divide the size by the greater of the vertical or horizontal shrinkage factor
    float newWidth = imageSize.width / factor;
    float newHeight = imageSize.height / factor;
    
    CGRect imageFrame = CGRectMake(_badge.frame.origin.x - 10 - 32 ,(rect.size.height - newHeight)/2, newWidth, newHeight);
    
    
    
    
    

    
    CGRect buttonFrame = CGRectMake( 4, (rect.size.height - 4)/2 , rect.size.width - 8 , rect.size.height);
    
    CGRect insetRect = CGRectInset(rect, 0, 0);
    
    CGPathRef path =  createRoundedCornerPath(insetRect, 4);
    
    //const CGColorRef buttonBackgroundColor = [[UIColor colorWithRed:0.230 green:0.394 blue:0.810 alpha:1.000] CGColor];
    
    if(!highlighted)
        CGContextSetFillColorWithColor(context, cellWrapper.backgroundColor.CGColor);
    else
        CGContextSetFillColorWithColor(context, cellWrapper.selectedBackgroundColor.CGColor);
    
    CGContextAddPath(context, path);
    CGContextDrawPath(context, kCGPathFillStroke);
    
    [cellWrapper.image drawInRect:imageFrame];
    
    CGContextSetFillColorWithColor(context, [UIColor whiteColor].CGColor);
    
    
    CGRect textFrame = CGRectMake(5, ((rect.size.height - font.pointSize )/2 ) - 2, rect.size.width - 10 - (rect.size.width - imageFrame.origin.x), font.pointSize );
    
    [cellWrapper.text drawInRect:textFrame withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];
    
    
    
   /*buttonFrame.origin.y = buttonFrame.origin.y + 6;
    buttonFrame.origin.x = 29;
    [cellWrapper.text drawInRect:CGRectMake(20 + viewSize.width, newRect.origin.y, self.frame.size.width - 20 - _badge.frame.size.width - 20, 20) withFont:font lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentCenter];*/
    
    /*buttonFrame.origin.x = (rect.size.width -5*2) - 60;
    buttonFrame.size.width = cellWrapper.image.size.width;
    buttonFrame.size.height = cellWrapper.image.size.height;
    buttonFrame.origin.y += 4;
    
    [cellWrapper.image drawInRect:buttonFrame];*/
    
    
    
    //[image drawInRect:CGRectMake(FIRST_COLUMN_OFFSET + 170 + 10, (rect.size.height - 34)/2, 34, 34)];
    

    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
