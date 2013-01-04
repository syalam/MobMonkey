//
//  MMTextFieldCell.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTextFieldCell.h"

@implementation MMTextFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        _textField = [[UITextField alloc]initWithFrame:CGRectMake(10, 10, 250, 30)];
        
        [self.contentView addSubview:_textField];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
