//
//  MMHotSpotBadge.m
//  MobMonkey
//
//  Created by Michael Kral on 5/7/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMHotSpotBadge.h"

@implementation MMHotSpotBadge

- (id)init
{
    CGRect frame = CGRectMake(0, 0, 22, 22);
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.autoresizesSubviews = YES;
        self.backgroundColor = [UIColor clearColor];
        [self setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        UIImage *backgroundImage = [[UIImage imageNamed:@"hotSpotBadgeStretch"] stretchableImageWithLeftCapWidth:15 topCapHeight:0];
        
        imageView = [[UIImageView alloc] initWithFrame:frame];
        imageView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        imageView.image = backgroundImage;
        [self addSubview:imageView];

        
        badgeNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(19, 0, 22, 22)];
        badgeNumberLabel.backgroundColor = [UIColor clearColor];
        badgeNumberLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:14];
        badgeNumberLabel.textColor = [UIColor whiteColor];
        //badgeNumberLabel.text = @"1";
        [self addSubview:badgeNumberLabel];
        
                
    }
    return self;
}
-(void)setBadgeNumber:(NSNumber *)badgeNumber {
    badgeNumberLabel.text = [NSString stringWithFormat:@"%d", badgeNumber.integerValue];
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
