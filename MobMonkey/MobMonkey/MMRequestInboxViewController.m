//
//  MMRequestInboxViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMRequestInboxViewController.h"
#import "MMRequestInboxCell.h"
#import "MMRequestWrapper.h"
#import "MMShadowCellBackground.h"
#import "MMSectionHeaderWithBadgeView.h"
#import "MMRequestObject.h"
@interface MMRequestInboxViewController ()
@property (nonatomic, strong) MMMediaRequestWrapper *wrapper;
@end

@implementation MMRequestInboxViewController

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
    
    
    self.tableView.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    _wrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    _wrapper.durationSincePost = @"8 mins ago";
    _wrapper.nameOfLocation = @"Maya Pool";
    _wrapper.nameOfParentLocation = @"@ Maya Day and Night Club";
    _wrapper.questionText = @"I have an image!!";
    _wrapper.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    _wrapper.cellStyle = MMRequestCellStyleInbox;
    
    NSMutableArray * tempCellWrapper = [NSMutableArray array];
    
    [tempCellWrapper addObject:_wrapper];
    
    
    MMMediaRequestWrapper * wrapperNotAnswered = [[MMMediaRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    wrapperNotAnswered.durationSincePost = @"8 mins ago";
    wrapperNotAnswered.nameOfLocation = @"Maya Pool";
    wrapperNotAnswered.nameOfParentLocation = @"@ Maya Day and Night Club";
    wrapperNotAnswered.questionText = @"Lorem ipsum dolor sit amet, consectetur adipiscing elit. I dont have an image";
    wrapperNotAnswered.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    wrapperNotAnswered.cellStyle = MMRequestCellStyleTimeline;
    
    
    MMTextRequestWrapper * textWrapper = [[MMTextRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    textWrapper = [[MMTextRequestWrapper alloc] initWithTableWidth:self.tableView.frame.size.width];
    textWrapper.durationSincePost = @"8 mins ago";
    textWrapper.nameOfLocation = @"Maya Pool";
    textWrapper.nameOfParentLocation = @"@ Maya Day and Night Club";
    textWrapper.questionText = @"I have a text request, but no answer yet";
    //textWrapper.placeholderImage = [UIImage imageNamed:@"poolParty.jpg"];
    textWrapper.cellStyle = MMRequestCellStyleTimeline;
    textWrapper.answerText = @"This is a new answer!";
    
    [tempCellWrapper addObject:wrapperNotAnswered];
    [tempCellWrapper addObject:textWrapper];
    
    self.cellWrappers = tempCellWrapper;
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}
-(void)viewDidAppear:(BOOL)animated {
    [self loadRequests];
}

-(NSArray *)wrappersForRequests:(NSArray *)requests type:(MMRequestType)requestType{
    
    NSMutableArray * arrayOfWrappers = [NSMutableArray arrayWithCapacity:requests.count];
    
    switch (requestType) {
        case MMRequestTypeAssigned:
            for(MMRequestObject *requestObject in requests) {
                
                MMRequestWrapper * assingedRequest = [[MMRequestWrapper alloc] initWithTableWidth:320];
                assingedRequest.nameOfLocation = requestObject.nameOfLocation;
                assingedRequest.mediaType = requestObject.mediaType;
                assingedRequest.durationSincePost = [requestObject dateStringDurationSinceCreate];
                assingedRequest.nameOfParentLocation = @"Not Implemented Yet";
                assingedRequest.isAnswered = NO;
                assingedRequest.questionText = ![requestObject.message isEqual:[NSNull null]] ? requestObject.message : @" No Text";
                assingedRequest.cellStyle = MMRequestCellStyleInbox;
                [arrayOfWrappers addObject:assingedRequest];

            }

            break;
            
        default:
            break;
    }
    
        
    return arrayOfWrappers;
    
    
}
-(void)loadRequests {
    
    [MMAPI getAssignedRequestObjectsWithSuccess:^(NSArray *requestObjects) {
        self.assignedRequests = requestObjects;
        self.assingedRequestWrappers = [self wrappersForRequests:requestObjects type:MMRequestTypeAssigned];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        NSLog(@"ERROR: %@", error);
    }];
    
    
    [MMAPI getFulfilledRequests:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"DATA: %@", responseObject);
        NSLog(@"");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
    }];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
#warning Potentially incomplete method implementation.
    // Return the number of sections.
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    
    //Assigned Request
    if(section == 0){
        return self.assignedRequests.count;
    }
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMRequestInboxCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if(cell == nil){
        cell = [[MMRequestInboxCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle  = UITableViewCellSelectionStyleNone;
        
    }
    
    UIView *test = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 300)];
    test.backgroundColor = [UIColor redColor];
    
    NSUInteger toggle = indexPath.row % 3;
    MMRequestWrapper *wrapper = [self.cellWrappers objectAtIndex:toggle];
    
    if(indexPath.section == 0){
        [cell setRequestInboxWrapper:[self.assingedRequestWrappers objectAtIndex:indexPath.row]];
    }else{
        [cell setRequestInboxWrapper:wrapper];  
    }
    
      
    //[cell redisplay];
    // Configure the cell...
    
    return cell;
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 3;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 27;
}
-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    NSString *title = nil;
    NSNumber *number = nil;
    
    switch (section) {
        case 0:
            title = @"Assigned Requests";
            number = [NSNumber numberWithInt:self.assignedRequests.count];
            break;
        case 1:
            title = @"Answered Requests";
            number = [NSNumber numberWithInt:self.answeredRequests.count];
            break;
        case 2:
            title = @"Notifications";
            number = [NSNumber numberWithInt:self.notifications.count];
            break;
        case 3:
            title = @"Open Requests";
            number = [NSNumber numberWithInt:self.openRequests.count];
            break;
            
        default:
            break;
    }
    
    return [[MMSectionHeaderWithBadgeView alloc] initWithTitle:title andBadgeNumber:number];
}
-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    return [UIView new];
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.section == 0){
        MMRequestWrapper *wrapper = [self.assingedRequestWrappers objectAtIndex:indexPath.row];
        return [wrapper cellHeight];
    }
    
    NSUInteger toggle = indexPath.row % 3;
    MMRequestWrapper *wrapper = [self.cellWrappers objectAtIndex:toggle];
    return [wrapper cellHeight];
}
-(void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    cell.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    
    for(UIView *view in cell.subviews){
        view.backgroundColor = [UIColor colorWithRed:0.930 green:0.911 blue:0.920 alpha:1.000];
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     */
}

@end
