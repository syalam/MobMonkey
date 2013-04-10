//
//  MMMapView.m
//  MobMonkey
//
//  Created by Michael Kral on 4/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMapView.h"

@interface MMMapView ()

@property(nonatomic, strong) UIGestureRecognizer *tapGestureRecognizer;
@property (nonatomic, assign) BOOL selectingLocation;

@end

@implementation MMMapView

@synthesize tapGestureRecognizer = _tapGestureRecognizer;
@synthesize delegate = _delegate;
@synthesize selectingLocation = _selectingLocation;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
        
    }
    return self;
}

-(void)setupGestureRecognizers{
    
    if(_tapGestureRecognizer){
        [self addGestureRecognizer:_tapGestureRecognizer];
    }
    
}
-(void)cleanupGestureRecognizers{
    
    if(_tapGestureRecognizer){
        [self removeGestureRecognizer:_tapGestureRecognizer];
    }
    
}
-(void)startSelectingLocation{
    self.selectingLocation = YES;
    
}
-(void)stopSelectingLocation{
    self.selectingLocation = NO;
}

-(void)handleTap:(UIGestureRecognizer*)gestureRecognizer{
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self];
    CLLocationCoordinate2D touchMapCoordinate = [self convertPoint:touchPoint toCoordinateFromView:self];
    
    if([self.delegate respondsToSelector:@selector(mapview:didSelectLocation:)]){
        [self.delegate mapview:self didSelectLocation:touchMapCoordinate];
    }
    
    
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
