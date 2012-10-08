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
    NSString *selectedRequestId;
    
    NSArray *openRequestsArray;
    NSArray *fulfilledRequestsArray;
    NSArray *assignedRequestsArray;
    
}

@property (nonatomic, retain)UIImageView *mmTitleImageView;
@property (nonatomic, retain)IBOutlet UITableView *tableView;
@property (nonatomic, retain)IBOutlet UIImageView *screenBackground;
@property (nonatomic, retain)NSMutableArray *contentList;
@property (nonatomic)BOOL categorySelected;
@property (nonatomic)int currentAPICall;

@end
