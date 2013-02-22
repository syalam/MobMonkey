//
//  MMRequestMessageViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/19/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMRequestMessageViewController.h"
#import "MMRequestViewController.h"
#import "MMTableViewCell.h"

@interface MMRequestMessageViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *textFieldBackground;
@property (weak, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) NSMutableArray *savedMessages;

- (IBAction)clearText:(id)sender;

@end

@implementation MMRequestMessageViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.textFieldBackground.image = [self.textFieldBackground.image resizableImageWithCapInsets:UIEdgeInsetsMake(15, 156, 15, 156)];
    self.savedMessages = [@[@"Do they serve Coke® or Pepsi® here?", @"I want to see a picture of the wings."] mutableCopy];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    
    //If the theme options dictionary is populated, update the theme of the current view
    if (_themeOptionsDictionary) {
        if ([_themeOptionsDictionary valueForKey:@"backgroundColor"]) {
            [self.view setBackgroundColor:[_themeOptionsDictionary valueForKey:@"backgroundColor"]];
        }
        if ([_themeOptionsDictionary valueForKey:@"navigationBarTintColor"]) {
            [self.navigationController.navigationBar setTintColor:[_themeOptionsDictionary valueForKey:@"navigationBarTintColor"]];
        }
        if ([_themeOptionsDictionary valueForKey:@"navigationBarTitleImage"]) {
            UIImage *image = [_themeOptionsDictionary valueForKey:@"navigationBarTitleImage"];
            self.navigationItem.titleView = [[UIImageView alloc] initWithImage:image];
        }
    }
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    self.textView.text = [self.requestInfo valueForKey:@"message"];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.requestInfo setValue:self.textView.text forKey:@"message"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return self.savedMessages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"MessageCell";
    MMTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    cell.textLabel.adjustsFontSizeToFitWidth = YES;
    cell.textLabel.text = self.savedMessages[indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textView.text = self.savedMessages[indexPath.row];
}


- (IBAction)clearText:(id)sender
{
}


- (void)viewDidUnload {
    [self setTextFieldBackground:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}

#pragma mark - UITextView Delegate
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)aRange replacementText:(NSString *)aText {
    
    NSString* newText = [textView.text stringByReplacingCharactersInRange:aRange withString:aText];
    
    if([newText length] > 100)
    {
        return NO; // can't enter more text
    }
    else
        return YES; // let the textView know that it should handle the inserted text
}

@end
