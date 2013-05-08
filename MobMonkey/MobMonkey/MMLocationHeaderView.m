//
//  MMLocationHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationHeaderView.h"
#import "MMLocationMediaView.h"
#import <QuartzCore/QuartzCore.h>
#import "MMHotSpotBadge.h"

#define origHeaderHeight 120;

@implementation MMLocationHeaderView

@synthesize mediaView = _mediaView;
@synthesize delegate = _delegate;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        originalFrame = frame;
        self.clipsToBounds = YES;
        
        // Initialization code
        _locationTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 10, frame.size.width - 46, 30)];
        _locationTitleLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _locationTitleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        _locationTitleLabel.backgroundColor = [UIColor clearColor];
        
        _locationDetailLabel = [[UILabel alloc] initWithFrame:CGRectMake(25, _locationTitleLabel.frame.size.height, frame.size.width - 46 - 25, 30)];
        _locationDetailLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        _locationDetailLabel.font = [UIFont fontWithName:@"Helvetica" size:14];
        _locationDetailLabel.backgroundColor = [UIColor clearColor];
        
        _hotSpotBadge = [[MMHotSpotBadge alloc] init];
        _hotSpotBadge.frame = CGRectMake(_locationTitleLabel.frame.size.width + 5, 14, 36, 22);
        _hotSpotBadge.hidden = YES;
        [self addSubview:_hotSpotBadge];
        
        [self addSubview:_locationTitleLabel];
        [self addSubview:_locationDetailLabel];
        
        CGFloat makeARequestOriginY = self.locationDetailLabel.frame.origin.y + self.locationDetailLabel.frame.size.height + 10;
        
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
        _mediaView.frame = CGRectMake(0, _locationTitleLabel.frame.size.height + 30, 320, 320);
        _mediaView.hidden = YES;
        [self addSubview:_mediaView];
        
        [self addSubview:_makeARequestButton];
        
        CGRect loadingViewFrame = _locationDetailLabel.frame;
        loadingViewFrame.origin.y += _locationTitleLabel.frame.size.height;
        loadingViewFrame.size.width = self.frame.size.width;
        
        _loadingView = [[UIView alloc] initWithFrame:loadingViewFrame];
        
        _indicatorView = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake((self.frame.size.width -44 )/2, 4, 22, 22)];
        _indicatorView.color = [UIColor blackColor];
        [_indicatorView startAnimating];

        
        UILabel *loadingLabel = [[UILabel alloc] initWithFrame:CGRectMake(_indicatorView.frame.origin.x + 10, 4, 100, 22)];
        
        loadingLabel.backgroundColor = [UIColor clearColor];
        //loadingLabel.text = @"Loading";
        
        [_loadingView addSubview:_indicatorView];
        [_loadingView addSubview:loadingLabel];
        
        _loadingView.hidden = YES;
        
        [self addSubview:_loadingView];
        
        
        
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


- (void)showMediaView{
    NSUInteger oldHeight = self.frame.size.height;
    NSUInteger newHeight = self.frame.size.height + 320 + 20;
    NSInteger originChange = oldHeight - newHeight;
    self.mediaView.transform = CGAffineTransformMakeScale(0.01, 0.01);
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.6f];
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
    
    self.mediaView.transform = CGAffineTransformIdentity;
    
    for (UIView *view in [(UITableView *)self.superview subviews]) {
        if ([view isKindOfClass:[self class]] ||
            [view isEqual:self.gradientSpacer] ||
            [view isEqual:self.makeARequestButton]||
            [view isEqual:self.mediaView]) {
            continue;
        }
        view.frame = CGRectMake(view.frame.origin.x,
                                view.frame.origin.y - originChange,
                                view.frame.size.width,
                                view.frame.size.height);
    }

    
    
    [UIView commitAnimations];
    
    self.mediaView.hidden = NO;
}
-(void)hideMediaView {
    NSUInteger oldHeight = self.frame.size.height;
    NSUInteger newHeight = self.frame.size.height - 340;
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
    
    for (UIView *view in [(UITableView *)self.superview subviews]) {
        if ([view isKindOfClass:[self class]] ||
            [view isEqual:self.gradientSpacer] ||
            [view isEqual:self.makeARequestButton]||
            [view isEqual:self.mediaView]) {
            continue;
        }
        view.frame = CGRectMake(view.frame.origin.x,
                                view.frame.origin.y - originChange,
                                view.frame.size.width,
                                view.frame.size.height);
    }
    
    
    [UIView commitAnimations];
    
    self.mediaView.hidden = YES;
}

-(void)showLoadingView {
    
    NSUInteger oldHeight = self.frame.size.height;
    NSUInteger newHeight = self.frame.size.height + 30;
    NSInteger originChange = oldHeight - newHeight;
    
    [UIView beginAnimations:nil context:nil];
    
    [UIView setAnimationDuration:0.4f];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(setHeaderView)];
    
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
    
    for (UIView *view in [(UITableView *)self.superview subviews]) {
        if ([view isKindOfClass:[self class]] ||
            [view isEqual:self.gradientSpacer] ||
            [view isEqual:self.makeARequestButton]||
            [view isEqual:self.mediaView]) {
            continue;
        }
        view.frame = CGRectMake(view.frame.origin.x,
                                view.frame.origin.y - originChange,
                                view.frame.size.width,
                                view.frame.size.height);
    }
    
    
    [UIView commitAnimations];
    
    self.loadingView.hidden = NO;
    
}

-(void)hideLoadingViewShowMedia:(BOOL)showMedia {
    
        
    NSUInteger oldHeight = self.frame.size.height;
    NSUInteger newHeight = self.frame.size.height - 30;
    NSInteger originChange = oldHeight - newHeight;
    
    [UIView animateWithDuration:0.4f delay:0.0f options:UIViewAnimationCurveEaseIn animations:^{
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
        
        for (UIView *view in [(UITableView *)self.superview subviews]) {
            if ([view isKindOfClass:[self class]] ||
                [view isEqual:self.gradientSpacer] ||
                [view isEqual:self.makeARequestButton]||
                [view isEqual:self.mediaView]) {
                continue;
            }
            //view.frame = CGRectMake(view.frame.origin.x,
            //                        view.frame.origin.y - originChange,
            //                        view.frame.size.width,
            //                        view.frame.size.height);
        }
        
        self.loadingView.layer.opacity = 0.01;
    } completion:^(BOOL finished) {
        self.loadingView.hidden = YES;
        self.loadingView.layer.opacity = 1.0f;
        
        self.loadingView.hidden = YES;
        if(showMedia){
            
            self.loadingView.hidden = YES;
            [self showMediaView];
            
        }
        [self setHeaderView];
        //[(UITableView *)self.superview setTableHeaderView:self];
        

    }];
    
}
- (void)animationDidStop:(NSString *)animationID finished:(NSNumber *)finished context:(void *)context{
   // [(UITableView *)self.superview setTableHeaderView:self];
    [self setHeaderView];
}


-(void)setHeaderView{
   // if([self.delegate respondsToSelector:@selector(headerViewNeedsToBeSetOnSuperView:)]){
   //     [self.delegate headerViewNeedsToBeSetOnSuperView:self];
    //}
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
