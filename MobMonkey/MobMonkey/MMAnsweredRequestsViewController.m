//
//  MMAnsweredRequestsViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/7/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAnsweredRequestsViewController.h"
#import "MMClientSDK.h"
#import "GetRelativeTime.h"
#import "MMLocationViewController.h"
#import "MMLocationListCell.h"
#import <AVFoundation/AVFoundation.h>
#import "UIImageView+AFNetworking.h"
@interface MMAnsweredRequestsViewController ()

@end

@implementation MMAnsweredRequestsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

#pragma mark - View Life cycle
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    backgroundQueue = dispatch_queue_create("com.MobMonkey.GenerateThumbnailQueue", NULL);
    
    _thumbnailCache = [[NSMutableDictionary alloc]init];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    [self fetchAnsweredRequests];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
}

- (void)viewDidUnload {
    [self setAcceptRejectCell:nil];
    [super viewDidUnload];
}

- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
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
    return _contentList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *mediaArray  = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"media"];
    static NSString *CellIdentifier = @"Cell";
    MMAnsweredRequestsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMAnsweredRequestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.delegate = self;
    }
    cell.timeStampLabel.textColor = [UIColor whiteColor];
    cell.timeStampLabel.text = @"";
    cell.locationImageView.image = nil;
    cell.locationNameLabel.text = @"";
    cell.requestLabel.text = @"";
    cell.responseLabel.text = @"";
    [cell.clockImageView setImage:[UIImage imageNamed:@"timeIcnOverlay"]];
    
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"] isKindOfClass:[NSNull class]]) {
        cell.locationNameLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"nameOfLocation"];
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
    if (![[[_contentList objectAtIndex:indexPath.row]valueForKey:@"media"] isKindOfClass:[NSNull class]]) {
        if (mediaArray.count > 0) {
            if ([[[mediaArray objectAtIndex:0]valueForKey:@"accepted"]intValue] == 1) {
                [cell.acceptButton setHidden:YES];
                [cell.rejectButton setHidden:YES];
            }
        }
        
        if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 1) {
            if (mediaArray.count > 0) {
                [cell.locationImageView reloadWithUrl:[[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"]];
            }
        }
        else if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 3) {
            if (mediaArray.count > 0) {
                cell.locationImageView.image = [UIImage imageNamed:@"liveFeedPlaceholder"];
                cell.playButtonImageView.hidden = NO;
            }
        }
        else if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 4) {
            if (mediaArray.count > 0) {
                if (![[[mediaArray objectAtIndex:0]valueForKey:@"text"]isKindOfClass:[NSNull class]]) {
                    [cell.timeStampLabel setTextColor:[UIColor blackColor]];
                    [cell.clockImageView setImage:[UIImage imageNamed:@"timeIcnOverlayBlack"]];
                    
                    cell.requestLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"];
                    cell.responseLabel.text = [[mediaArray objectAtIndex:0]valueForKey:@"text"];
                    
                    cell.requestLabel.numberOfLines = 3;
                    cell.requestLabel.lineBreakMode = NSLineBreakByWordWrapping;
                    
                    cell.responseLabel.numberOfLines = 3;
                    cell.responseLabel.lineBreakMode = NSLineBreakByWordWrapping;
                 
                    CGFloat adjustmentFactor = 100;
                    
                    [cell.requestLabel sizeToFit];
                    [cell.responseLabel setFrame:CGRectMake(cell.responseLabel.frame.origin.x, cell.requestLabel.frame.origin.y + cell.requestLabel.frame.size.height + 5, cell.responseLabel.frame.size.height, cell.responseLabel.frame.size.height)];
                    
                    [cell.responseLabel sizeToFit];
                    
                    [cell.whiteBackgroundView setFrame:CGRectMake(cell.whiteBackgroundView.frame.origin.x, cell.whiteBackgroundView.frame.origin.y, cell.whiteBackgroundView.frame.size.width, cell.whiteBackgroundView.frame.size.height - adjustmentFactor)];
                    
                    [cell.acceptButton setFrame:CGRectMake(cell.acceptButton.frame.origin.x, cell.acceptButton.frame.origin.y - adjustmentFactor, cell.acceptButton.frame.size.width, cell.acceptButton.frame.size.height)];
                    [cell.rejectButton setFrame:CGRectMake(cell.rejectButton.frame.origin.x, cell.rejectButton.frame.origin.y - adjustmentFactor, cell.rejectButton.frame.size.width, cell.rejectButton.frame.size.height)];
                    [cell.moreButton setFrame:CGRectMake(cell.moreButton.frame.origin.x, cell.moreButton.frame.origin.y - adjustmentFactor, cell.moreButton.frame.size.width, cell.moreButton.frame.size.height)];
                }
            }
        }
        else {
            
            NSString *thumbURL = [[mediaArray objectAtIndex:0] objectForKey:@"thumbURL"];
            
            if(thumbURL && ![thumbURL isEqual:[NSNull null]] && thumbURL.length > 0){
                [cell.locationImageView setImageWithURL:[NSURL URLWithString: thumbURL]];
            }
            
            
            NSLog(@"URL: %@", [[mediaArray objectAtIndex:0]valueForKey:@"thumbURL"]);
            //dispatch_async(backgroundQueue, ^(void) {
            //    cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row cell:cell];
            //});
            cell.playButtonImageView.hidden = NO;
        }
    }
    
    cell.moreButton.tag = indexPath.row;
    cell.locationNameButton.tag = indexPath.row;
    cell.imageButton.tag = indexPath.row;
    cell.acceptButton.tag = indexPath.row;
    cell.rejectButton.tag = indexPath.row;
    
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 4) {
        return 270;
    }
    else {
        return 370;
    }
}

#pragma mark - UINavBar Action Methods
- (void)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [_delegate updateInboxCount];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MMAnsweredRequestCell delegate
-(void)locationNameButtonTapped:(id)sender {
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

-(void)moreButtonTapped:(id)sender {
    selectedRow = [sender tag];
    
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
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
    
    [[MMClientSDK sharedSDK]showMoreActionSheet:self showFromTabBar:YES paramsForPublishingToSocialNetwork:params];
    /*UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];*/
}
-(void)acceptButtonTapped:(id)sender {
    NSString *requestId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"requestId"];
    NSString *mediaId = [[[[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"]objectAtIndex:0]valueForKey:@"mediaId"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            requestId, @"requestId",
                            mediaId, @"mediaId", nil];
    [MMAPI acceptMedia:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self fetchAnsweredRequests];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}
-(void)rejectButtonTapped:(id)sender {
    NSLog(@"%@", _contentList);
    NSArray *mediaArray = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
    
    if (mediaArray.count > 0) {
        NSString *requestId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"requestId"];
        NSString *mediaId = [[mediaArray objectAtIndex:0]valueForKey:@"mediaId"];
        NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                requestId, @"requestId",
                                mediaId, @"mediaId", nil];
        [MMAPI rejectMedia:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self fetchAnsweredRequests];
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
        }];
    }
}
-(void)imageButtonTapped:(id)sender {
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] != 4) {
        if ([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] == 1) {
            [[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:cell.locationImageView.image locationName:cell.locationNameLabel.text];
        }
        else {
            NSArray *mediaArray  = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"];
            if (mediaArray.count > 0) {
                
                NSString *urlPath = [[mediaArray objectAtIndex:0]valueForKey:@"mediaURL"];
                
                if([[[_contentList objectAtIndex:[sender tag]]valueForKey:@"mediaType"]intValue] == 2){
                    urlPath = [urlPath stringByReplacingOccurrencesOfString:@"http://vod-cdn.mobmonkey.com" withString:@"https://s3.amazonaws.com/mobmonkeyvod"];
                }
                NSURL *url = [NSURL URLWithString:urlPath];
                NSLog(@"%@", url);
                UIGraphicsBeginImageContext(CGSizeMake(1,1));
                MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:url];
                [self presentMoviePlayerViewControllerAnimated:player];
                UIGraphicsEndImageContext();
            }
        }
    }
}


#pragma mark - Helper Methods
- (void)fetchAnsweredRequests {
    [SVProgressHUD showWithStatus:@"Loading Answered Requests"];
    [MMAPI getFulfilledRequests:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", responseObject);
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Unable to load"];
    }];
}

- (UIImage*)generateThumbnailForVideo:(int)row cell:(MMAnsweredRequestsCell*)cell {
    UIImage *thumbnailImage;
    
    if ([_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]]) {
        dispatch_async(dispatch_get_main_queue(), ^(void) {
            cell.locationImageView.image = [_thumbnailCache valueForKey:[NSString stringWithFormat:@"%d", row]];
        });
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
            
            dispatch_async(dispatch_get_main_queue(), ^(void) {
                [_thumbnailCache setValue:thumbnailImage forKey:[NSString stringWithFormat:@"%d", row]];
                cell.locationImageView.image = thumbnailImage;
            });
        }
    }
    
    return thumbnailImage;
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


#pragma mark - Helper Methods
- (void)publishStoryToFacebook
{
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
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
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:selectedRow inSection:0]];
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


@end
