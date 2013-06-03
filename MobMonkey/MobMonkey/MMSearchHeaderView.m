//
//  MMSearchHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSearchHeaderView.h"

@interface MMSearchHeaderView()

@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIView *selectedBackgroundView;
@property (nonatomic, strong) UITapGestureRecognizer * tapGestureRecognizer;
@property (assign) id target;
@property (assign) SEL selector;

@end

@implementation MMSearchHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds = YES;
        
        UIImage * backgroundImage = [[UIImage imageNamed:@"cellBackgroundView"] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        UIImage * selectedBackgroundImage = [[UIImage imageNamed:@"acceptBtn"
                                              ] stretchableImageWithLeftCapWidth:0 topCapHeight:0];
        
        self.backgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        ((UIImageView *)self.backgroundView).image = backgroundImage;
        
        self.selectedBackgroundView = [[UIImageView alloc] initWithFrame:self.bounds];
        ((UIImageView *)self.selectedBackgroundView).image = selectedBackgroundImage;
        
        self.selectedBackgroundView.hidden = YES;
        
        //[self addSubview:self.backgroundView];
        //[self addSubview:self.selectedBackgroundView];
        
        
        //Add 'Near' label
        UILabel *nearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 16)/2, 45, 16)];
        nearLabel.text = @"near: ";
        nearLabel.font = [UIFont fontWithName:@"Helvetica-LightOblique" size:16];
        nearLabel.backgroundColor = [UIColor clearColor];
        nearLabel.textColor = [UIColor grayColor];
        
        
        [self addSubview:nearLabel];
        
        //Add Disclosure Indicator ImageView
        UIImageView *disclosureIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 23, (self.frame.size.height - 16)/2, 16, 16)];
        [disclosureIndicatorView setImage:[UIImage imageNamed:@"arrowRight"]];
        
        [self addSubview:disclosureIndicatorView];
        
        CGRect locationLabelFrame = CGRectZero;
        locationLabelFrame.origin.x = nearLabel.frame.origin.x + nearLabel.frame.size.width + 5;
        locationLabelFrame.size.width = self.frame.size.width - locationLabelFrame.origin.x - 25;
        locationLabelFrame.size.height = 18;
        locationLabelFrame.origin.y = (self.frame.size.height - locationLabelFrame.size.height)/2;
        
        _locationLabel = [[UILabel alloc] initWithFrame:locationLabelFrame];
        _locationLabel.font = [UIFont fontWithName:@"Helvetica-Light" size:16];
        _locationLabel.text = @"Current Location";
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_locationLabel];
        
        
        _tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(viewWasTapped:)];
        [self addGestureRecognizer:_tapGestureRecognizer];
        
        
    }
    return self;
}
-(void)viewWasTapped:(id)sender{
    
    self.selectedBackgroundView.hidden = NO;
        
}
-(void)addTarget:(id)target andSelector:(SEL)selector {
    self.target = target;
    self.selector = selector;
}
-(void)setBackgroundView:(UIView *)backgroundView {
   
    
    if(self.backgroundView){
        [self.backgroundView removeFromSuperview];
    }
    
    //Make sure origin is 0,0
    backgroundView.frame = backgroundView.bounds;
    
    [self insertSubview:backgroundView belowSubview:self.selectedBackgroundView];
    
    _backgroundView = backgroundView;

}

-(void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    
    if(self.selectedBackgroundView){
        [self.selectedBackgroundView removeFromSuperview];
    }
    
    //Make sure origin is 0,0
    selectedBackgroundView.frame = selectedBackgroundView.bounds;
    
    [self insertSubview:selectedBackgroundView aboveSubview:self.backgroundView];
    
    selectedBackgroundView = selectedBackgroundView;
    
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
