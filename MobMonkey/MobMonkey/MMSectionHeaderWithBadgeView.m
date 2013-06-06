//
//  MMSectionHeaderWithBadgeView.m
//  MobMonkey
//
//  Created by Michael Kral on 6/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMSectionHeaderWithBadgeView.h"

@implementation MMSectionHeaderWithBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithTitle:(NSString *)title andBadgeNumber:(NSNumber *)badgeNumber {
    
    CGRect screenRect = [[UIScreen mainScreen] bounds];
    
    self = [super initWithFrame:CGRectMake(0, 0, screenRect.size.width, 25)];
    
    if(self){
        _title = title;
        _badgeNumber = badgeNumber;
        
        self.backgroundColor = [UIColor colorWithRed:0.796 green:0.780 blue:0.788 alpha:1.000];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(8, 2, screenRect.size.width - 48, 20)];
        titleLabel.textColor = [UIColor darkGrayColor];
        titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
        titleLabel.text = title;
        titleLabel.backgroundColor = self.backgroundColor;
        [self addSubview:titleLabel];
        
        CustomBadge *badge = [CustomBadge customBadgeWithString:[NSString stringWithFormat:@"%@", badgeNumber.stringValue] withStringColor:[UIColor darkGrayColor] withInsetColor:[UIColor colorWithRed:0.796 green:0.780 blue:0.788 alpha:1.000] withBadgeFrame:YES withBadgeFrameColor:[UIColor lightGrayColor] withScale:1.0 withShining:NO];
        
        badge.frame = CGRectMake(screenRect.size.width - badge.frame.size.width - 7, (25 - badge.frame.size.height)/2, badge.frame.size.width, badge.frame.size.height);
        
        [self addSubview:badge];
        
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
