//
//  LocationMediaCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/2/12.
//
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@protocol LocationMediaCellDelegate
- (void)thumbsUpButtonTapped:(id)sender;
- (void)thumbsDownButtonTapped:(id)sender;

@end

@interface LocationMediaCell : UITableViewCell <UIWebViewDelegate>

@property (nonatomic, retain) UIImageView *cellBackgroundImageView;
@property (nonatomic,retain)UILabel* timeLabel;
@property (nonatomic, retain) TCImageView *cellImageView;
@property (nonatomic, retain) UIButton *thumbsUpButton;
@property (nonatomic, retain) UIButton *thumbsDownButton;
@property (nonatomic, assign) id<LocationMediaCellDelegate> delegate;

@end
