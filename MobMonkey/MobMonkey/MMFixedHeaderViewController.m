//
//  MMFixedHeaderViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/31/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMFixedHeaderViewController.h"

@interface MMFixedHeaderViewController ()

@end

@implementation MMFixedHeaderViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    _tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWasShown:)
                                                 name:UIKeyboardDidShowNotification
                                               object:nil];
    //For Later Use
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
}

-(void)keyboardWasShown:(id)sender{
    _keyboardSize = [[[sender userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
}
-(void)keyboardWillHide:(id)sender{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setFixedTableHeaderView:(UIView *)fixedTableHeaderView {
    
    if(self.fixedTableHeaderView){
        [self.fixedTableHeaderView removeFromSuperview];
    }
    
    fixedTableHeaderView.frame = fixedTableHeaderView.bounds;
    
    [self.view addSubview:fixedTableHeaderView];
    _fixedTableHeaderView = fixedTableHeaderView;
    
    CGRect tableViewFrame = self.tableView.frame;
    tableViewFrame.size.height -= fixedTableHeaderView.frame.size.height;
    tableViewFrame.origin.y = self.view.frame.size.height - tableViewFrame.size.height;
    
    self.tableView.frame = tableViewFrame;
    
}

@end
