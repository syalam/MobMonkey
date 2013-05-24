//
//  MMPlaceInformationCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceInformationCell.h"

@implementation MMPlaceInformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect placeViewFrame = CGRectMake(6.0, 0.0, self.contentView.bounds.size.width- 12, self.contentView.bounds.size.height);
		placeInformationView = [[MMPlaceInformationCellView alloc] initWithFrame:placeViewFrame];
		placeInformationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:placeInformationView];
	}
	return self;
}

- (void)setPlaceInformationWrapper:(MMPlaceInformationCellWrapper *)newPlaceInformationWrapper {
	// Pass the time zone wrapper to the view
	placeInformationView.cellWrapper = newPlaceInformationWrapper;
}


- (void)redisplay {
	[placeInformationView setNeedsDisplay];
}


@end
