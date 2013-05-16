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
    self.savedMessages = [@[@"How many people are there?", @"What is there to do there?"] mutableCopy];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithTitle:@"Done" style:UIBarButtonItemStyleBordered target:self action:@selector(doneButtonPressed:)];
    
    self.navigationItem.leftBarButtonItem = backButton;
    self.navigationItem.rightBarButtonItem = doneButton;
}
-(void)doneButtonPressed:(id)sender{
    
    [self.requestInfo setValue:self.textView.text forKey:@"message"];
    [self.navigationController popViewControllerAnimated:YES];

}
- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
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

-(void)insertTextAtCursor:(NSString*)text {
    NSRange range = self.textView.selectedRange;
    NSString * firstHalfString = [self.textView.text substringToIndex:range.location];
    NSString * secondHalfString = [self.textView.text substringFromIndex: range.location];
    self.textView.scrollEnabled = NO;  // turn off scrolling
    self.textView.text = [NSString stringWithFormat: @"%@%@%@",
                       firstHalfString,
                       text,
                       secondHalfString];
    
    range.location += [text length];
    self.textView.selectedRange = range;
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UITableViewRowAnimationTop animated:YES];
    self.textView.scrollEnabled = YES;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    self.textView.text = [self.savedMessages objectAtIndex:indexPath.row];
    //[self insertTextAtCursor: [self.savedMessages objectAtIndex:indexPath.row]];
}

- (void)viewDidUnload {
    [self setTextFieldBackground:nil];
    [self setTextView:nil];
    [super viewDidUnload];
}


@end
