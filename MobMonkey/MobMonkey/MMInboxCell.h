//
//  MMInboxCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMInboxCell : UITableViewCell

@property (nonatomic, retain)UIImageView *backgroundImageView;
@property (nonatomic, retain)UILabel *locationNameLabel;
@property (nonatomic, retain)UILabel *requestTypeLabel;
@property (nonatomic, retain)UILabel *messageLabel;
@property (nonatomic, retain)UILabel *timestampLabel;

@end
