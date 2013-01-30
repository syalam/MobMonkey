//
//  MMMapFilterViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMMapFilterViewController.h"


@interface MMMapFilterViewController ()

@end

@implementation MMMapFilterViewController
@synthesize mapView;
@synthesize contentList;
@synthesize category;

- (id)init
{
    self = [super initWithNibName:@"MMMapFilterViewController" bundle:nil];
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

- (id)initWithMapView:(MKMapView *)mapViewParameter
{
    self = [super init];
    if (self) {
        self.mapView = mapViewParameter;
        self.view = mapView;
        [self viewDidLoad];
    }
    
    return self;
}

- (void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation
{
    [mapView setCenterCoordinate:newLocation.coordinate];
    if ([mapView showsUserLocation] == NO) {
        [mapView setShowsUserLocation:YES];
    }
    
    MKCoordinateRegion mapRegion;
    mapRegion.center = newLocation.coordinate;
    
    // TODO / FIXME - hard-coded constant (0.01º)
    mapRegion.span.latitudeDelta = 0.01;
    mapRegion.span.longitudeDelta = 0.01;
    
    [mapView setRegion:mapRegion animated: YES];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error
{
    NSLog(@"locationManager error: %@", error);
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [mapView setUserInteractionEnabled:YES];
    
    [mapView setUserTrackingMode:MKUserTrackingModeFollow animated:YES];
    [mapView setShowsUserLocation:YES];
    CLLocationCoordinate2D coordinate;
    if (mapView.userLocation.coordinate.latitude > .000001) {
        coordinate = mapView.userLocation.coordinate;
    }
    MKCoordinateRegion region;
    region.center = coordinate;
    region.span.latitudeDelta = 0.03;
    region.span.longitudeDelta = 0.03;
    [mapView setRegion:region animated:YES];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                             forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setFrame:CGRectMake(0, 0, 31, 31)];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"navBarButtonBlank"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(addLocationButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *plusButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -3, plusButton.frame.size.width, plusButton.frame.size.height)];
    [plusButtonLabel setBackgroundColor:[UIColor clearColor]];
    [plusButtonLabel setText:@"+"];
    [plusButtonLabel setTextColor:[UIColor whiteColor]];
    [plusButtonLabel setShadowColor:[UIColor darkGrayColor]];
    [plusButtonLabel setShadowOffset:CGSizeMake(0, -1)];
    [plusButtonLabel setFont:[UIFont boldSystemFontOfSize:24]];
    [plusButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [plusButton addSubview:plusButtonLabel];
    
    addButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    self.navigationItem.rightBarButtonItem = addButton;
    
    //cancel nav button
    UIButton *cancelNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelNavButton  setFrame:CGRectMake(0, 0, 50, 31)];
    [cancelNavButton setBackgroundImage:[UIImage imageNamed:@"navBarButtonBlank"] forState:UIControlStateNormal];
    [cancelNavButton addTarget:self action:@selector(cancelButtonTapped:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *cancelButtonLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, -1, cancelNavButton.frame.size.width, cancelNavButton.frame.size.height)];
    [cancelButtonLabel setBackgroundColor:[UIColor clearColor]];
    [cancelButtonLabel setText:@"Cancel"];
    [cancelButtonLabel setTextColor:[UIColor whiteColor]];
    [cancelButtonLabel setShadowColor:[UIColor darkGrayColor]];
    [cancelButtonLabel setShadowOffset:CGSizeMake(0, -1)];
    [cancelButtonLabel setFont:[UIFont boldSystemFontOfSize:11]];
    [cancelButtonLabel setTextAlignment:NSTextAlignmentCenter];
    [cancelNavButton addSubview:cancelButtonLabel];
    
    cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelNavButton];
    
    // comment these to enable user interaction for map
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    
    mapView.delegate = self;
    
    // add gesture recognizer
    tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                    initWithTarget:self
                                                    action:@selector(handleTap:)];
    
    //[mapView addGestureRecognizer:tapGestureRecognizer];
    
    
    /*  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
     initWithTarget:self action:@selector(handleLongPress:)];
     [mapView addGestureRecognizer:longPressGestureRecognizer];*/
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
    addLocationViewController.title = @"Add Location";
    addLocationViewController.category = self.category;
    addLocationViewController.delegate = self;
    [self.navigationController pushViewController:addLocationViewController animated:YES];
    //UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
    //[self.navigationController presentViewController:navc animated:YES completion:nil];
}

#pragma mark - UIBarButtonItem Action Methods
- (void)backButtonTapped:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Tap Methods
- (void)addLocationButtonTapped:(id)sender {
    mapView.scrollEnabled = NO;
    mapView.zoomEnabled = NO;
    
    [SVProgressHUD showSuccessWithStatus:@"Tap on the location you'd like to add on the map"];
    
    [overlayImageView setHidden:NO];
    [mapView addGestureRecognizer:tapGestureRecognizer];
    
    self.navigationItem.rightBarButtonItem = cancelButton;
}

- (void)cancelButtonTapped:(id)sender {
    mapView.scrollEnabled = YES;
    mapView.zoomEnabled = YES;
    
    [overlayImageView setHidden:YES];
    
    [mapView removeGestureRecognizer:tapGestureRecognizer];
    self.navigationItem.rightBarButtonItem = addButton;
}

#pragma mark - AddLocationDelegate
- (void)locationAddedViaAddLocationViewWithLocationId:(NSString*)locationId providerId:(NSString*)providerId {
    [_delegate locationAddedViaMapViewWithLocationID:locationId providerId:providerId];
}

@end
