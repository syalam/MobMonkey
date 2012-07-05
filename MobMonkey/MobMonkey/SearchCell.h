//
//  SearchCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SearchCellDelegate

- (void)requestButtonClicked:(id)sender;

@end

@interface SearchCell : UITableViewCell

@property (nonatomic, retain)UIImageView *iconImageView;
@property (nonatomic, retain)UILabel *locationNameLabel;
@property (nonatomic, retain)UIImageView *videoImageView;
@property (nonatomic, retain)UILabel *timeLabel;
@property (nonatomic, retain)UIButton *requestButton;
@property (nonatomic, retain)id<SearchCellDelegate> delegate;


@end
