//
//  MMInboxDetailViewController.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 11/15/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MobileCoreServices/UTCoreTypes.h>

@protocol InboxDetailDelegate

@optional
- (void)updateInboxCount;

@end

@interface MMInboxDetailViewController : UITableViewController <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIActionSheetDelegate> {
    NSString *requestId;
    int selectedIndexToClear;
}

@property(nonatomic, retain)NSArray *contentList;
@property(nonatomic, retain)NSString *inboxCategory;
@property (nonatomic, weak)NSDictionary* themeOptionsDictionary;
@property(nonatomic, assign)id<InboxDetailDelegate>delegate;

@end
