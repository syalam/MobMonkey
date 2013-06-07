//
//  MMFixedHeaderViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/31/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>



@interface MMFixedHeaderViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) UIView *fixedTableHeaderView;
@property (nonatomic, assign, readonly) CGSize keyboardSize;

-(void)keyboardWasShown:(id)sender;
-(void)keyboardWillHide:(id)sender;

@end
