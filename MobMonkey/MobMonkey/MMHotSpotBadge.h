//
//  MMHotSpotBadge.h
//  MobMonkey
//
//  Created by Michael Kral on 5/7/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMHotSpotBadge : UIView {
    UILabel *badgeNumberLabel;
    UIImageView *imageView;
}

@property (nonatomic, strong) NSNumber *badgeNumber;

+(MMHotSpotBadge *)badgeWithNumber:(NSNumber*)badgeNumber;

@end
