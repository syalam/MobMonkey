//
//  MMShadowBackground.m
//  MobMonkey
//
//  Created by Michael Kral on 6/4/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMShadowBackground.h"
#import "MMCoreGraphicsCommon.h"
@implementation MMShadowBackground

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor lightGrayColor];
    }
    return self;
}


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [UIColor lightGrayColor].CGColor);
    
    
    
    CGRect rectInset = CGRectInset(rect, 10, 10);
    
    NSLog(@"y offset: %f", rectInset.origin.y);
    
    CGPathRef roundedPath = createRoundedCornerPath(rectInset, 4.0);
    
    CGContextAddPath(context, roundedPath);
    CGContextSetShadow(context, CGSizeMake(0.0, 1.0), 3.0);
    CGContextDrawPath(context, kCGPathFill);
    
}


@end
