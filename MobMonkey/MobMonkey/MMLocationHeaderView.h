//
//  MMLocationHeaderView.h
//  MobMonkey
//
//  Created by Michael Kral on 5/6/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationMediaView.h"

@interface MMLocationHeaderView : UIView {
    
    BOOL hasMedia;
    
}

@property (nonatomic, strong) UILabel * locationTitleLabel;
@property (nonatomic, strong) UIButton * makeARequestButton;
@property (nonatomic, strong) UILabel *makeARequestLabel;
@property (nonatomic, strong) UILabel *makeARequestSubLabel;
@property (nonatomic, strong) MMLocationMediaView *mediaView;



@end
