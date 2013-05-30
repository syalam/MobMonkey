//
//  MMSectionHeaderCell.m
//  MobMonkey
//
//  Created by Michael Kral on 5/29/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSectionHeaderCell.h"
#import "MMShadowCellBackground.h"
@implementation MMSectionHeaderCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        // Create a time zone view and add it as a subview of self's contentView.
		CGRect placeViewFrame = CGRectMake(8.5, 3.0, self.contentView.bounds.size.width- 17, self.contentView.bounds.size.height - 8);
		placeSectionHeaderView = [[MMPlaceSectionHeaderView alloc] initWithFrame:placeViewFrame];
		placeSectionHeaderView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
		[self.contentView addSubview:placeSectionHeaderView];
        self.clipsToBounds = YES;
    }
    return self;
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
    
    placeSectionHeaderView.highlighted = selected;
    ((MMShadowCellBackground *)self.backgroundView).isSelected = YES;
}
- (void)setPlaceSectionHeaderWrapper:(MMPlaceSectionHeaderWrapper *)newPlaceSectionHeaderWrapper {
    // Pass the time zone wrapper to the view
	placeSectionHeaderView.cellWrapper = newPlaceSectionHeaderWrapper;
}


- (void)redisplay {
	[placeSectionHeaderView setNeedsDisplay];
}

@end
