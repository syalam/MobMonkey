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
@synthesize category;

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    UIButton *customButton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 31, 31)];
    [customButton addTarget:self action:@selector(flipView:) forControlEvents:UIControlEventTouchUpInside];
    [customButton setImage:[UIImage imageNamed:@"GlobeBtn"] forState:UIControlStateNormal];
    globeButton = [[UIBarButtonItem alloc]initWithCustomView:customButton];
    
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
    
    addLocationButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    UIImage *clearButtonBg = [[UIImage imageNamed:@"navBarButtonBlank"]
                              resizableImageWithCapInsets:UIEdgeInsetsMake(0, 6, 0, 6)];
    UIButton* clearButton = [UIButton buttonWithType:UIButtonTypeCustom];
    clearButton.bounds = CGRectMake(0, 0, 50, 31);
    [clearButton setBackgroundImage:clearButtonBg forState:UIControlStateNormal];
    [clearButton setTitle:@"Clear" forState:UIControlStateNormal];
    [clearButton.titleLabel setTextColor:[UIColor whiteColor]];
    [clearButton.titleLabel setFont:[UIFont boldSystemFontOfSize:12]];
    [clearButton.titleLabel setShadowColor:[UIColor darkGrayColor]];
    [clearButton.titleLabel setShadowOffset:CGSizeMake(0, -1)];
    [clearButton addTarget:self action:@selector(clearButtonTapped:) forControlEvents:UIControlEventTouchUpInside];
    clearBarButton = [[UIBarButtonItem alloc] initWithCustomView:clearButton];
    
    
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

    tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                                  initWithTarget:self
                                                  action:@selector(handleTap:)];
  
  

/*  UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc]
                                                              initWithTarget:self action:@selector(handleLongPress:)];
  [mapView addGestureRecognizer:longPressGestureRecognizer];*/
  
    [self.navigationController.navigationBar setTintColor:[UIColor colorWithRed:226.0/255.0
                                                                          green:112.0/225.0
                                                                           blue:36.0/255.0
                                                                          alpha:1.0]];
}

- (void)setCategory:(NSDictionary *)categoryParameter
{
  category = categoryParameter;
  if (categoryParameter != nil)
    mapFilterViewController.category = categoryParameter;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!_isHistory) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addLocationButton, globeButton, nil];
    }
    else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nil, nil, nil];
        self.navigationItem.rightBarButtonItem = clearBarButton;
        if (_locations.count == 0) {
            [clearBarButton setEnabled:NO];
        }
        else {
            [clearBarButton setEnabled:YES];
        }
    }
    
    
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

#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}

/*- (void)addLocationButtonTapped:(id)sender {
    MMMapFilterViewController *mvc = [[MMMapFilterViewController alloc] init];
    mvc.title = @"Add Location";
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:mvc];
    [self.navigationController presentViewController:navc animated:YES completion:nil];
}*/

- (void)flipView:(id)sender
{
    if ([self.mapView isHidden]) {
        [UIView transitionFromView:self.tableView toView:self.mapView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromLeft | UIViewAnimationOptionShowHideTransitionViews completion:nil];
        [sender setTitle:@"List"];
        return;
    }
    else {
        [overlayImageView setHidden:YES];
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addLocationButton, globeButton, nil];
    }
    [UIView transitionFromView:self.mapView toView:self.tableView duration:0.4 options:UIViewAnimationOptionTransitionFlipFromRight | UIViewAnimationOptionShowHideTransitionViews completion:nil];
    [sender setTitle:@"Map"];
}

- (void)addLocationButtonTapped:(id)sender {
    if ([self.mapView isHidden]) {
        MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithNibName:@"MMAddLocationViewController" bundle:nil];
        addLocationViewController.title = @"Add Location";
        addLocationViewController.category = self.category;
        UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
        [self.navigationController presentViewController:navc animated:YES completion:nil];
    }
    else {
        [SVProgressHUD showSuccessWithStatus:@"Tap on the location you'd like to add on the map"];
        [overlayImageView setHidden:NO];
        [mapView addGestureRecognizer:tapGestureRecognizer];
        [mapView setScrollEnabled:NO];
        [mapView setZoomEnabled:NO];
        
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:cancelButton, globeButton, nil];
    }
}

- (void)cancelButtonTapped:(id)sender {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addLocationButton, globeButton, nil];
    [overlayImageView setHidden:YES];
    [mapView setScrollEnabled:YES];
    [mapView setZoomEnabled:YES];
    [mapView removeGestureRecognizer:tapGestureRecognizer];
}

- (void)setLocations:(NSMutableArray *)locations
{
    _locations = locations;
    [self.tableView reloadData];
    [self reloadMapView];
}

- (void)clearButtonTapped:(id)sender {
    UIAlertView *clearHistoryAlert = [[UIAlertView alloc]initWithTitle:@"Clear your history" message:@"Are you sure you want to clear you recently viewed results?" delegate:self cancelButtonTitle:@"No" otherButtonTitles:@"Yes", nil];
    [clearHistoryAlert show];

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
        if (!self.isHistory) {
            NSMutableArray *searchHistory;
            if ([[NSUserDefaults standardUserDefaults]valueForKey:@"history"]) {
                searchHistory = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:@"history"];
            }
            else {
                searchHistory = [[NSMutableArray alloc]init];
            }
            NSMutableDictionary *locationDictionary = [[_locations objectAtIndex:indexPath.row] mutableCopy];
            [locationDictionary removeObjectForKey:@"requests"];
            [locationDictionary removeObjectsForKeys:[NSArray arrayWithObjects:@"requests", @"radiusInYards", nil]];
            NSDictionary *locationDictionary2 = [[NSDictionary alloc]initWithDictionary:locationDictionary];
            if (![searchHistory containsObject:locationDictionary2]) {
                NSMutableDictionary *locationDictionary = [[_locations objectAtIndex:indexPath.row] mutableCopy];
                [locationDictionary removeObjectForKey:@"requests"];
                [locationDictionary removeObjectsForKeys:[NSArray arrayWithObjects:@"requests", @"radiusInYards", nil]];
                [searchHistory addObject:locationDictionary];
                [[NSUserDefaults standardUserDefaults]setValue:searchHistory forKey:@"history"];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:@"history"]);
            }
            
        }
        NSString *locationId = [[_locations objectAtIndex:indexPath.row]valueForKey:@"locationId"];
        NSString *providerId = [[_locations objectAtIndex:indexPath.row]valueForKey:@"providerId"];
        
        MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
        [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
        [self.navigationController pushViewController:locationViewController animated:YES];
    }
    else {
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

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
  // TODO / FIXME - DRY this (duplicated in MMMapFilterViewController)
  CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
  CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
  
  MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
  addLocationViewController.title =@"Add Location";
  addLocationViewController.category = self.category; // case in point for DRY - wasted almost an hour before realizing this is here and not in the MMAddLocationViewController..
  UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
  [self.navigationController presentViewController:navc animated:YES completion:nil];
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

#pragma mark - UIAlertView Delegate Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:@"history"];
            [_locations removeAllObjects];
            [_tableView reloadData];
            [clearBarButton setEnabled:NO];
            break;
            
        default:
            break;
    }
}

@end
