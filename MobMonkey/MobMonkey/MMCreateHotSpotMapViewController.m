//
//  MMCreateHotSpotMapViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/5/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMCreateHotSpotMapViewController.h"
#import "UIBarButtonItem+NoBorder.h"
#import "MMEditHotSpotViewController.h"

@interface MMCreateHotSpotMapViewController ()

@property (nonatomic, assign) CLLocationCoordinate2D selectedCoordinates;

@end

@implementation MMCreateHotSpotMapViewController

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
    
    self.title = @"Create Hot Spot";
    //Add backbutton
    UIBarButtonItem *menuItem = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"whiteBackButton"] selectedImage:nil target:self.navigationController action:@selector(popViewControllerAnimated:)];
    self.navigationItem.leftBarButtonItem = menuItem;

    
    self.navigationController.navigationBar.translucent = YES;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    
    [self.view addSubview:_mapView];
    
    _hotSpotActionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [_hotSpotActionButton addTarget:self action:@selector(selectHotSpotTapped:) forControlEvents:UIControlEventTouchUpInside];
    _hotSpotActionButton.frame = CGRectMake((self.view.frame.size.width - 280)/2, self.view.frame.size.height - 100 - 25, 280, 50);
    [self.view addSubview:_hotSpotActionButton];
    [_hotSpotActionButton setTitle:@"Select Hot Spot" forState:UIControlStateNormal];
    
    
    hotSpotAnnotation = [[MKPointAnnotation alloc] init];
    [self.mapView addAnnotation:hotSpotAnnotation];
    
    MKAnnotationView *view = [_mapView viewForAnnotation:hotSpotAnnotation];
    
    view.image = [UIImage imageNamed:@"pinFlame"];
    view.centerOffset = CGPointMake(-8, 6);
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    
    [_mapView addGestureRecognizer:tapGesture];
	// Do any additional setup after loading the view.
}
-(void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.translucent = NO;
}
-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    
    [self zoomToParentLocation];
}
-(void)selectHotSpotTapped:(id)sender{
    MMEditHotSpotViewController * editHotSpotViewController = [[MMEditHotSpotViewController alloc] initWithStyle:UITableViewStyleGrouped];
    editHotSpotViewController.sublocationCoordinates = _selectedCoordinates;
    editHotSpotViewController.parentLocation = self.parentLocationInformation;
    [self.navigationController pushViewController:editHotSpotViewController animated:YES];
}
-(void)zoomToParentLocation {
    self.mapView.centerCoordinate = CLLocationCoordinate2DMake(_parentLocationInformation.latitude.doubleValue, _parentLocationInformation.longitude.doubleValue);
    
    MKPointAnnotation *annotation = [[MKPointAnnotation alloc] init];
    [annotation setCoordinate:self.mapView.centerCoordinate];
    [annotation setTitle:_parentLocationInformation.name]; //You can set the subtitle too
    [self.mapView addAnnotation:annotation];
    
    MKCoordinateRegion region;
    MKCoordinateSpan span;
    span.latitudeDelta = 0.1;
    span.longitudeDelta= 0.1;
    
    region.span=span;
    region.center =self.mapView.centerCoordinate;     // to locate to the center
    [self.mapView setRegion:region animated:NO];
    
    span.latitudeDelta = 0.003;
    span.longitudeDelta= 0.003;
    
    region.span=span;
    
    [self.mapView setRegion:region animated:YES];
    [self.mapView regionThatFits:region];
}
-(void)mapTapped:(UITapGestureRecognizer*)sender{
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    _selectedCoordinates = touchMapCoordinate;
    
    [hotSpotAnnotation setCoordinate:touchMapCoordinate];
    
    [_mapView setCenterCoordinate:touchMapCoordinate animated:YES];
    
    

}
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark - Map View Delegate

@end
