//
//  d.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 1/9/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingDetailViewController.h"
#import "MMLocationMediaViewController.h"
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
    NSDictionary *mediaDictionary = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"media"];
    
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
    cell.locationImageView.image = nil;
    if (![[mediaDictionary valueForKey:@"uploadedDate"] isKindOfClass:[NSNull class]]) {
        double unixTime = [[mediaDictionary valueForKey:@"uploadedDate"] floatValue]/1000;
        NSDate *dateAnswered = [NSDate dateWithTimeIntervalSince1970:
                                (NSTimeInterval)unixTime];
        
        cell.timeStampLabel.text = [GetRelativeTime getRelativeTime:dateAnswered];
        [cell.timeStampLabel sizeToFit];
        [cell.timeStampLabel setFrame:CGRectMake(cell.frame.size.width - cell.timeStampLabel.frame.size.width - 20, cell.timeStampLabel.frame.origin.y, cell.timeStampLabel.frame.size.width, cell.timeStampLabel.frame.size.height)];
        [cell.clockImageView setFrame:CGRectMake(cell.timeStampLabel.frame.origin.x - 20, cell.clockImageView.frame.origin.y, cell.clockImageView.frame.size.width, cell.clockImageView.frame.size.height)];
    }
    if (![[mediaDictionary valueForKey:@"mediaURL"] isKindOfClass:[NSNull class]]) {
        if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"image"]) {
            [cell.locationImageView reloadWithUrl:[mediaDictionary valueForKey:@"mediaURL"]];
        }
        else if([[mediaDictionary valueForKey:@"type"] isEqualToString:@"livestreaming"]) {
            cell.locationImageView.image = [UIImage imageNamed:@"liveFeedPlaceholder"];
            [cell.playButtonImageView setHidden:NO];
        }
        else {
            dispatch_async(backgroundQueue, ^(void) {
                cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row cell:cell];
            });
            [cell.playButtonImageView setHidden:NO];
        }
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
    NSDictionary *mediaDictionary = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc] initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    lmvc.title = cell.locationNameLabel.text;
    lmvc.locationName = cell.locationNameLabel.text;
    lmvc.providerId = providerId;
    lmvc.locationId = locationId;
    if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"image"]) {
        lmvc.mediaType = 2;
    }
    else if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"video"]) {
        lmvc.mediaType = 1;
    }
    else {
        lmvc.mediaType = 0;
    }
    
    UINavigationController *locationMediaNavC = [[UINavigationController alloc] initWithRootViewController:lmvc];
    locationMediaNavC.modalTransitionStyle = UIModalTransitionStyleFlipHorizontal;
    [self presentViewController:locationMediaNavC animated:YES completion:NULL];
}
-(void)moreButtonTapped:(id)sender {
    selectedRow = [sender tag];
    
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    NSDictionary *mediaDictionary  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (![[mediaDictionary valueForKey:@"mediaURL"]isKindOfClass:[NSNull class]]) {
        if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"image"]) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
        else {
            [params setValue:[mediaDictionary valueForKey:@"mediaURL"] forKey:@"url"];
        }
    }
    
    [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:YES paramsForPublishingToSocialNetwork:params];
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];*/
}
-(void)imageButtonTapped:(id)sender {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    NSDictionary *mediaDictionary = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
    if (![mediaDictionary isKindOfClass:[NSNull class]] && ![[mediaDictionary valueForKey:@"mediaURL"] isKindOfClass:[NSNull class]]) {
        if ([[mediaDictionary valueForKey:@"type"]isEqualToString:@"image"]) {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:cell.locationNameLabel.text];
        }
        else {
            NSURL *url = [NSURL URLWithString:[mediaDictionary valueForKey:@"mediaURL"]];
            NSLog(@"%@", url);
            MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
            [self.navigationController presentMoviePlayerViewControllerAnimated:player];
        }
    }
}

#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Helper Methods
- (void)publishStoryToFacebook {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    NSDictionary *mediaDictionary  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (![[mediaDictionary valueForKey:@"mediaURL"]isKindOfClass:[NSNull class]]) {
        if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"image"]) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
        else {
            [params setValue:[mediaDictionary valueForKey:@"mediaURL"] forKey:@"url"];
        }
    }
    
    [[MMClientSDK sharedSDK]shareViaFacebook:params presentingViewController:self];
}

- (void)publishOnTwitter {
    MMTrendingCell *cell = (MMTrendingCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
    NSDictionary *mediaDictionary  = [[_contentList objectAtIndex:selectedRow]valueForKey:@"media"];
    NSMutableDictionary *params = [[NSMutableDictionary alloc]init];
    [params setValue:cell.locationNameLabel.text forKey:@"initialText"];
    if (![[mediaDictionary valueForKey:@"mediaURL"]isKindOfClass:[NSNull class]]) {
        if ([[mediaDictionary valueForKey:@"type"] isEqualToString:@"image"]) {
            [params setValue:cell.locationImageView.image forKey:@"image"];
            [params setValue:[[_contentList objectAtIndex:selectedRow]valueForKey:@"webSite"] forKey:@"url"];
        }
        else {
            [params setValue:[mediaDictionary valueForKey:@"mediaURL"] forKey:@"url"];
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

- (UIImage*)generateThumbnailForVideo:(int)row cell:(MMTrendingCell*)cell {
    UIImage *thumbnailImage;
    
    if (!_thumbnailCache) {
        _thumbnailCache = [[NSMutableDictionary alloc]init];
    }
    
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            cell.locationImageView.image = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
        });
    }
    else {
        NSDictionary *mediaDictionary  = [[_contentList objectAtIndex:row]valueForKey:@"media"];
        if (![[mediaDictionary valueForKey:@"mediaURL"]isKindOfClass:[NSNull class]]) {
            AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL URLWithString:[mediaDictionary valueForKey:@"mediaURL"]] options:nil];
            AVAssetImageGenerator *generate = [[AVAssetImageGenerator alloc] initWithAsset:asset];
            generate.appliesPreferredTrackTransform = YES;
            NSError *err = NULL;
            CMTime time = CMTimeMake(0, 60);
            CGImageRef imgRef = [generate copyCGImageAtTime:time actualTime:NULL error:&err];
            
            thumbnailImage = [UIImage imageWithCGImage:imgRef];
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [_thumbnailCache setValue:thumbnailImage forKey:[NSString stringWithFormat:@"%d", row]];
                cell.locationImageView.image = thumbnailImage;
            });
        }
    }
    
    return thumbnailImage;
}


@end
