//
//  MMTrendingViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMTrendingViewController.h"
#import "MMAppDelegate.h"
#import <QuartzCore/QuartzCore.h>
#import "MMTrendingMedia.h"
#import "MMMediaObject.h"
#import "MMTrendingCollectionViewCell.h"
#import <MediaPlayer/MediaPlayer.h>
#import "MMSlideMenuViewController.h"
#import "ECSlidingViewController.h"
#import "MMRequestInboxCell.h"
#import "MMJSONCommon.h"

@interface MMTrendingViewController ()

@property (nonatomic, strong) NSArray *favoriteMedia;
@property (nonatomic, strong) NSArray *topViewedMedia;
@property (nonatomic, strong) NSArray *myInterestsMedia;
@property (nonatomic, strong) NSArray *nearByMedia;

@end

@implementation MMTrendingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self reloadMedia];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    noMediaImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.frame.size.width - 149)/2, 120, 149, 95)];
    [noMediaImageView setImage:[UIImage imageNamed:@"noMedia"]];
    [self.view addSubview:noMediaImageView];
    
    self.favoriteMedia = [NSArray array];
    self.topViewedMedia = [NSArray array];
    self.myInterestsMedia = [NSArray array];
    self.nearByMedia = [NSArray array];
    
    //self.collectionView.backgroundView = nil;
    //self.collectionView.backgroundColor = [UIColor MMEggShell];
    
    // Do any additional setup after loading the view from its nib.
    
    UINib *cellNib = [UINib nibWithNibName:@"MMTrendingCollectionViewCell" bundle:nil];
    //[self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MMTrendingCollectionViewCell"];
    
    //[self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TrendingCollectionViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adWhirlChangedValue:)
                                                 name:@"AdWhirlChange" object:nil];
}
-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.view.layer.shadowOpacity = 0.75f;
    self.view.layer.shadowRadius = 10.0f;
    self.view.layer.shadowColor = [UIColor blackColor].CGColor;
    
    if(![self.slidingViewController.underLeftViewController isKindOfClass:[MMSlideMenuViewController class]]){
        
        MMSlideMenuViewController *menuViewController = [[MMSlideMenuViewController alloc] initWithNibName:@"MMSlideMenuViewController" bundle:nil];
        self.slidingViewController.underLeftViewController = menuViewController;   }
    
    //if(self.slidingViewController.panGesture){
    [self.view addGestureRecognizer:self.slidingViewController.panGesture];
}

-(NSArray *)mediaCellWrappersWithMediaObjects:(NSArray *)mediaObjects {
    
    NSMutableArray * arrayOfWrappers = [NSMutableArray arrayWithCapacity:mediaObjects.count];
    for (MMMediaObject * mediaObject in mediaObjects){
        
        MMRequestWrapper * requestWrapper;
        if(mediaObject.mediaType == MMMediaTypeVideo){
            
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
            ((MMMediaRequestWrapper *)requestWrapper).mediaURL = mediaObject.thumbURL;
            
        }else if(mediaObject.mediaType == MMMediaTypePhoto){
            
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
            ((MMMediaRequestWrapper *)requestWrapper).mediaURL = mediaObject.mediaURL;
            
        }else if(mediaObject.mediaType == MMMediaTypeLiveVideo){
            requestWrapper = [[MMMediaRequestWrapper alloc] initWithTableWidth:320];
        }else{
            requestWrapper = [[MMRequestWrapper alloc] initWithTableWidth:320];
        }
        
        requestWrapper.mediaType = mediaObject.mediaType;
        requestWrapper.durationSincePost = [MMJSONCommon dateStringDurationSinceDate:mediaObject.uploadDate];
        requestWrapper.cellStyle = MMRequestCellStyleTimeline;
        requestWrapper.isAnswered = YES;
        
        MMRequestObject * requestObject = [[MMRequestObject alloc] init];
        requestObject.mediaObject = mediaObject;
        
        requestWrapper.requestObject = requestObject;
        
        
        
        
        [arrayOfWrappers addObject:requestWrapper];
        
    }
    return arrayOfWrappers;
    
}

-(void)reloadMedia{
    [MMTrendingMedia getTrendingMediaForAllTypesCompletion:^(NSArray *mediaObjects, MMTrendingType trendingType, NSError *error) {
        
        switch (trendingType) {
            case MMTrendingTypeFavorites:
                self.favoriteMedia = mediaObjects;
                break;
            case MMTrendingTypeMyInterests:
                self.myInterestsMedia = mediaObjects;
                break;
            case MMTrendingTypeNearBy:
                self.nearByMedia = mediaObjects;
                break;
            case MMTrendingTypeTopViewed:
                self.topViewedMedia = mediaObjects;
                break;
                
            default:
                break;
        }
        
        if(!self.favoriteMedia.count > 0 &&
           !self.myInterestsMedia.count > 0 &&
           !self.nearByMedia.count > 0 &&
           !self.topViewedMedia.count > 0 ) {
            noMediaImageView.hidden = NO;
        }else{
            noMediaImageView.hidden = YES;
        }
        
        [self.tableView reloadData];
    }];
}
-(void)adWhirlChangedValue:(id)sender{

    [self.tableView reloadData];
    //[self scrollViewDidScroll:self.collectionView];
}
-(void)viewDidUnload {
    [super viewDidUnload];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:@"AdWhirlChange" object:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View Data Source

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 4;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    NSUInteger numberOfMediaObjects = 0;
    switch (section) {
        case MMTrendingTypeFavorites - 1:
            numberOfMediaObjects = self.favoriteMedia.count;
            break;
        case MMTrendingTypeMyInterests - 1:
            numberOfMediaObjects = self.myInterestsMedia.count;
            break;
        case MMTrendingTypeNearBy - 1:
            numberOfMediaObjects = self.nearByMedia.count;
            break;
        case MMTrendingTypeTopViewed - 1:
            numberOfMediaObjects = self.topViewedMedia.count;
            break;
            
        default:
            break;
    }
    
    return numberOfMediaObjects > 3 ? 3 : numberOfMediaObjects;
}
-(void)favoritesMediaTapped:(UIButton*)button{
    [self mediaTappedWithIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:MMTrendingTypeFavorites - 1]];
}
-(void)topViewedMediaTapped:(UIButton*)button{
    [self mediaTappedWithIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:MMTrendingTypeTopViewed - 1]];
}
-(void)myInterestsMediaTapped:(UIButton*)button{
    [self mediaTappedWithIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:MMTrendingTypeMyInterests - 1]];
}
-(void)nearbyMeduaTapped:(UIButton*)button{
    [self mediaTappedWithIndexPath:[NSIndexPath indexPathForItem:button.tag inSection:MMTrendingTypeNearBy - 1]];
}
-(void)mediaTappedWithIndexPath:(NSIndexPath*)indexPath{
    
    MMMediaObject *mediaObject;
    switch (indexPath.section) {
        case MMTrendingTypeFavorites -1:
            mediaObject = [self.favoriteMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeMyInterests -1:
            mediaObject = [self.myInterestsMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeNearBy -1:
            mediaObject = [self.nearByMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeTopViewed -1:
            mediaObject = [self.topViewedMedia objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    
    if (mediaObject.mediaType == MMMediaTypePhoto) {
        //[[MMClientSDK sharedSDK] inboxFullScreenImageScreen:self imageToDisplay:mediaObject.highResImage locationName:mediaObject.name];
    }
    else {
        
        if(mediaObject.mediaURL){
        
            UIGraphicsBeginImageContext(CGSizeMake(1,1));
            
            MPMoviePlayerViewController* player = [[MPMoviePlayerViewController alloc] initWithContentURL:mediaObject.mediaURL];
            UIGraphicsEndImageContext();
            [self.navigationController presentMoviePlayerViewControllerAnimated:player];
        }
    }
    
    
}
/*- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MMTrendingCollectionViewCell";
    
    MMTrendingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.imageViewButton.contentMode = UIViewContentModeScaleAspectFill;
    cell.imageViewButton.tag = indexPath.row;
    
    switch (indexPath.section) {
        case MMTrendingTypeFavorites - 1:
            [cell.imageViewButton addTarget:self action:@selector(favoritesMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playButton addTarget:self action:@selector(favoritesMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case MMTrendingTypeMyInterests - 1:
            [cell.imageViewButton addTarget:self action:@selector(myInterestsMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playButton addTarget:self action:@selector(myInterestsMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case MMTrendingTypeTopViewed - 1:
            [cell.imageViewButton addTarget:self action:@selector(topViewedMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playButton addTarget:self action:@selector(topViewedMediaTapped:) forControlEvents:UIControlEventTouchUpInside];
            break;
        case MMTrendingTypeNearBy -1:
            [cell.imageViewButton addTarget:self action:@selector(nearbyMeduaTapped:) forControlEvents:UIControlEventTouchUpInside];
            [cell.playButton addTarget:self action:@selector(nearbyMeduaTapped:) forControlEvents:UIControlEventTouchUpInside];
            break;
            
        default:
            break;
    }
    
    
    MMMediaObject *mediaObject;
    switch (indexPath.section) {
        case MMTrendingTypeFavorites - 1:
            mediaObject = [self.favoriteMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeMyInterests - 1:
            mediaObject = [self.myInterestsMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeNearBy - 1:
            mediaObject = [self.nearByMedia objectAtIndex:indexPath.row];
            break;
        case MMTrendingTypeTopViewed - 1:
            mediaObject = [self.topViewedMedia objectAtIndex:indexPath.row];
            break;
            
        default:
            break;
    }
    
    if(YES){
        NSURL * imageURL;
        
        if(mediaObject.mediaType == MMMediaTypeVideo){
            //imageURL = mediaObject.highResImageURL;
        }else if(mediaObject.mediaType == MMMediaTypePhoto){
            imageURL = mediaObject.mediaURL;
        }
        
        if(imageURL){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, NULL), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:data scale:0.25];
                //mediaObject.highResImage = image;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Maybe correct the frame too
                    MMTrendingCollectionViewCell *cellToUpdate = (MMTrendingCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath]; // create a copy of the cell to avoid keeping a strong pointer to "cell" since that one may have been reused by the time the block is ready to update it.
                    if (cellToUpdate != nil) {
                        [cellToUpdate.imageViewButton setImage:image forState:UIControlStateNormal];
                        [cellToUpdate setNeedsLayout];
                    }
                    
                    
                });
            });
            
        }
    }else{
        //[cell.imageViewButton setImage:mediaObject.highResImage forState:UIControlStateNormal];
    }
    
    if(mediaObject.mediaType == MMMediaTypeLiveVideo || mediaObject.mediaType == MMMediaTypeVideo){
        cell.playButton.hidden = NO;
    }else{
        cell.playButton.hidden = YES;
    }
    
    
    
    
    cell.backgroundColor = [UIColor blackColor];
    
    return cell;
}

#pragma mark - CollectionView Layout 
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    //First row in each section will be larger
    if(indexPath.row == 0){
        return CGSizeMake(280, 280);
    }
    else{
        return CGSizeMake(128, 128);
    }
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return 22;
}
-(CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return 20;
}
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section {
    return CGSizeMake(self.view.frame.size.width, 40);
}
-(UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    
    return UIEdgeInsetsMake(0, 20, 0, 20);
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section {
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    if(section == [collectionView numberOfSections] - 1 && !appDelegate.adView.hidden){
        return CGSizeMake(self.view.frame.size.width, 15 + appDelegate.adView.frame.size.height);
    }
    return CGSizeMake(self.view.frame.size.width, 15);
}
*/
@end
