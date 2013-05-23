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
        _createHotSpotButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding+ 5, frame.size.width - (padding * 2), 45)];
        [_createHotSpotButton setTitle:@"Create Hot Spot" forState:UIControlStateNormal];
        [_createHotSpotButton setFont:[UIFont fontWithName:@"Helvetica-Bold" size:20]];
        _createHotSpotButton.titleEdgeInsets = UIEdgeInsetsMake(0, 45, 0, 0);
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"orange_buttonStretch"] stretchableImageWithLeftCapWidth:60 topCapHeight:0];
        
        [_createHotSpotButton setBackgroundImage:backgroundImage forState:UIControlStateNormal];
        
        //_createHotSpotButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.590 blue:0.360 alpha:1.000];
        [self addSubview:_createHotSpotButton];
        
       
        //_searchBar.userInteractionEnabled = NO;
        
       // [self addSubview:opaqueView];
        [self addSubview:translucentView];
        
        _locationButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"tags"] landscapeImagePhone:nil style:UIBarButtonItemStyleBordered target:self action:@selector(locationButtonPressed:)];
        
        UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
        
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0,0, frame.size.width - 65, 30)];
        
        UIBarButtonItem *searchItem = [[UIBarButtonItem alloc] initWithCustomView:_searchBar];
        //[self addSubview:_searchBar];
        
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        
        _toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, _createHotSpotButton.frame.origin.y + _createHotSpotButton.frame.size.height  + 10, 320, 44)];
        [self addSubview:_toolbar];
        
        
        _locationButton.tintColor = [UIColor colorWithRed:0.508 green:0.478 blue:0.480 alpha:1.000];
        
        _toolbar.items = @[_locationButton, searchItem];
        [_toolbar setBackgroundImage:[[UIImage alloc] init] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];

        
        
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
