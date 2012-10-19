//
//  MMRequestMessageViewController.h
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/19/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMRequestMessageViewController : UITableViewController <UITextViewDelegate>

@property (weak, nonatomic) NSMutableDictionary  *requestInfo;

@end
