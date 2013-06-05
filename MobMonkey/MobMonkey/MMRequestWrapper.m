//
//  MMRequestInboxWrapper.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestWrapper.h"
#import "MMRequestInboxView.h"

@interface MMRequestWrapper()

@property (nonatomic, readonly) CGFloat tableWidth;

@end

@implementation MMRequestWrapper


-(id)initWithTableWidth:(CGFloat)tableWidth{
    
    self = [super init];
    
    if(self){
       _tableWidth = tableWidth;
        
        _questionTextFont = [UIFont fontWithName:@"Helvetica-LightOblique" size:14];
    }
    
    return self;
}
-(void)setQuestionText:(NSString *)questionText {
    //_questionTextSize = [questionText sizeWithFont:self.questionTextFont forWidth:self.tableWidth - 50 lineBreakMode:NSLineBreakByWordWrapping];
    
    _questionTextSize = [questionText sizeWithFont:self.questionTextFont constrainedToSize:CGSizeMake(self.tableWidth - 70, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    
    _questionText = questionText;
}
-(CGFloat)cellHeight {
    
    //Add height for duration label
    CGFloat height = 60;
    
    //Add height if cell will show place name and parent place name
    if(self.cellStyle == MMRequestCellStyleInbox){
        height += 20;
    }
    
    if(_questionTextSize.height <= 25){
        height += 25;
    }else{
        height += _questionTextSize.height + 5;
    }
    
    return height;
    
}
@end


@implementation MMMediaRequestWrapper

-(void)setPlaceholderImage:(UIImage *)placeholderImage {
    
    
    if(placeholderImage == nil){
        _imageSize = CGSizeZero;
    }else{
        
        CGSize imageSize = placeholderImage.size;
        CGSize viewSize = CGSizeMake(310, 310); // size in which you want to draw
        
        float hfactor = imageSize.width / viewSize.width;
        float vfactor = imageSize.height / viewSize.height;
        
        float factor = fmax(hfactor, vfactor);
        
        // Divide the size by the greater of the vertical or horizontal shrinkage factor
        float newWidth = imageSize.width / factor;
        float newHeight = imageSize.height / factor;
        
        
        _imageSize = CGSizeMake(newWidth, newHeight);
        
    }
    
    _placeholderImage = placeholderImage;
    
}
-(CGFloat)cellHeight {
    CGFloat cellHeight = [super cellHeight];
    
    cellHeight += _imageSize.height + 45;
    
    return cellHeight;
}
@end


@implementation MMTextRequestWrapper

@end
