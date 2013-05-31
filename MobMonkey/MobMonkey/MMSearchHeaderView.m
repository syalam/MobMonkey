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

@end

@implementation MMSearchHeaderView


- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        self.clipsToBounds = YES;
        
        self.backgroundColor = [UIColor MMPaleGreen];
        
        
        //Add 'Near' label
        UILabel *nearLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, (self.frame.size.height - 16)/2, 45, 16)];
        nearLabel.text = @"Near: ";
        nearLabel.font = [UIFont fontWithName:@"Helvetica-Oblique" size:16];
        nearLabel.backgroundColor = [UIColor clearColor];
        nearLabel.textColor = [UIColor blackColor];
        nearLabel.shadowColor = [UIColor grayColor];
        nearLabel.shadowOffset = CGSizeMake(1, 0);
        
        [self addSubview:nearLabel];
        
        //Add Disclosure Indicator ImageView
        UIImageView *disclosureIndicatorView = [[UIImageView alloc] initWithFrame:CGRectMake(self.frame.size.width - 20, (self.frame.size.height - 16)/2, 16, 16)];
        [disclosureIndicatorView setImage:[UIImage imageNamed:@"arrowRight"]];
        
        [self addSubview:disclosureIndicatorView];
        
        CGRect locationLabelFrame = CGRectZero;
        locationLabelFrame.origin.x = nearLabel.frame.origin.x + nearLabel.frame.size.width + 5;
        locationLabelFrame.size.width = self.frame.size.width - locationLabelFrame.origin.x - 25;
        locationLabelFrame.size.height = 18;
        locationLabelFrame.origin.y = (self.frame.size.height - locationLabelFrame.size.height)/2;
        
        _locationLabel = [[UILabel alloc] initWithFrame:locationLabelFrame];
        _locationLabel.text = @"Tempe, AZ, USA";
        _locationLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:_locationLabel];
        
        
        
        
    }
    return self;
}

-(void)setBackgroundView:(UIView *)backgroundView {
   
    if(self.backgroundView){
        [self.backgroundView removeFromSuperview];
    }
    
    //Make sure origin is 0,0
    backgroundView.frame = backgroundView.bounds;
    
    [self addSubview:backgroundView];
    
    _backgroundView = backgroundView;

}

-(void)setSelectedBackgroundView:(UIView *)selectedBackgroundView {
    
    if(self.selectedBackgroundView){
        [self.selectedBackgroundView removeFromSuperview];
    }
    
    //Make sure origin is 0,0
    selectedBackgroundView.frame = selectedBackgroundView.bounds;
    
    [self addSubview:selectedBackgroundView];
    
    selectedBackgroundView = selectedBackgroundView;
    
}

//Method to add target and selector when pressed
-(void)addTarget:(id)target andSelector:(SEL)selector {
    
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
