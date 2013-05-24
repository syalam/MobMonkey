//
//  MMPlaceButton.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMPlaceButton.h"

@implementation MMPlaceButton

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
        _badge = [CustomBadge customBadgeWithString:nil withStringColor:[UIColor MMEggShell] withInsetColor:[UIColor darkGrayColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor lightGrayColor] withScale:1.0 withShining:NO];
        
        [self addSubview:_badge];
        
        _textLabel = [[UILabel alloc] init];
        _textLabel.textColor = [UIColor darkGrayColor];
        _textLabel.textAlignment = NSTextAlignmentLeft;
        _textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
        _textLabel.shadowColor = [UIColor whiteColor];
        _textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
        _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        
        [self addSubview:_textLabel];
        
        _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, (self.frame.size.height - 6), (self.frame.size.height - 6))];
        _iconView.contentMode = UIViewContentModeScaleAspectFit;
        
        [self addSubview:_iconView];
        
        self.backgroundColor = [UIColor MMLightGreen];
        
    }
    return self;
}
-(void)awakeFromNib {
    [super awakeFromNib];
    
    self.layer.cornerRadius = 7;
    self.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.layer.borderWidth = 0.8f;
    self.layer.shadowColor = [UIColor blackColor].CGColor;
    self.layer.shadowOffset = CGSizeMake(1.0, 1.0);
    self.layer.shadowPath = CGPathCreateWithRect(self.frame, nil);
    
    _badge = [CustomBadge customBadgeWithString:nil withStringColor:[UIColor MMEggShell] withInsetColor:[UIColor darkGrayColor] withBadgeFrame:YES withBadgeFrameColor:[UIColor lightGrayColor] withScale:1.0 withShining:NO];
    
    [self addSubview:_badge];
    
    _textLabel = [[UILabel alloc] init];
    _textLabel.textColor = [UIColor darkGrayColor];
    _textLabel.textAlignment = NSTextAlignmentLeft;
    _textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16.0f];
    _textLabel.shadowColor = [UIColor whiteColor];
    _textLabel.shadowOffset = CGSizeMake(0.0, 1.0);
    _textLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    _textLabel.backgroundColor = [UIColor MMLightGreen];
    
    [self addSubview:_textLabel];
    
    _iconView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 3, (self.frame.size.height - 6), (self.frame.size.height - 6))];
    _iconView.contentMode = UIViewContentModeScaleAspectFit;
    
    [self addSubview:_iconView];
    
    self.backgroundColor = [UIColor MMLightGreen];
}
-(void)layoutSubviews {
    [super layoutSubviews];
    
    //Badge View
    _badge.frame = CGRectMake(self.frame.size.width - _badge.frame.size.width - 20, (self.frame.size.height - _badge.frame.size.height)/2, _badge.frame.size.width, _badge.frame.size.height);
    
    //Icon View
    _iconView.frame = CGRectMake(_badge.frame.origin.x - _iconView.frame.size.width - 20, _iconView.frame.origin.y, _iconView.frame.size.width, _iconView.frame.size.height);
    
    //Label
    
    _textLabel.frame = CGRectMake(20, (self.frame.size.height - 20.0f)/2, self.frame.size.width - (40 + (self.frame.size.width - _iconView.frame.origin.x)), 20.0f);
    
    
    
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
