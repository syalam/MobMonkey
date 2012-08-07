//
//  HomeCell.h
//  MobMonkey
//
//  Created by Sheehan Alam on 6/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeCell : UITableViewCell
@property(nonatomic, retain)UIImageView *cellBackgroundImage;
@property(nonatomic,retain)UILabel* locationNameLabel;
@property(nonatomic,retain)UILabel* timeLabel;
@property(nonatomic,retain)UIImageView* thumbnailImageView;

@end
