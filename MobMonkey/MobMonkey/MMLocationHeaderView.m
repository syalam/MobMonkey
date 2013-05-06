//
//  MMLocationHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationHeaderView.h"

@implementation MMLocationHeaderView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        // Initialization code
        _locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        
        [self addSubview:_locationTitleLabel];
        
        CGFloat makeARequestOriginY = self.locationTitleLabel.frame.origin.y + self.locationTitleLabel.frame.size.height + 10;
        
        _makeARequestButton = [[UIButton alloc] initWithFrame:CGRectMake(10, makeARequestOriginY, 300, 66)];
        [_makeARequestButton setBackgroundImage:[UIImage imageNamed:@"makeRequestButtonBlank"] forState:UIControlStateNormal];
        _makeARequestLabel = [[UILabel alloc] initWithFrame:CGRectMake(0,(_makeARequestLabel.frame.size.height - 30)/2 - 5, _makeARequestLabel.frame.size.width, 30)];
        _makeARequestLabel.text = @"Make a Request";
        
        [_makeARequestButton addSubview:_makeARequestLabel];
        
        
        
        [self addSubview:_makeARequestButton];
        
    }
    
    return self;
}

-(void)setMediaView:(MMLocationMediaView *)mediaView {
    
    if(!self.mediaView){
        
        CGRect newFrame = self.frame;
        
        newFrame.size.height += 20 + mediaView.frame.size.height;
        
        self.frame = newFrame;
    }
    
    _mediaView.frame = CGRectMake((self.frame.size.width - mediaView.frame.size.width)/2, self.makeARequestButton.frame.origin.y + self.makeARequestButton.frame.size.height + 10, mediaView.frame.size.width, mediaView.frame.size.height);
    
    _mediaView = mediaView;
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
