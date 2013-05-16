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
    
    
    
    
    self.favoriteMedia = [NSArray array];
    self.topViewedMedia = [NSArray array];
    self.myInterestsMedia = [NSArray array];
    self.nearByMedia = [NSArray array];
    
    self.collectionView.backgroundView = nil;
    self.collectionView.backgroundColor = [UIColor colorWithWhite:0.918 alpha:1.000];
    
    bottomGradientImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, self.view.frame.size.height - 40 - 50 - 40, self.view.frame.size.width, 40)];
    [bottomGradientImageView setImage:[UIImage imageNamed:@"gradientBackgroundBottom"]];
    bottomGradientImageView.layer.zPosition = 100;
    [self.collectionView addSubview:bottomGradientImageView];
    
    // Do any additional setup after loading the view from its nib.
    
    UINib *cellNib = [UINib nibWithNibName:@"MMTrendingCollectionViewCell" bundle:nil];
    [self.collectionView registerNib:cellNib forCellWithReuseIdentifier:@"MMTrendingCollectionViewCell"];
    
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"TrendingCollectionViewCell"];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(adWhirlChangedValue:)
                                                 name:@"AdWhirlChange" object:nil];
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
        [self.collectionView reloadData];
    }];
}
-(void)adWhirlChangedValue:(id)sender{

    [self.collectionView reloadData];   
    [self scrollViewDidScroll:self.collectionView];
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

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"MMTrendingCollectionViewCell";
    
    MMTrendingCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
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
    
    if(!mediaObject.highResImage){
        NSURL * imageURL;
        
        if(mediaObject.mediaType == MMMediaTypeVideo){
            imageURL = mediaObject.highResImageURL;
        }else if(mediaObject.mediaType == MMMediaTypePhoto){
            imageURL = mediaObject.mediaURL;
        }
        
        if(imageURL){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NULL), ^{
                
                NSData *data = [NSData dataWithContentsOfURL:imageURL];
                UIImage *image = [UIImage imageWithData:data];
                mediaObject.highResImage = image;
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    //Maybe correct the frame too
                    [cell.imageViewButton setImage:image forState:UIControlStateNormal];
                    
                    
                    
                });
            });
            
        }
    }else{
        [cell.imageViewButton setImage:mediaObject.highResImage forState:UIControlStateNormal];
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
/*-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    //TODO: ADD HEADER AND FOOTER VIEWS
}*/

#pragma mark - ScrollViewDelegate;
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    MMAppDelegate *appDelegate = (MMAppDelegate *)[[UIApplication sharedApplication] delegate];
    
    NSUInteger adHeight = 0;
    if(!appDelegate.adView.hidden){
        adHeight = appDelegate.adView.frame.size.height;
    }
    
    CGRect newFrame = bottomGradientImageView.frame;
    newFrame.origin.x = 0;
    newFrame.origin.y = self.collectionView.contentOffset.y + self.view.frame.size.height - newFrame.size.height - adHeight;
    bottomGradientImageView.frame = newFrame;
}
@end
