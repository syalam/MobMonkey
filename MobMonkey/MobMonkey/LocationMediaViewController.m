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
    
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(doneButtonTapped:)];
    self.navigationItem.rightBarButtonItem = doneButton;
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
    cell.delegate = self;
    
    cell = [[LocationMediaCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    
        
    if ([[_contentList objectAtIndex:indexPath.row] rangeOfString:@".mov"].location != NSNotFound) {
        AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[_contentList objectAtIndex:indexPath.row]] options:nil];
        AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
        generate.appliesPreferredTrackTransform = YES;
        NSError *err = NULL;
        CMTime time = CMTimeMake(0, 60);
        CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
        cell.imageView.image = [[UIImage alloc] initWithCGImage:imgRef];
    }
    else {
        [cell.cellImageView reloadWithUrl:[_contentList objectAtIndex:indexPath.row]];
    }
    
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[_contentList objectAtIndex:indexPath.row]]];
    /*[cell.cellWebView loadRequest:request];
    if ([[_contentList objectAtIndex:indexPath.row] rangeOfString:@".mov"].location != NSNotFound) {
        [cell.cellWebView setScalesPageToFit:NO];
    }*/
    /*else {
        
        [cell.cellWebView setHidden:YES];
        [cell.cellImageView reloadWithUrl:[_contentList objectAtIndex:indexPath.row]];
    }*/
    
    
    /*if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]isEqualToString:@"video"]) {
        cell.textLabel.text = @"Video";
    }
    else {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake((self.view.frame.size.width/2)-75, 5, 150, 150)];
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.image = [[UIImage alloc]initWithData:[[_contentList objectAtIndex:indexPath.row]valueForKey:@"file"]];
        [cell.contentView addSubview:imageView];
    }*/
    
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

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 160;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{    
    /*if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]isEqualToString:@"video"]) {
        NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@.mp4", [[_contentList objectAtIndex:indexPath.row]valueForKey:@"url"]]];
        NSLog(@"video url is: %@", [NSString stringWithFormat:@"%@.mp4", [[_contentList objectAtIndex:indexPath.row]valueForKey:@"url"]]);
        MPMoviePlayerViewController *player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
        [self.navigationController presentMoviePlayerViewControllerAnimated:player];
    }*/
    //else if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]isEqualToString:@"photo"]) {
        ImageDetailViewController *idvc = [[ImageDetailViewController alloc]initWithNibName:@"ImageDetailViewController" bundle:nil];
        idvc.imageUrl = [_contentList objectAtIndex:indexPath.row];
        idvc.title = self.title;
        [self.navigationController pushViewController:idvc animated:YES];
    //}
}

#pragma mark - NavBar Button Action Methods
- (void)doneButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

#pragma mark - Helper Methods
- (void)getLocationItems:(NSString*)mediaType factualId:(NSString*)factualId {
    NSMutableArray *urlArray = [[NSMutableArray alloc]init];
    PFQuery *queryForItems = [PFQuery queryWithClassName:@"locationImages"];
    [queryForItems whereKey:@"factualId" equalTo:factualId];
    [queryForItems whereKey:@"mediaType" equalTo:mediaType];
    [queryForItems orderByAscending:@"updatedAt"];
    [queryForItems findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
            for (PFObject *locationItemObject in objects) {
                PFFile *mediaFile = [locationItemObject objectForKey:@"image"];
                [urlArray addObject:mediaFile.url];
                /*[mediaFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    [urlArray addObject:[NSDictionary dictionaryWithObjectsAndKeys:mediaFile.url, @"url", mediaType, @"mediaType", data, @"file", nil]];
                    [self setContentList:urlArray];
                    [self.tableView reloadData];
                }];*/
            }
            [self setContentList:urlArray];
            [self.tableView reloadData];
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
