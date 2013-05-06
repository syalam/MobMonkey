//
//  MMHotSpotHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHotSpotHeaderView.h"
#import <QuartzCore/QuartzCore.h>

@implementation MMHotSpotHeaderView

@synthesize createHotSpotButton = _createHotSpotButton;
@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float padding = 10.0f;
        
        UIView *opaqueView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height - 4)];
        UIView *translucentView = [[UIView alloc] initWithFrame:CGRectMake(0, opaqueView.frame.size.height, frame.size.width, 4)];
        
        
        UIImageView *seperator = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 4)];
        seperator.image = [UIImage imageNamed:@"separator-gradient"];
        seperator.layer.opacity = 0.8;
        translucentView.layer.opacity = 0.8;
        [translucentView addSubview:seperator];
        
        
        self.opaque = NO;
        _createHotSpotButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding+ 5, frame.size.width - (padding * 2), 67)];
        [_createHotSpotButton setTitle:@"Create a Hot Spot" forState:UIControlStateNormal];
        [_createHotSpotButton setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _createHotSpotButton.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"LocationButtonStretch"] stretchableImageWithLeftCapWidth:60 topCapHeight:0];
        
        [_createHotSpotButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        //_createHotSpotButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.590 blue:0.360 alpha:1.000];
        [opaqueView addSubview:_createHotSpotButton];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(padding - 5, _createHotSpotButton.frame.origin.y + _createHotSpotButton.frame.size.height  + 10, frame.size.width - ((padding - 5) * 2), 30)];
        [opaqueView addSubview:_searchBar];
        
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        //_searchBar.userInteractionEnabled = NO;
        
        [self addSubview:opaqueView];
        [self addSubview:translucentView];
        
    }
    return self;
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
