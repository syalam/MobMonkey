//
//  MMLocationHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationHeaderView.h"
#import "MMLocationMediaView.h"

@implementation MMLocationHeaderView

@synthesize mediaView = _mediaView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.clipsToBounds = YES;
        
        // Initialization code
        _locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, frame.size.width, 30)];
        
        [self addSubview:_locationTitleLabel];
        
        CGFloat makeARequestOriginY = self.locationTitleLabel.frame.origin.y + self.locationTitleLabel.frame.size.height + 10;
        
        _makeARequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeARequestButton.frame = CGRectMake(10, makeARequestOriginY, 300, 66);
        [_makeARequestButton setBackgroundImage:[UIImage imageNamed:@"makeRequestButtonBlank"] forState:UIControlStateNormal];
        _makeARequestLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,8, 294, 30)];
        _makeARequestLabel.textAlignment = NSTextAlignmentCenter;
        _makeARequestLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _makeARequestLabel.textColor = [UIColor whiteColor];
        _makeARequestLabel.backgroundColor = [UIColor clearColor];
        _makeARequestLabel.text = @"Make a Request";
        
        [_makeARequestButton addSubview:_makeARequestLabel];
        
        UIImageView *gradientSpacer = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 4, frame.size.width, 4)];
        [gradientSpacer setImage:[UIImage imageNamed:@"separator-gradient"]];
        [self addSubview:gradientSpacer];

        
        [self addSubview:_makeARequestButton];
        
    }
    
    return self;
}

-(void)setMediaView:(MMLocationMediaView *)mediaView {
    
    if(!_mediaView){
        
        CGRect newFrame = self.frame;
        
        newFrame.size.height += 20 + mediaView.frame.size.height;
        
        self.frame = newFrame;
        
        
    }
    
    mediaView.frame = CGRectMake((self.frame.size.width - mediaView.frame.size.width)/2, self.makeARequestButton.frame.origin.y + self.makeARequestButton.frame.size.height + 10, mediaView.frame.size.width, mediaView.frame.size.height);
    [self addSubview:mediaView];

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
