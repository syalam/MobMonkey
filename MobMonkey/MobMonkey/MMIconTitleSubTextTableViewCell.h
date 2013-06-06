//
//  MMIconTitleSubTextTableViewCell.h
//  MobMonkey
//
//  Created by Michael Kral on 6/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMIconTitleSubTextTableViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIImageView * iconView;
@property (nonatomic, strong) IBOutlet UILabel * titleLabel;
@property (nonatomic, strong) IBOutlet UITextView * textView;
@property (nonatomic, strong) IBOutlet UILabel * accessoryLabel;

@end
