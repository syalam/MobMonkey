//
//  MMRequestInboxCell.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxCell.h"

@implementation MMRequestInboxCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        CGRect placeViewFrame = CGRectMake(0, 0, self.contentView.bounds.size.width , self.contentView.bounds.size.height);
		_requestInboxView = [[MMRequestInboxView alloc] initWithFrame:placeViewFrame];
		_requestInboxView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:_requestInboxView];
        self.clipsToBounds = YES;
    }
    return self;
}

-(void)setRequestInboxWrapper:(MMRequestInboxWrapper *)wrapper
{
    [_requestInboxView setWrapper:wrapper];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

-(void)redisplay {
    [self.requestInboxView setNeedsDisplay];
}

@end
