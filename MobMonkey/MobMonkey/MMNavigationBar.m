//
//  MMNavigationBar.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMNavigationBar.h"

@implementation MMNavigationBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.titleTextAttributes =  @{
                                      UITextAttributeFont : [UIFont fontWithName:@"Helvetica-Bold" size:20.0],
                                      UITextAttributeTextColor : [UIColor whiteColor],
                                      UITextAttributeTextShadowColor : [UIColor blackColor],
                                      UITextAttributeTextShadowOffset : [NSValue valueWithUIOffset:UIOffsetMake(0.0, 1.0)]
                                      };
        
    }
    return self;
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    _searchBar.frame = CGRectMake(50, 0, self.frame.size.width - 50, 40);
}
-(void)setTranslucentFactor:(CGFloat)translucentFactor {
    _translucentFactor = translucentFactor;
    [self setNeedsDisplay];
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    UIColor * barColor = [UIColor MMDarkMainColor];
    if(self.translucent){
        barColor = [barColor colorWithAlphaComponent:0.6];
    }

    CGContextSetFillColorWithColor(context, barColor.CGColor);
    CGContextSetRGBStrokeColor(context, 1.0, 0.0, 0.0, 1.0);
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGContextFillRect(context, self.bounds);
}


@end
