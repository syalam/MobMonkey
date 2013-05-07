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
        _locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 10, 30)];
        _locationTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _locationTitleLabel.backgroundColor = [UIColor clearColor];
        
        [self addSubview:_locationTitleLabel];
        
        CGFloat makeARequestOriginY = self.locationTitleLabel.frame.origin.y + self.locationTitleLabel.frame.size.height + 10;
        
        _makeARequestButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _makeARequestButton.frame = CGRectMake(10, makeARequestOriginY, 300, 66);
        [_makeARequestButton setBackgroundImage:[UIImage imageNamed:@"makeRequestButtonBlank"] forState:UIControlStateNormal];
        
        //Main Label
        _makeARequestLabel = [[UILabel alloc] initWithFrame:CGRectMake(2,8, 294, 26)];
        _makeARequestLabel.textAlignment = NSTextAlignmentCenter;
        _makeARequestLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:20];
        _makeARequestLabel.textColor = [UIColor whiteColor];
        _makeARequestLabel.backgroundColor = [UIColor clearColor];
        _makeARequestLabel.text = @"Make a Request";
        [_makeARequestButton addSubview:_makeARequestLabel];
        
        //Sub-Label
        _makeARequestSubLabel = [[UILabel alloc] initWithFrame:CGRectMake(2, _makeARequestLabel.frame.origin.y + _makeARequestLabel.frame.size.height, _makeARequestLabel.frame.size.width, _makeARequestLabel.frame.size.height)];
        _makeARequestSubLabel.textAlignment = NSTextAlignmentCenter;
        _makeARequestSubLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _makeARequestSubLabel.textColor = [UIColor whiteColor];
        _makeARequestSubLabel.backgroundColor = [UIColor clearColor];
        _makeARequestSubLabel.text = @"Finding Members...";
        [_makeARequestButton addSubview:_makeARequestSubLabel];
        
        
        _gradientSpacer = [[UIImageView alloc] initWithFrame:CGRectMake(0, frame.size.height - 4, frame.size.width, 4)];
        [_gradientSpacer setImage:[UIImage imageNamed:@"separator-gradient"]];
        [self addSubview:_gradientSpacer];

        _mediaView = [[[NSBundle mainBundle] loadNibNamed:@"MMLocationMediaView" owner:self options:0] lastObject];
        _mediaView.frame = CGRectMake(0, _locationTitleLabel.frame.size.height + 20, 320, 320);
        _mediaView.hidden = YES;
        [self addSubview:_mediaView];
        
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

-(void)closeMediaView{
    
}
-(void)openMediaView{
    
    self.mediaView.frame = CGRectMake((self.frame.size.width - self.mediaView.frame.size.width)/2, self.makeARequestButton.frame.origin.y + self.makeARequestButton.frame.size.height + 10, self.mediaView.frame.size.width, self.mediaView.frame.size.height);
    
    self.mediaView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [self addSubview: _mediaView];
    [UIView animateWithDuration:1.0 delay:0.0 options:UIViewAnimationOptionCurveEaseIn animations:^{
        self.mediaView.transform = CGAffineTransformIdentity;
        
        if(self.mediaView.isHidden){
            
            CGRect newFrame = self.frame;
            
            newFrame.size.height += 20 + self.mediaView.frame.size.height;
            
            self.frame = newFrame;
            
        }
        
    } completion:^(BOOL finished) {
        
    }];
    
}

-(void)mediaViewHidden:(BOOL)hidden{
    
    if(hidden){
        [self closeMediaView];
    }else{
        [self openMediaView];
    }
}


- (void)showMediaView{
    NSUInteger oldHeight = self.frame.size.height;
    NSUInteger newHeight = self.frame.size.height + 320 + 20;
    NSInteger originChange = oldHeight - newHeight;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(animationDidStop:finished:context:)];
    
    self.frame = CGRectMake(self.frame.origin.x,
                            self.frame.origin.y,
                            self.frame.size.width,
                            newHeight);
    
    self.gradientSpacer.frame = CGRectMake(self.gradientSpacer.frame.origin.x,
                                           self.gradientSpacer.frame.origin.y - originChange,
                                           self.gradientSpacer.frame.size.width,
                                           self.gradientSpacer.frame.size.height);
    
    self.makeARequestButton.frame = CGRectMake(self.makeARequestButton.frame.origin.x,
                                               self.makeARequestButton.frame.origin.y - originChange,
                                               self.makeARequestButton.frame.size.width,
                                               self.makeARequestButton.frame.size.height);
    
    self.mediaView.frame = CGRectMake(self.mediaView.frame.origin.x,
                                      self.mediaView.frame.origin.y,
                                      self.mediaView.frame.size.width,
                                      self.mediaView.frame.size.height);
    
    /*for (UIView *view in [(UITableView *)self.superview subviews]) {
        if ([view isKindOfClass:[self class]]) {
            continue;
        }
        view.frame = CGRectMake(view.frame.origin.x,
                                view.frame.origin.y - originChange,
                                view.frame.size.width,
                                view.frame.size.height);
    }*/
    
    [UIView commitAnimations];
    
    self.mediaView.hidden = NO;
}

- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
    [(UITableView *)self.superview setTableHeaderView:self];
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
