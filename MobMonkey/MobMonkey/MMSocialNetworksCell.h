//
//  MMSocialNetworksCell.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 9/11/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MMSocialNetworksCellDelegate

- (void)mmSocialNetworksSwitchTapped:(id)sender;

@end

@interface MMSocialNetworksCell : UITableViewCell

@property (nonatomic, retain) UISwitch *mmSocialNetworkSwitch;
@property (nonatomic, retain) UILabel *mmSocialNetworkTextLabel;
@property (nonatomic, retain) id<MMSocialNetworksCellDelegate> delegate;

@end
