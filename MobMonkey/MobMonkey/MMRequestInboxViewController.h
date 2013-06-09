//
//  MMRequestInboxViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    MMRequestTypeAssigned = 1,
    MMRequestTypeAnswered,
    MMRequestTypeNotifications,
    MMRequestTypeOpen
} MMRequestType;

#import <UIKit/UIKit.h>

@interface MMRequestInboxViewController : UITableViewController

@property (nonatomic, strong) NSArray * cellWrappers;

@property (nonatomic, strong) NSArray * assignedRequests;
@property (nonatomic, strong) NSArray * answeredRequests;
@property (nonatomic, strong) NSArray * notifications;
@property (nonatomic, strong) NSArray * openRequests;

@property (nonatomic, strong) NSArray * assingedRequestWrappers;
@property (nonatomic, strong) NSArray * answeredRequestWrappers;
@property (nonatomic, strong) NSArray * notificationWrappers;
@property (nonatomic, strong) NSArray * openRequestWrappers;


@end
