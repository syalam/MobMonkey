//
//  MMTrendingDetailViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingDetailViewController.h"
#import "MMLocationViewController.h"
#import "GetRelativeTime.h"

@interface MMTrendingDetailViewController ()

@end

@implementation MMTrendingDetailViewController

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
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnailQueue", NULL);
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    MMTrendingCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMTrendingCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    cell.timeStampLabel.text = @"";
    cell.locationImageView.image = nil;
    cell.locationNameLabel.text = @"";
    cell.requestLabel.text = @"";
    cell.responseLabel.text = @"";
    
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"name"] isKindOfClass:[NSNull class]]) {
        cell.locationNameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"name"];
    }
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"fulfilledDate"] isKindOfClass:[NSNull class]]) {
        double unixTime = [[[_contentList objectAtIndex:indexPath.row]valueForKey:@"fulfilledDate"] floatValue]/1000;
        NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                                (NSTimeInterval)unixTime];
        
        cell.timeStampLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
        [cell.timeStampLabel sizeToFit];
        [cell.timeStampLabel setFrame:CGRectMake(cell.frame.size.width - cell.timeStampLabel.frame.size.width - 20, cell.timeStampLabel.frame.origin.y, cell.timeStampLabel.frame.size.width, cell.timeStampLabel.frame.size.height)];
        [cell.clockImageView setFrame:CGRectMake(cell.timeStampLabel.frame.origin.x - 20, cell.clockImageView.frame.origin.y, cell.clockImageView.frame.size.width, cell.clockImageView.frame.size.height)];
    }
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaUrl"] isKindOfClass:[NSNull class]]) {
        [cell.locationImageView reloadWithUrl:[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaUrl"]];
        
        /*if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
            [cell.locationImageView reloadWithUrl:[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaUrl"]];
        }
        else {
            dispatch_async(backgroundQueue, ^(void) {
                cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row];
            });
        }*/
    }
    
    cell.moreButton.tag = indexPath.row;
    cell.locationNameButton.tag = indexPath.row;
    cell.imageButton.tag = indexPath.row;
    cell.acceptButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
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

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 329;
}


#pragma mark - MMTrendingCell Delegate Methods
-(void)locationNameButtonTapped:(id)sender {
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}
-(void)moreButtonTapped:(id)sender {
    selectedRow = [sender tag];
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
}
-(void)imageButtonTapped:(id)sender {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] != 4) {
        if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] == 1) {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:cell.locationNameLabel.text];
        }
        else {
            NSArray *mediaArray  = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
            if (mediaArray.count > 0) {
                NSURL *url = [NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]];
                NSLog(@"%@", url);
                MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
                [self.navigationController presentMoviePlayerViewControllerAnimated:player];
            }
        }
    }
}

#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (void)publishStoryToFacebook
{
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    BOOL isVideo = NO;
    NSArray *mediaArray  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 1) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 2) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 4) {
            NSString *initialText = [params valueForKey:@"initialText"];
            if (![[[mediaArray objectAtIndex:0]valueForKey:@"text"]isKindOfClass:[NSNull class]]) {
                initialText = [NSString stringWithFormat:@"%@. %@", initialText, [[mediaArray objectAtIndex:0]valueForKey:@"text"]];
            }
            [params setValue:initialText forKey:@"initialText"];
        }
    }
    if (!isVideo) {
        if (![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"]isEqualToString:@""]) {
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
    }
    
    [[MMClientSDK sharedSDK]shareViaFacebook:params presentingViewController:self];
}

- (void)publishOnTwitter {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    BOOL isVideo = NO;
    NSArray *mediaArray  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (mediaArray.count > 0) {
        if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 1) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 2) {
            [params setValue:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"] forKey:@"url"];
            isVideo = YES;
        }
        else if ([[[_contentList objectAtIndex:selectedRow]valueForKey:@"mediaType"]intValue] == 4) {
            NSString *initialText = [params valueForKey:@"initialText"];
            if (![[[mediaArray objectAtIndex:0]valueForKey:@"text"]isKindOfClass:[NSNull class]]) {
                initialText = [NSString stringWithFormat:@"%@. %@", initialText, [[mediaArray objectAtIndex:0]valueForKey:@"text"]];
            }
            [params setValue:initialText forKey:@"initialText"];
        }
    }
    if (!isVideo) {
        if (![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] isKindOfClass:[NSNull class]] && ![[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"]isEqualToString:@""]) {
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
    }
    
    
    [[MMClientSDK sharedSDK]shareViaTwitter:params presentingViewController:self];
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Share on Facebook"]) {
        [self publishStoryToFacebook];
    }
    else if ([buttonTitle isEqualToString:@"Share on Twitter"]) {
        [self publishOnTwitter];
    }
    else if ([buttonTitle isEqualToString:@"Flag for Review"]) {
        
    }
}

- (UIImage*)generateThumbnailForVideo:(int)row {
    UIImage *thumbnailImage;
    
    if (!_thumbnailCache) {
        _thumbnailCache = [[NSMutableDictionary alloc]init];
    }
    
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        thumbnailImage = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
    }
    else {
        NSArray *mediaArray  = [[_contentList objectAtIndex:row]valueForKey:@"media"];
        if (mediaArray.count > 0) {
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]] options:nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generate.appliesPreferredTrackTransform = YES;
            NSError *err = NULL;
            CMTime time = CMTimeMake(0, 60);
            CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
            
            thumbnailImage = [UIImage imageWithCGImage:imgRef];
            [_thumbnailCache setValue:thumbnailImage forKey:[NSString stringWithFormat:@"%d", row]];
        }
    }
    
    return thumbnailImage;
}


@end
