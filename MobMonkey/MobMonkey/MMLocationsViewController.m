//
//  MMLocationsViewController.m
//  MobMonkey
//
//  Created by Dan Brajkovic on 10/16/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMLocationsViewController.h"
#import "MMLocationListCell.h"
#import "MMLocationAnnotation.h"

@interface MMLocationsViewController ()

- (void)flipView:(id)sender;
- (void)reloadMapView;
- (void)infoButtonTapped:(id)sender;

@end

@implementation MMLocationsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIBarButtonItem *flipViewButton = [[UIBarButtonItem alloc] initWithTitle:@"Map"
                                                                       style:UIBarButtonItemStyleBordered
                                                                      target:self
                                                                      action:@selector(flipView:)];
    self.navigationItem.rightBarButtonItem = flipViewButton;
    self.locations = @[];
    self.mapView.showsUserLocation = YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if (self.isSearching) {
        [SVProgressHUD showWithStatus:@"Searching"];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SVProgressHUD dismiss];
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

- (void)setLocations:(NSArray *)locations
{
    _locations = locations;
    [self.tableView reloadData];
    [self reloadMapView];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.locations.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    cell.location = [self.locations objectAtIndex:indexPath.section];
    
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
     [[MMClientSDK sharedSDK] locationScreen:self locationDetail:[[self.locations objectAtIndex:indexPath.section] mutableCopy]];
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
        CLLocationCoordinate2D coordinate;
        coordinate.latitude = [[location valueForKey:@"latitude"] floatValue];
        coordinate.longitude = [[location valueForKey:@"longitude"] floatValue];
        MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc] initWithName:[location valueForKey:@"name"] address:[location valueForKey:@"streetAddress"] coordinate:coordinate arrayIndex:[self.locations indexOfObject:location]];
        [self.mapView addAnnotation:(id)annotation];
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

@end
