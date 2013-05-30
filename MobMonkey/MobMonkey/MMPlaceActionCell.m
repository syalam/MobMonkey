//
//  MMPlaceActionCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/24/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceActionCell.h"
#import "MMShadowCellBackground.h"

@implementation MMPlaceActionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // Create a time zone view and add it as a subview of self's contentView.
		CGRect placeViewFrame = CGRectMake(8.5, 3.0, self.contentView.bounds.size.width- 17, self.contentView.bounds.size.height - 7);
		placeActionView = [[MMPlaceActionView alloc] initWithFrame:placeViewFrame];
		placeActionView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:placeActionView];
        self.clipsToBounds = YES;

    }
    return self;
}

- (void)setSelected:(BOOL)_selected animated:(BOOL)animated
{
    [super setSelected:_selected animated:animated];
    
    // Configure the view for the selected state
    
    if(_selected){
        [placeActionView buttonPressed];
    }
    
    //[super setSelected:NO animated:animated];
}

- (void)setPlaceActionWrapper:(MMPlaceActionWrapper *)newPlaceActionWrapper {
	// Pass the time zone wrapper to the view
	placeActionView.cellWrapper = newPlaceActionWrapper;
}


- (void)redisplay {
	[placeActionView setNeedsDisplay];
}


@end
