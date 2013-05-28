//
//  MMPlaceInformationCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceInformationCell.h"
#import "MMShadowCellBackground.h"

@implementation MMPlaceInformationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    
	if (self = [super initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier]) {
		
		// Create a time zone view and add it as a subview of self's contentView.
		CGRect placeViewFrame = CGRectMake(8.5, 7.0, self.contentView.bounds.size.width- 17, self.contentView.bounds.size.height - 6);
		placeInformationView = [[MMPlaceInformationCellView alloc] initWithFrame:placeViewFrame];
		placeInformationView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:placeInformationView];
        self.clipsToBounds = YES;
        
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
