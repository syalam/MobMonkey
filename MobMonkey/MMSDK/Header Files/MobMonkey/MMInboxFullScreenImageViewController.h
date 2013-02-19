//
//  MMInboxFullScreenImageViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/4/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TCImageView.h"

@interface MMInboxFullScreenImageViewController : UIViewController {
    IBOutlet UIWebView *imageWebView;
}

@property (nonatomic, retain)NSString *imageUrl;

@end
