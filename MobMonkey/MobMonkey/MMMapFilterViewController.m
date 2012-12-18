//
//  MMMapFilterViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMMapFilterViewController.h"
#import "MMAddLocationViewController.h"

@interface MMMapFilterViewController ()

@end

@implementation MMMapFilterViewController
@synthesize mapView;

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

  [mapView setShowsUserLocation:YES];

  locationManager = [[CLLocationManager alloc] init];
  locationManager.delegate = self;
  [locationManager startMonitoringSignificantLocationChanges];
  
  [mapView setUserInteractionEnabled:YES];

  UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
  [backNavbutton addTarget:self action:@selector(backButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
  [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                           forState:UIControlStateNormal];
  
  UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
  self.navigationItem.leftBarButtonItem = backButton;

  // uncomment these to disable user interaction for map
  //mapView.scrollEnabled = NO;
  //mapView.zoomEnabled = NO;
  
  mapView.delegate = self;
  
  // add gesture recognizer
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleTap:)];

  [mapView addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
  CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
  CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
  
  MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
  addLocationViewController.title = @"Add Location";
  UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
  [self.navigationController presentViewController:navc animated:YES completion:nil];
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

@end
