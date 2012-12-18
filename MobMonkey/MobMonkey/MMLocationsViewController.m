//
//  MMLocationsViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationsViewController.h"
#import "MMLocationViewController.h"
#import "MMLocationListCell.h"
#import "MMLocationAnnotation.h"
#import "MMMapFilterViewController.h"
#import "MMAddLocationViewController.h"

@interface MMLocationsViewController ()

- (void)flipView:(id)sender;
- (void)reloadMapView;
- (void)infoButtonTapped:(id)sender;

@end

@implementation MMLocationsViewController
@synthesize mapView;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    UIButton *customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 33, 30)];
    [customButton addTarget:self action:@selector(flipView:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"GlobeBtn"] forState:UIControlStateNormal];
    UIBarButtonItem* flipViewButton = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    self.navigationItem.rightBarButtonItem = flipViewButton;
    
    if ([self.navigationController viewControllers].count > 1) {
        UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
        [backNavbutton addTarget:self action:@selector(backButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
        
        UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
        self.navigationItem.leftBarButtonItem = backButton;
    }
    
    self.locations = [NSMutableArray array];
  mapFilterViewController = [[MMMapFilterViewController alloc] initWithMapView:mapView];
  mapView.delegate = self;
/*  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleTap:)];
  
  [mapView addGestureRecognizer:tapGestureRecognizer];*/

  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                              initWithTarget:self action:@selector(handleLongPress)];
  [mapView addGestureRecognizer:longPressGestureRecognizer];
  
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:226.0/255.0
                                                                          green:112.0/225.0
                                                                           blue:36.0/255.0
                                                                          alpha:1.0]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (![[NSUserDefaults standardUserDefaults]objectForKey:@"userName"]) {
        [[MMClientSDK sharedSDK]signInScreen:self];
    }
    else if (self.isSearching) {
        [SVProgressHUD showWithStatus:@"Searching"];
    }
    else {
        [SVProgressHUD dismiss];
    }
    [self.tableView reloadData];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    //[SVProgressHUD dismiss];
}

- (void)flipView:(id)sender
{
    if ([self.mapView isHidden]) {
        [UIView transitionFromView:self.tableView toView:self.mapView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews completion:nil];
        [sender setTitle:@"List"];
        return;
    }
    [UIView transitionFromView:self.mapView toView:self.tableView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews completion:nil];
    [sender setTitle:@"Map"];
}

- (void)setLocations:(NSMutableArray *)locations
{
    _locations = locations;
    [self.tableView reloadData];
    [self reloadMapView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.locations.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setLocation:[self.locations objectAtIndex:indexPath.row]];
    //cell.location = [self.locations objectAtIndex:indexPath.row];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (![[[_locations objectAtIndex:indexPath.row]valueForKey:@"locationId"] isKindOfClass:[NSNull class]] && ![[[_locations objectAtIndex:indexPath.row]valueForKey:@"providerId"]isKindOfClass:[NSNull class]]) {
        NSString *locationId = [[_locations objectAtIndex:indexPath.row]valueForKey:@"locationId"];
        NSString *providerId = [[_locations objectAtIndex:indexPath.row]valueForKey:@"providerId"];
        
        MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
        [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
        [self.navigationController pushViewController:locationViewController animated:YES];
    }
    else {
        [SVProgressHUD show];
        [SVProgressHUD showErrorWithStatus:@"Unable to load this location"];
    }
}

- (void)viewDidUnload {
    [self setTableView:nil];
    [self setMapView:nil];
    [super viewDidUnload];
}

#pragma mark - Manage map view

- (void)reloadMapView
{
    [self.mapView removeAnnotations:self.mapView.annotations];
    for (NSMutableDictionary *location in self.locations) {
        if (![[location valueForKey:@"latitude"]isKindOfClass:[NSNull class]] && ![[location valueForKey:@"longitude"]isKindOfClass:[NSNull class]]) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[location valueForKey:@"latitude"] floatValue];
            coordinate.longitude = [[location valueForKey:@"longitude"] floatValue];
            MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc] initWithName:[location valueForKey:@"name"] address:[location valueForKey:@"address"] coordinate:coordinate arrayIndex:[self.locations indexOfObject:location]];
            [self.mapView addAnnotation:(id)annotation];
        }
    }
    
    MKMapRect zoomRect = MKMapRectNull;
    for (id <MKAnnotation> annotation in self.mapView.annotations)
    {
        MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
        MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
        if (MKMapRectIsNull(zoomRect)) {
            zoomRect = pointRect;
        } else {
            zoomRect = MKMapRectUnion(zoomRect, pointRect);
        }
    }
    [self.mapView setVisibleMapRect:zoomRect animated:YES];
}

- (void)infoButtonTapped:(id)sender {
    [[MMClientSDK sharedSDK] locationScreen:self locationDetail:[self.locations objectAtIndex:[sender tag]]];
}

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
  // TODO / FIXME - DRY this (duplicated in MMMapFilterViewController)
  CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
  CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
  
  MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
  addLocationViewController.title = @"Add Location";
  UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
  [self.navigationController presentViewController:navc animated:YES completion:nil];}


#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - MapView Delegate Methods
- (MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id <MKAnnotation>)annotation {
    static NSString *identifier = @"MMLocation";
    if ([annotation isKindOfClass:[MMLocationAnnotation class]]) {
        MMLocationAnnotation *myAnnotation = (MMLocationAnnotation*)annotation;
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.animatesDrop = YES;
            
        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        UIButton *infoButton = [UIButton buttonWithType:UIButtonTypeDetailDisclosure];
        infoButton.tag = [myAnnotation arrayIndex];
        
        [infoButton addTarget:self action:@selector(infoButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
        annotationView.rightCalloutAccessoryView = infoButton;
        
        
        return annotationView;
    }
    
    return nil;
}

#pragma mark - UIAlertView Delegate Method
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
