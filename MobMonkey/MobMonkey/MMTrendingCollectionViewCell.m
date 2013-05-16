//
//  MMTrendingCollectionViewCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingCollectionViewCell.h"

@implementation MMTrendingCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    
        [self.imageViewButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.imageViewButton.imageView setClipsToBounds:YES];
    }
    return self;
}
-(void)awakeFromNib{
    [super awakeFromNib];
    
    [self.imageViewButton.imageView setContentMode:UIViewContentModeScaleAspectFill];
    [self.imageViewButton.imageView setClipsToBounds:YES];
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
