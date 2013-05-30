//
//  MMPlaceSectionHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceSectionHeaderView.h"

@implementation MMPlaceSectionHeaderView

@synthesize editing, highlighted, cellWrapper;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor whiteColor];
        
        [self addSubview:cellWrapper.accessoryView];
        
    }
    return self;
}

-(void)setCellWrapper:(MMPlaceSectionHeaderWrapper *)newCellWrapper {
    
    
    if(cellWrapper.accessoryView.superview){
        [cellWrapper.accessoryView removeFromSuperview];
    }
    [self addSubview:newCellWrapper.accessoryView];
    cellWrapper = newCellWrapper;
    
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    //NSLog(@"bool: %s", cellWrapper.showDisclosureIndicator);
        CGFloat xOrigin = cellWrapper.showDisclosureIndicator ? self.frame.size.width - 30 - cellWrapper.accessoryView.frame.size.width : self.frame.size.width - cellWrapper.accessoryView.frame.size.width + 5;
        
        cellWrapper.accessoryView.frame = CGRectMake(xOrigin, (self.frame.size.height - cellWrapper.accessoryView.frame.size.height)/2, cellWrapper.accessoryView.frame.size.width, cellWrapper.accessoryView.frame.size.height);
        
        
}

// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing Icon
    
    
    
    
    CGFloat imageOffset = 0;
    
    CGFloat titleFontSize = 16;
    UIFont *titleFont = [UIFont fontWithName:@"Helvetica-Bold" size:titleFontSize];
    
    if(cellWrapper.icon){
        CGRect imageFrame = [MMCoreGraphicsCommon imageFrameForImage:cellWrapper.icon withinSize:CGSizeMake(22, 22)];
        
        imageFrame.origin.x = 5 + 1;
        imageFrame.origin.y = ((rect.size.height - imageFrame.size.height)/2) + 1;
        imageFrame.size.width += 2;
        imageFrame.size.height +=2;
        
        imageOffset = imageFrame.origin.x + imageFrame.size.width + 5;
        
        [cellWrapper.icon drawInRect:imageFrame];
    }
    
    
    
    //Draw Indicator if Necessary
    
    CGFloat accessoryOffset = 0;
    
    if(cellWrapper.showDisclosureIndicator){
        
        UIImage *indicatorImage = [UIImage imageNamed:@"arrowRight"];
        
        indicatorFrame = [MMCoreGraphicsCommon imageFrameForImage:indicatorImage withinSize:CGSizeMake(22, 22)];
        
        //set offset 
        accessoryOffset = indicatorFrame.size.width + 5;
        
        indicatorFrame.origin.x = rect.size.width - indicatorFrame.size.width ;
        indicatorFrame.origin.y = (rect.size.height - indicatorFrame.size.height)/2;
        
        [indicatorImage drawInRect:indicatorFrame];
        
    }
    
    if(cellWrapper.accessoryView)
    accessoryOffset += cellWrapper.accessoryView.frame.size.width + 5;
    
    CGRect titleRect = CGRectMake(imageOffset + 10, (rect.size.height - titleFontSize)/2, rect.size.width - (imageOffset + 15 + accessoryOffset), titleFontSize);
    
    [cellWrapper.title drawInRect:titleRect withFont:titleFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentLeft];
    
    
}

-(void)setHighlighted:(BOOL)_highlighted {
    //NSLog(@"SHOULD HIGHLIGHT: %d", _highlighted);
    self.backgroundColor = _highlighted ? [UIColor colorWithRed:0.410 green:0.644 blue:1.000 alpha:1.000] : [UIColor whiteColor];
    [self setNeedsDisplay];
    highlighted = _highlighted;
}

@end
