//
//  MMHotSpotHeaderView.m
//  MobMonkey
//
//  Created by Michael Kral on 4/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHotSpotHeaderView.h"

@implementation MMHotSpotHeaderView

@synthesize createHotSpotButton = _createHotSpotButton;
@synthesize searchBar = _searchBar;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        float padding = 10.0f;
        
        _createHotSpotButton = [[UIButton alloc] initWithFrame:CGRectMake(padding, padding+ 5, frame.size.width - (padding * 2), 50)];
        _createHotSpotButton.backgroundColor = [UIColor colorWithRed:1.000 green:0.590 blue:0.360 alpha:1.000];
        [self addSubview:_createHotSpotButton];
        
        _searchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(padding - 5, _createHotSpotButton.frame.origin.y + _createHotSpotButton.frame.size.height + 20, frame.size.width - ((padding - 5) * 2), 30)];
        [self addSubview:_searchBar];
        
        [[_searchBar.subviews objectAtIndex:0] removeFromSuperview];
        [_searchBar setBackgroundColor:[UIColor clearColor]];
        
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
