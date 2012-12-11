//
//  MMInboxViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/31/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>
#import "MMAPI.h"

@interface MMInboxViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, MMAPIDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSDictionary *inboxCountDictionary;
}

@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, weak) IBOutlet UIImageView *screenBackground;
@property (nonatomic) BOOL categorySelected;
@property (nonatomic) NSInteger currentAPICall;

@end
