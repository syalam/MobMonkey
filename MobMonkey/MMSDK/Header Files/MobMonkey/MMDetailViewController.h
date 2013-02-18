//
//  MMDetailViewController.h
//  MobMonkeySDKTest
//
//  Created by Reyaad Sidique on 2/17/13.
//  Copyright (c) 2013 MobMonkey. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMDetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;

@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@end
