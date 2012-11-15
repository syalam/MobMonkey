//
//  MMInboxDetailViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 11/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@interface MMInboxDetailViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate> {
    NSString *requestId;
}

@property(nonatomic, retain)NSArray *contentList;
@property(nonatomic, retain)NSString *inboxCategory;

@end
