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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    [self fetchAnsweredRequests];
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
    if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 4) {
        static NSString *CellIdentifier = @"TextAnswerCell";
        UITableViewCell *textCell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!textCell) {
            textCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            textCell.textLabel.font = [UIFont boldSystemFontOfSize:12];
            textCell.backgroundColor = [UIColor whiteColor];
        }
        
        textCell.textLabel.text = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"message"];
        
        return textCell;
    }
    else {
        static NSString *CellIdentifier = @"Cell";
        MMAnsweredRequestsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (!cell) {
            cell = [[MMAnsweredRequestsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
            cell.delegate = self;
        }
        
        cell.timeStampLabel.text = @"";
        cell.locationImageView.image = nil;
        cell.locationNameLabel.text = @"";
        
        NSArray *mediaArray  = [[_contentList objectAtIndex:indexPath.row]valueForKey:@"media"];
        
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
            else {
                dispatch_async(backgroundQueue, ^(void) {
                    cell.locationImageView.image =  [self generateThumbnailForVideo:indexPath.row];
                });
            }
        }
        
        cell.moreButton.tag = indexPath.row;
        cell.locationNameButton.tag = indexPath.row;
        cell.imageButton.tag = indexPath.row;
        cell.acceptButton.tag = indexPath.row;
        cell.rejectButton.tag = indexPath.row;
        
        return cell;
    }
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
}

- (CGFloat)tableView:(UITableView *)aTableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([[[_contentList objectAtIndex:indexPath.row]valueForKey:@"mediaType"]intValue] == 4) {
        return 50;
    }
    else {
        return 370;
    }
}

#pragma mark - UINavBar Action Methods
- (void)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MMAnsweredRequestCell delegate
-(void)locationNameButtonTapped:(id)sender {
    NSString *locationId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"locationId"];
    NSString *providerId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"providerId"];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

-(void)moreButtonTapped:(id)sender {
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Flag for Review", nil];
    [actionSheet showFromTabBar:self.tabBarController.tabBar];
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
    NSString *requestId = [[_contentList objectAtIndex:[sender tag]]valueForKey:@"requestId"];
    NSString *mediaId = [[[[_contentList objectAtIndex:[sender tag]]valueForKey:@"media"]objectAtIndex:0]valueForKey:@"mediaId"];
    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                            requestId, @"requestId",
                            mediaId, @"mediaId", nil];
    [MMAPI rejectMedia:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self fetchAnsweredRequests];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}
-(void)imageButtonTapped:(id)sender {
    MMAnsweredRequestsCell *cell = (MMAnsweredRequestsCell*)[self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:[sender tag] inSection:0]];
    
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


#pragma mark - Helper Methods
- (void)fetchAnsweredRequests {
    [SVProgressHUD showWithStatus:@"Loading Answered Requests"];
    [MMAPI getFulfilledRequestsOnSuccess:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [SVProgressHUD dismiss];
        [self setContentList:responseObject];
        [self.tableView reloadData];
    } failure:^(NSError *error) {
        [SVProgressHUD showErrorWithStatus:@"Unable to load"];
    }];
}

- (UIImage*)generateThumbnailForVideo:(int)row {
    UIImage *thumbnailImage;
    
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
