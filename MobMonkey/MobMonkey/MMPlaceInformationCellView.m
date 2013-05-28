//
//  MMPlaceInformationCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceInformationCellView.h"

@interface MMPlaceInformationCellView()

@property (nonatomic, assign) CGRect actionButtonFrame;

@end

@implementation MMPlaceInformationCellView

@synthesize cellWrapper, editing, highlighted;

- (id)initWithFrame:(CGRect)frame {
	
	if (self = [super initWithFrame:frame]) {
		
		/*
		 Cache the formatter. Normally you would use one of the date formatter styles (such as NSDateFormatterShortStyle), but here we want a specific format that excludes seconds.
		 */
		self.opaque = YES;
		self.backgroundColor = [UIColor whiteColor];
        self.actionButtonFrame = CGRectMake(self.frame.size.width - 64, 34, 26, 20);
	}
	return self;
}

-(void)setCellWrapper:(MMPlaceInformationCellWrapper *)newCellWrapper {
    if(cellWrapper != newCellWrapper){
        cellWrapper = newCellWrapper;
    }
    [self setNeedsDisplay];
}


-(void)drawRect:(CGRect)rect {
#define LEFT_COLUMN_OFFSET 10
#define LEFT_COLUMN_WIDTH 200
	
#define RIGHT_COLUMN_OFFSET 190
#define RIGHT_COLUMN_WIDTH 90
	
#define FIRST_ROW_TOP 8
#define SECOND_ROW_TOP 30
#define THIRD_ROW_TOP 46
	
#define MAIN_FONT_SIZE 18
#define MIN_MAIN_FONT_SIZE 16
#define SECONDARY_FONT_SIZE 12
#define MIN_SECONDARY_FONT_SIZE 12
    UIButton *button = [UIButton buttonWithType:UIButtonTypeContactAdd];
    button.frame = CGRectMake(0, 0, 30, 30);
    
        
    // Color and font for the main text items (time zone name, time)
	UIColor *mainTextColor = nil;
	UIFont *mainFont = [UIFont systemFontOfSize:MAIN_FONT_SIZE];
    
	// Color and font for the secondary text items (GMT offset, day)
	UIColor *secondaryTextColor = nil;
	UIFont *secondaryFont = [UIFont systemFontOfSize:SECONDARY_FONT_SIZE];
	
	// Choose font color based on highlighted state.
	/*if (self.highlighted) {
		mainTextColor = [UIColor whiteColor];
		secondaryTextColor = [UIColor whiteColor];
	}
	else {*/
    mainTextColor = [UIColor blackColor];
    secondaryTextColor = [UIColor darkGrayColor];
    self.backgroundColor = [UIColor whiteColor];
	//}
	
	CGRect contentRect = self.bounds;
	
	// In this example we will never be editing, but this illustrates the appropriate pattern.
    //if (!self.editing) {
		
    CGFloat boundsX = contentRect.origin.x;
    CGPoint point;
    
    // Set the color for the main text items.
    [mainTextColor set];
    
    /*
     Draw the Place Name
     */
    point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, FIRST_ROW_TOP);
    [cellWrapper.nameText drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:mainFont minFontSize:MIN_MAIN_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
   

    
    /*
     Draw the current time, right-aligned in the middle column.
     To ensure it is right-aligned, first find its width with the given font and minimum allowed font size. Then draw the string at the appropriate offset.
     */

    
    point = CGPointMake(boundsX + RIGHT_COLUMN_OFFSET , FIRST_ROW_TOP);
    //[cellWrapper.distanceText drawAtPoint:point forWidth:RIGHT_COLUMN_WIDTH withFont:secondaryFont minFontSize:MIN_SECONDARY_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    
    [cellWrapper.distanceText drawInRect:CGRectMake(boundsX  + RIGHT_COLUMN_OFFSET, FIRST_ROW_TOP, RIGHT_COLUMN_WIDTH, 24) withFont:secondaryFont lineBreakMode:NSLineBreakByTruncatingTail alignment:NSTextAlignmentRight];
    
    //TODO CHANGE THIS TO FIX ALIGNMENT
    //cellWrapper.distanceText draw
    
    
    // Set the color for the secondary text items.
    [secondaryTextColor set];
    
    /*
     Draw the abbreviation botton left; use the NSString UIKit method to scale the font size down if the text does not fit in the given area.
     */
    point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, SECOND_ROW_TOP);
    [cellWrapper.address1Text drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:secondaryFont minFontSize:MIN_SECONDARY_FONT_SIZE actualFontSize:NULL lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    
    point = CGPointMake(boundsX + LEFT_COLUMN_OFFSET, THIRD_ROW_TOP);
    [cellWrapper.address2Text drawAtPoint:point forWidth:LEFT_COLUMN_WIDTH withFont:secondaryFont fontSize:MIN_SECONDARY_FONT_SIZE lineBreakMode:UILineBreakModeTailTruncation baselineAdjustment:UIBaselineAdjustmentAlignBaselines];
    
    
    UIImage *moreImage = [UIImage imageNamed:@"more"];
    
    [moreImage drawInRect:self.actionButtonFrame];
}

@end
