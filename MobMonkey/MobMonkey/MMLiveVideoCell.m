//
//  MMLiveVideoCell.m
//  MobMonkey
//
//  Created by Michael Kral on 6/11/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLiveVideoCell.h"
#import "MMLiveVideoView.h"
#import "MMShadowBackground.h"

@interface MMLiveVideoCell()

@property(nonatomic, strong) MMShadowBackground *shadowBackground;

@end

@implementation MMLiveVideoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        
        CGRect placeViewFrame = CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height);
        
        _shadowBackground = [[MMShadowBackground alloc]  initWithFrame:placeViewFrame];
        
        _shadowBackground.autoresizingMask =  UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
        
        [self.contentView addSubview:_shadowBackground];

        
		_liveVideoView = [[MMLiveVideoView alloc] initWithFrame:placeViewFrame];
		_liveVideoView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
        _liveVideoView.delegate = self;
		[self.contentView addSubview:_liveVideoView];
        self.clipsToBounds = YES;
        
            }
    return self;
}

-(void)setLiveVideoWrapper:(MMLiveVideoWrapper *)newLiveVideoWrapper {
    [self.liveVideoView setCellWrapper:newLiveVideoWrapper];
    [_shadowBackground setNeedsDisplay];
}

-(void)redisplay {
    [self.liveVideoView setNeedsDisplay];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma  mark -LiveVideDelegate
-(void)liveVideoView:(MMLiveVideoView *)view messageURLClick:(NSURL *)meduaURL {
    if([self.delegate respondsToSelector:@selector(liveVideoCell:openMessageURL:)]){
        [self.delegate liveVideoCell:self openMessageURL:meduaURL];
    }
}
@end
