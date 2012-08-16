//
//  LocationMediaViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/27/12.
//
//

#import "LocationMediaViewController.h"
#import "ImageDetailViewController.h"
#import <MediaPlayer/MediaPlayer.h>
#import "TCImageView.h"
#import "GetRelativeTime.h"


@interface LocationMediaViewController ()

@end

@implementation LocationMediaViewController


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
    
    //set background color
    [self.view setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Background~iphone"]]];
    
    UIImageView *titleImageView = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 127/2, 9.5, 127, 25)];
    titleImageView.image = [UIImage imageNamed:@"logo~iphone"];
    titleImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.navigationItem.titleView = titleImageView;
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneButton;
    
    voteTrackerDictionary = [[NSMutableDictionary alloc]initWithCapacity:1];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    LocationMediaCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    cell = [[LocationMediaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    cell.delegate = self;
    
    PFObject *locationMediaObject = [_contentList objectAtIndex:indexPath.row];
    PFFile *mediaFile = [locationMediaObject objectForKey:@"image"];
    
    cell.timeLabel.text = [[GetRelativeTime alloc]getRelativeTime:locationMediaObject.createdAt];
    
    if ([mediaFile.url rangeOfString:@".mov"].location != NSNotFound) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:mediaFile.url] options:nil];
        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generate.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(0, 60);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        cell.cellImageView.image = [[UIImage alloc] initWithCGImage:imgRef];
    }
    else {
        [cell.cellImageView reloadWithUrl:mediaFile.url];
    }
    
    cell.thumbsDownButton.tag = indexPath.row;
    cell.thumbsUpButton.tag = indexPath.row;
    
    
    if ([[voteTrackerDictionary objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] isEqualToString:@"up"]) {
        cell.thumbsUpButton.enabled = NO;
        cell.thumbsDownButton.enabled = YES;
    }
    else if ([[voteTrackerDictionary objectForKey:[NSString stringWithFormat:@"%d", indexPath.row]] isEqualToString:@"down"]) {
        cell.thumbsDownButton.enabled = NO;
        cell.thumbsUpButton.enabled = YES;
    }
    else {
        [self checkVoteStatusForUser:locationMediaObject thumbsUpButton:cell.thumbsUpButton thumbsDownButton:cell.thumbsDownButton];
    }
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 200;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    PFObject *locationMediaObject = [_contentList objectAtIndex:indexPath.row];
    PFFile *mediaFile = [locationMediaObject objectForKey:@"image"];
    ImageDetailViewController *idvc = [[ImageDetailViewController alloc]initWithNibName:@"ImageDetailViewController" bundle:nil];
    idvc.imageUrl = mediaFile.url;
    idvc.title = self.title;
    [self.navigationController pushViewController:idvc animated:YES];
}

#pragma mark - location media cell delegate methods 
- (void)thumbsUpButtonTapped:(id)sender {
    PFObject *locationMediaObject = [_contentList objectAtIndex:[sender tag]];
    LocationMediaCell *cell = (LocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    UIButton *thumbsUpButton = cell.thumbsUpButton;
    UIButton *thumbsDownButton = cell.thumbsDownButton;
    [thumbsDownButton setEnabled:YES];
    [thumbsUpButton setEnabled:NO];
    PFQuery *query = [PFQuery queryWithClassName:@"ratings"];
    [query whereKey:@"mediaObject" equalTo:locationMediaObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *ratingObject;
            if (objects.count > 0) {
                ratingObject = [objects objectAtIndex:0];
                [ratingObject setObject:[NSNumber numberWithBool:YES] forKey:@"thumbsUp"];
            }
            else {
                ratingObject = [PFObject objectWithClassName:@"ratings"];
                [ratingObject setObject:[PFUser currentUser] forKey:@"user"];
                [ratingObject setObject:[NSNumber numberWithBool:YES] forKey:@"thumbsUp"];
                [ratingObject setObject:_factualId forKey:@"factualId"];
                [ratingObject setObject:locationMediaObject forKey:@"mediaObject"];
                [ratingObject setObject:self.title forKey:@"locationName"];
            }
            [ratingObject saveEventually];
            [voteTrackerDictionary setObject:@"up" forKey:[NSString stringWithFormat:@"%d", [sender tag]]];
        }
    }];

}

- (void)thumbsDownButtonTapped:(id)sender {
    PFObject *locationMediaObject = [_contentList objectAtIndex:[sender tag]];
    LocationMediaCell *cell = (LocationMediaCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    UIButton *thumbsUpButton = cell.thumbsUpButton;
    UIButton *thumbsDownButton = cell.thumbsDownButton;
    [thumbsDownButton setEnabled:NO];
    [thumbsUpButton setEnabled:YES];
    PFQuery *query = [PFQuery queryWithClassName:@"ratings"];
    [query whereKey:@"mediaObject" equalTo:locationMediaObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            PFObject *ratingObject;
            if (objects.count > 0) {
                ratingObject = [objects objectAtIndex:0];
                [ratingObject setObject:[NSNumber numberWithBool:NO] forKey:@"thumbsUp"];
            }
            else {
                ratingObject = [PFObject objectWithClassName:@"ratings"];
                [ratingObject setObject:[PFUser currentUser] forKey:@"user"];
                [ratingObject setObject:[NSNumber numberWithBool:NO] forKey:@"thumbsUp"];
                [ratingObject setObject:_factualId forKey:@"factualId"];
                [ratingObject setObject:locationMediaObject forKey:@"mediaObject"];
                [ratingObject setObject:self.title forKey:@"locationName"];
            }
            [ratingObject saveEventually];
            [voteTrackerDictionary setObject:@"down" forKey:[NSString stringWithFormat:@"%d", [sender tag]]];
        }
    }];
}

#pragma mark - NavBar Button Action Methods
- (void)doneButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Helper Methods
- (void)getLocationItems:(NSString*)mediaType factualId:(NSString*)factualId {
    NSMutableArray *itemsArray = [[NSMutableArray alloc]init];
    PFQuery *queryForItems = [PFQuery queryWithClassName:@"locationImages"];
    [queryForItems whereKey:@"factualId" equalTo:factualId];
    [queryForItems whereKey:@"mediaType" equalTo:mediaType];
    [queryForItems orderByDescending:@"updatedAt"];
    [queryForItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *locationItemObject in objects) {
                [itemsArray addObject:locationItemObject];
                /*PFFile *mediaFile = [locationItemObject objectForKey:@"image"];
                [itemsArray addObject:mediaFile.url];*/
            }
            [self setContentList:itemsArray];
            [self.tableView reloadData];
        }
    }];
}

- (void)checkVoteStatusForUser:(PFObject*)locationItemObject thumbsUpButton:(UIButton*)thumbsUpButton thumbsDownButton:(UIButton*)thumbsDownButton {
    PFQuery *query = [PFQuery queryWithClassName:@"ratings"];
    [query whereKey:@"user" equalTo:[PFUser currentUser]];
    [query whereKey:@"mediaObject" equalTo:locationItemObject];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            if (objects.count > 0) {
                PFObject *ratingObject = [objects objectAtIndex:0];
                if ([[ratingObject objectForKey:@"thumbsUp"]isEqualToNumber:[NSNumber numberWithBool:YES]]) {
                    thumbsUpButton.enabled = NO;
                    thumbsDownButton.enabled = YES;
                }
                else {
                    thumbsUpButton.enabled = YES;
                    thumbsDownButton.enabled = NO;
                }
            }
        }
    }];
}

#pragma mark - UIWebView Delegate Methods
- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    webView.mediaPlaybackRequiresUserAction = YES;
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    webView.mediaPlaybackRequiresUserAction = YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    webView.mediaPlaybackRequiresUserAction = YES;
}

@end
