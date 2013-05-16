//
//  MMTrendingCollectionViewCell.h
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMTrendingCollectionViewCell : UICollectionViewCell {

}

@property(nonatomic, strong) IBOutlet UIButton *playButton;
@property(nonatomic, strong) IBOutlet UIButton *imageViewButton;
@property(nonatomic, strong) IBOutlet UILabel *textLabel;

@end
