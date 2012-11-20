//
//  MMLocationMediaViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/5/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MMLocationMediaCell.h"


typedef enum {
    MMLiveCameraMediaType,
    MMVideoMediaType,
    MMPhotoMediaType
} MobMonkeyMediaType;

@interface MMLocationMediaViewController : UIViewController <UITabBarControllerDelegate, UITableViewDataSource> {
    
}

@property (nonatomic, strong) NSDictionary *location;
@property (assign, nonatomic) MobMonkeyMediaType mediaType;

@end
