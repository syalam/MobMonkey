//
//  MMPlaceButton.h
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomBadge.h"
@interface MMPlaceButton : UIButton {
    
}

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView * iconView;
@property (nonatomic, strong) CustomBadge *badge;

@end
