//
//  MMShadowCellBackground.m
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMShadowCellBackground.h"

@implementation MMShadowCellBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.clipsToBounds = NO;
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

-(void)setCellPosition:(MMGroupedCellPosition)cellPosition {
    _cellPosition = cellPosition;
    
    [self setNeedsDisplay];
}

CGMutablePathRef createRoundedCornerPathForTop(CGRect rect) {
    
    // create a mutable path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat cornerRadius = 4;
    CGFloat spaceForShadow = 5;
    
    CGPoint topLeft = CGPointMake(rect.origin.x + spaceForShadow , rect.origin.y + 3);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y + 3);
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y + rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x + spaceForShadow, rect.origin.y + rect.size.height);

    
    // move to bottom left
    CGPathMoveToPoint(path, NULL, bottomLeft.x , bottomLeft.y);
    
    // add left line
    CGPathAddLineToPoint(path, NULL, topLeft.x , topLeft.y + cornerRadius);
    
    // add top left curve
    CGPathAddQuadCurveToPoint(path, NULL, topLeft.x, topLeft.y, topLeft.x + cornerRadius, topLeft.y);
    
    // add top line
    CGPathAddLineToPoint(path, NULL, topRight.x - cornerRadius, topRight.y);
    
    // add top right curve
    CGPathAddQuadCurveToPoint(path, NULL, topRight.x , topRight.y, topRight.x, topRight.y + cornerRadius);
    
    // add right like
    CGPathAddLineToPoint(path, NULL, bottomRight.x, bottomRight.y);
    
    return path;
}

CGMutablePathRef createRoundedCornerPathForBottom(CGRect rect) {
    
    // create a mutable path
    CGMutablePathRef path = CGPathCreateMutable();
    
    CGFloat spaceForShadow = 5;
    
    CGFloat cornerRadius = 4;
    // get the 4 corners of the rect
    CGPoint topLeft = CGPointMake(rect.origin.x + spaceForShadow, rect.origin.y );
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y );
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y + rect.size.height -1 );
    CGPoint bottomLeft = CGPointMake(rect.origin.x + spaceForShadow, rect.origin.y + rect.size.height -1 );
    
    // move to top left
    CGPathMoveToPoint(path, NULL, topLeft.x , topLeft.y);
    
    // add left line
    CGPathAddLineToPoint(path, NULL, bottomLeft.x , bottomLeft.y - cornerRadius);
    
    // add bottom left curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomLeft.x, bottomLeft.y , bottomLeft.x + cornerRadius, bottomLeft.y);
    
    // add bottom line
    CGPathAddLineToPoint(path, NULL, bottomRight.x - cornerRadius, bottomRight.y );
    
    // add bottom left curve
    CGPathAddQuadCurveToPoint(path, NULL, bottomRight.x , bottomRight.y, bottomRight.x, bottomRight.y - cornerRadius);
    
    // add right line
    CGPathAddLineToPoint(path, NULL, topRight.x, topRight.y);
    
    //add bottom
    //CGPathAddLineToPoint(path, NULL, bottomLeft.x, bottomLeft.y);
    
    return path;
}

-(void)drawTopRect:(CGRect)rect position:(MMGroupedCellPosition)cellPosition{
    const CGFloat outlineStrokeWidth = 1.0f;
    const CGFloat outlineCornerRadius = 10.0f;
    
    const CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    const CGColorRef redColor = [[UIColor lightGrayColor] CGColor];
    
    // get the context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // set the background color to white
    CGContextSetFillColorWithColor(context, whiteColor);
    //CGContextFillRect(context, rect);
    
    // inset the rect because half of the stroke applied to this path will be on the outside
    //CGRect insetRect = CGRectInset(rect);
    
    // get our rounded rect as a path
    CGMutablePathRef path = nil;
    
    if(cellPosition == MMGroupedCellPositionTop){
        path = createRoundedCornerPathForTop(rect);
    }else if(cellPosition == MMGroupedCellPositionBottom){
        path = createRoundedCornerPathForBottom(rect);
    }else{
        return;
    }
    
    
    // add the path to the context
    CGContextAddPath(context, path);
    
    UIColor *lightGray = [UIColor colorWithWhite:0.454 alpha:1.0];
    
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 3.0, lightGray.CGColor);
    CGContextSetShouldSubpixelPositionFonts(context, YES);
    CGContextSetBlendMode (context, kCGBlendModeNormal);
    
    // set the stroke params
    CGContextSetStrokeColorWithColor(context, redColor);
    CGContextSetLineWidth(context, outlineStrokeWidth);
    
    // draw the path
    CGContextFillPath(context);
    
    // release the path
    CGPathRelease(path);
}


void draw1PxStroke(CGContextRef context, CGPoint startPoint, CGPoint endPoint, CGColorRef color)
{
    CGContextSaveGState(context);
    CGContextSetLineCap(context, kCGLineCapSquare);
    CGContextSetStrokeColorWithColor(context, color);
    CGContextSetLineWidth(context, 1.0);
    CGContextMoveToPoint(context, startPoint.x + 0.5, startPoint.y + 0.5);
    CGContextAddLineToPoint(context, endPoint.x + 0.5, endPoint.y + 0.5);
    CGContextStrokePath(context);
    CGContextRestoreGState(context);
}

-(void)drawMiddleRect:(CGRect)rect{
    
    const CGFloat outlineStrokeWidth = 1.0f;
    const CGFloat outlineCornerRadius = 10.0f;
    
    const CGColorRef whiteColor = [[UIColor whiteColor] CGColor];
    const CGColorRef redColor = [[UIColor lightGrayColor] CGColor];
    
    // get the context
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, whiteColor);
    
    CGFloat spaceForShadow = 5;
    
    CGPoint topLeft = CGPointMake(rect.origin.x + spaceForShadow , rect.origin.y);
    CGPoint topRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y );
    CGPoint bottomRight = CGPointMake(rect.origin.x + rect.size.width - spaceForShadow, rect.origin.y + rect.size.height);
    CGPoint bottomLeft = CGPointMake(rect.origin.x + spaceForShadow, rect.origin.y + rect.size.height);
    
    CGRect frame = CGRectMake(topLeft.x, topLeft.y, rect.size.width - spaceForShadow * 2 , rect.size.height);
    
    UIColor *lightGray = [UIColor colorWithWhite:0.454 alpha:1.0];
    
    CGContextSetShadowWithColor(context, CGSizeMake(0, 0), 4.0, lightGray.CGColor);
    CGContextSetShouldSubpixelPositionFonts(context, YES);
    CGContextSetBlendMode (context, kCGBlendModeNormal);
    CGContextFillRect(context, frame);
    
}

-(void) drawRect: (CGRect) rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextClearRect(context, rect);
    
    switch (self.cellPosition) {
        case MMGroupedCellPositionTop:
            [self drawTopRect:rect position:self.cellPosition];
            break;
        case MMGroupedCellPositionMiddle:
            [self drawMiddleRect:rect];
            break;
        case MMGroupedCellPositionBottom:
            [self drawTopRect:rect position:self.cellPosition];
            
            break;
            
        default:
            break;
    }
    
    if(self.showSeperator){
        if(self.cellPosition != MMGroupedCellPositionBottom){
            //draw1PxStroke(context, CGPointMake(5, rect.size.height), CGPointMake(rect.size.width-5, rect.size.height), [UIColor grayColor].CGColor);
        }
    }
}
@end
