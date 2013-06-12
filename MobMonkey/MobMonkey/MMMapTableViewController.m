//
//  MMMapTableViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMapTableViewController.h"


@interface MMMapTableViewController ()

@property (nonatomic, assign) UITableViewStyle tableViewStyle;
@property (nonatomic, assign) CGFloat defaultMapHeight;
@property (nonatomic, assign) CGFloat parallaxFactor;
@property (nonatomic, assign) CGRect defaultMapViewFrame;
@property (nonatomic, strong) UITapGestureRecognizer *mapTapGesture;
@property (nonatomic, assign, getter = isMapVisible) BOOL mapVisible;
@property (nonatomic, assign) BOOL isScrollDragging;
@property (nonatomic, assign) BOOL pullToExpandMapEnabled;
@property (nonatomic, assign) CGFloat amountToScrollToFullScreenMap;

@end

@implementation MMMapTableViewController

-(id)initWithTableViewStyle:(UITableViewCellStyle)tableViewStyle defaultMapHeight:(CGFloat)defaultMapHeight parallaxFactor:(CGFloat)parallaxFactor{
    
    if(self = [super initWithNibName:nil bundle:nil]){
        
        self.tableViewStyle = tableViewStyle;
        self.defaultMapHeight = defaultMapHeight;
        self.parallaxFactor = parallaxFactor;
        
        
        
    }
    
    return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.pullToExpandMapEnabled = YES;
    self.amountToScrollToFullScreenMap = 100;
    
    //Set up TableView
    _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:self.tableViewStyle];
    _tableView.backgroundColor = [UIColor clearColor];
    _tableView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    _tableView.delegate = self;
    _tableView.dataSource = self;
    
    
    
    UIView *clearView = [[UIView alloc] initWithFrame:self.view.bounds];
    clearView.backgroundColor = [UIColor clearColor];
    
    UIImage *tableBG = [[UIImage imageNamed:@"gradient5pt"] stretchableImageWithLeftCapWidth:0 topCapHeight:5];
    
    _tableBackground = [[UIView alloc] initWithFrame:CGRectMake(0, self.defaultMapHeight + 25, self.view.frame.size.width, self.view.frame.size.height)];
    
    UIView * seperatorView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 4)];
    seperatorView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"gradient5pt"]];

    
    [_tableBackground setBackgroundColor:[UIColor MMEggShell]];
    [_tableBackground addSubview:seperatorView];
    
    
    [clearView addSubview:_tableBackground];
    
    _tableView.backgroundView = clearView;
    
    [self.view addSubview:_tableView];
    
    
    
    //Create Map View
    self.defaultMapViewFrame = CGRectMake(0.0,
                                          -(self.view.frame.size.height / 2) + self.defaultMapHeight/2,
                                          self.tableView.frame.size.width,
                                          self.view.frame.size.height );
    
    _mapView = [[MKMapView alloc] initWithFrame:self.defaultMapViewFrame];
    _mapView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    _mapView.scrollEnabled = NO;
    _mapView.zoomEnabled = NO;
    _mapView.delegate = self;
    
    self.mapVisible = YES;
    
    [self.view insertSubview:self.mapView belowSubview:self.tableView];
    
    _mapTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapViewTapped:)];
    [_mapView addGestureRecognizer:_mapTapGesture];
    
    
    //Create clear headerview for table
    
    CGRect tableHeaderViewFrame = CGRectMake(0.0, 0.0, self.tableView.frame.size.width, self.defaultMapHeight);
    UIView *tableHeaderView = [[UIView alloc] initWithFrame:tableHeaderViewFrame];
    tableHeaderView.backgroundColor = [UIColor clearColor];
    [tableHeaderView addGestureRecognizer:_mapTapGesture];
    self.tableView.tableHeaderView = tableHeaderView;
    
    
    
    self.delegate = self;
    
}
-(void)mapViewTapped:(id)sender{
    [self expandMapView:sender];
}

- (void)expandMapView:(id)sender
{
    self.isMapAnimating = YES;
    
    [self.tableView.tableHeaderView removeGestureRecognizer:self.mapTapGesture];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    
    CGRect newMapFrame = self.mapView.frame;
    newMapFrame = CGRectMake(self.defaultMapViewFrame.origin.x,
                             self.defaultMapViewFrame.origin.y + (self.defaultMapHeight * self.parallaxFactor),
                             self.defaultMapViewFrame.size.width,
                             self.defaultMapHeight + (self.defaultMapHeight * self.parallaxFactor * 2));
    self.mapView.frame = newMapFrame;
    
    [self.view bringSubviewToFront:self.mapView];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.mapView.frame = self.view.bounds;
                     } completion:^(BOOL finished) {
                         
                         self.mapView.scrollEnabled = YES;
                         self.mapView.zoomEnabled = YES;
                         self.isMapFullScreen = YES;
                         self.isMapAnimating = NO;
                         
                     }];
}
- (void)closeMapView
{
    
    self.isMapAnimating = YES;
    self.mapView.scrollEnabled = NO;
    self.mapView.zoomEnabled = NO;
    [self.tableView.tableHeaderView addGestureRecognizer:self.mapTapGesture];
    
    [UIView animateWithDuration:0.3
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         CGRect newMapFrame = CGRectMake(self.mapView.frame.origin.x,
                                                         self.mapView.frame.origin.y,
                                                         self.mapView.frame.size.width,
                                                         self.defaultMapHeight + 25);
                         self.mapView.frame = newMapFrame;
                     } completion:^(BOOL finished) {
                         
                         // "Pop" the map view back in
                         self.mapView.frame = self.defaultMapViewFrame;
                         [self.view insertSubview:self.mapView belowSubview:self.tableView];
        
                         self.isMapAnimating = NO;
                         _isMapFullScreen = NO;
                         
                        
                     }];
}


#pragma mark - ScrollView Delegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
        
    CGFloat scrollOffset = scrollView.contentOffset.y;

    
    if ((self.isMapFullScreen == NO) &&
        (self.isMapAnimating == NO)) {
        
        CGFloat newMapY = self.defaultMapHeight - scrollOffset +25;
        
        if(newMapY > 0){
            
            if(!self.isMapVisible){
                self.mapVisible = YES;
                if([self.delegate respondsToSelector:@selector(mapTableViewController:didScrollOnMapView:)]){
                    [self.delegate mapTableViewController:self didScrollOnMapView:_mapView];
                }
            }
            
            
            if([self.delegate respondsToSelector:@selector(mapTableViewController:isScrollingOffScreen:visibility:)]){
                
                CGFloat visibility = newMapY / self.defaultMapHeight;
                
                [self.delegate mapTableViewController:self isScrollingOffScreen:_mapView visibility:visibility];
                
            }
            
            
            CGRect newBackgroundFrame = self.tableBackground.frame;
            newBackgroundFrame.origin.y = newMapY;
            self.tableBackground.frame = newBackgroundFrame;
        }else{
            
            
                
            if(self.isMapVisible){
                self.mapVisible = NO;
                if([self.delegate respondsToSelector:@selector(mapTableViewController:didScrollOffMapView:)]){
                    [self.delegate mapTableViewController:self didScrollOffMapView:_mapView];
                }
            }
            
            if(newMapY != 0){
                CGRect newBackgroundFrame = self.tableBackground.frame;
                newBackgroundFrame.origin.y = 0;
                self.tableBackground.frame = newBackgroundFrame;
            }
        }
        
        
        CGFloat mapFrameYAdjustment = 0.0;
        
        mapFrameYAdjustment = self.defaultMapViewFrame.origin.y - (scrollOffset * self.parallaxFactor);
        
        // Don't move the map way off-screen
        if (mapFrameYAdjustment <= -(self.defaultMapViewFrame.size.height)) {
            mapFrameYAdjustment = -(self.defaultMapViewFrame.size.height);
        }
        
        if (mapFrameYAdjustment) {
            CGRect newMapFrame = self.mapView.frame;
            newMapFrame.origin.y = mapFrameYAdjustment;
            self.mapView.frame = newMapFrame;
        }
                
    }

}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (_isMapAnimating) return;
    _isScrollDragging = NO;
    if (scrollView.contentOffset.y <= -100) {
        // Released above the header
        [self expandMapView:nil];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
