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
    
    if (![questionText isEqual:[NSNull null]]) {
         _questionTextSize = [questionText sizeWithFont:self.questionTextFont constrainedToSize:CGSizeMake(self.tableWidth - 70, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
   
    
    _questionText = questionText;
}
-(CGFloat)cellHeight {
    
    //Add height for duration label
    CGFloat height = 40;
    
    //Add height if cell will show place name and parent place name
    if(self.cellStyle == MMRequestCellStyleInbox){
        height += 80;
    }
    
    /*if(_questionTextSize.height <= 25){
        height += 25;
    }else{*/
        height += _questionTextSize.height ;
    //}
    
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
    
    if(self.isAnswered){
       cellHeight += 310 - 20;
    }
    
    
    return cellHeight;
}
@end


@implementation MMTextRequestWrapper

-(id)initWithTableWidth:(CGFloat)tableWidth {
    if(self = [super initWithTableWidth:tableWidth]){
        _answerTextFont = [UIFont fontWithName:@"Helvetica-Light" size:14];
    }
    return self;
}

-(void)setAnswerText:(NSString *)answerText {
    
    _answerText = answerText;
    [self resizeAnswerTextSize];
}
-(void)setAnswerTextFont:(UIFont *)answerTextFont {
    _answerTextFont = answerTextFont;
    [self resizeAnswerTextSize];
}
-(void)resizeAnswerTextSize{
    _answerTextSize = [_answerText sizeWithFont:self.answerTextFont constrainedToSize:CGSizeMake(self.tableWidth - 70, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
}
-(CGFloat)cellHeight {
    CGFloat cellHeight = [super cellHeight];
    
    
    cellHeight += _answerTextSize.height + 7 + 48;
    
    return cellHeight;
}

@end
