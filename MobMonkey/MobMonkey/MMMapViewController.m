//
//  MMMapViewController.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 7/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MMMapViewController.h"
#import <MapKit/MapKit.h>
#import "MMLocationAnnotation.h"
#import "MMSetTitleImage.h"
#import "MMClientSDK.h"
#import "MMLocationViewController.h"

@interface MMMapViewController ()

@property (nonatomic, assign, getter = isSelectingLocation) BOOL selectingLocation;

@end

@implementation MMMapViewController
@synthesize searchBar;
@synthesize selectingLocation;
@synthesize locationInformationCollection = _locationInformationCollection;


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
    self.title = @"Search";
    
    self.navigationItem.titleView = [[MMSetTitleImage alloc]setTitleImageView];
    
    radiusPickerItemsArray = [[NSMutableArray alloc]initWithObjects:@"5 blocks", @"1 mile", @"5 miles", @"10 miles", nil];
    
    if (_contentList) {
        for (int i = 0; i < _contentList.count; i++) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [[[_contentList objectAtIndex:i]valueForKey:@"latitude"]floatValue];
            coordinate.longitude = [[[_contentList objectAtIndex:i]valueForKey:@"longitude"]floatValue];
            MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc]initWithName:[[_contentList objectAtIndex:i]valueForKey:@"name"]address:[[_contentList objectAtIndex:i]valueForKey:@"streetAddress"] coordinate:coordinate arrayIndex:i];
            [_mapView addAnnotation:(id)annotation];
        }
        
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in _mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        [_mapView setVisibleMapRect:zoomRect animated:YES];
    } else if(self.locationInformationCollection) {
        for (MMLocationInformation *locationInformation in self.locationInformationCollection) {
            
            NSUInteger index = [self.locationInformationCollection indexOfObject:locationInformation];
            
            CLLocationCoordinate2D coordinate;
            
            coordinate.latitude = locationInformation.latitude.floatValue;
            coordinate.longitude = locationInformation.longitude.floatValue;
            
            MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc]initWithName:locationInformation.name
                                                                                 address:locationInformation.formattedAddressString
                                                                              coordinate:coordinate
                                                                              arrayIndex:index];
            
            [_mapView addAnnotation:(id)annotation];
        }
        
        MKMapRect zoomRect = MKMapRectNull;
        for (id <MKAnnotation> annotation in _mapView.annotations)
        {
            MKMapPoint annotationPoint = MKMapPointForCoordinate(annotation.coordinate);
            MKMapRect pointRect = MKMapRectMake(annotationPoint.x, annotationPoint.y, 0.1, 0.1);
            if (MKMapRectIsNull(zoomRect)) {
                zoomRect = pointRect;
            } else {
                zoomRect = MKMapRectUnion(zoomRect, pointRect);
            }
        }
        [_mapView setVisibleMapRect:zoomRect animated:YES];
    }
    
    
    //TODO: RE-ADD SEARCH BAR
    
    //TEMPORARILY REMOVE ME
    /*UIButton *searchNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchNavButton setFrame:CGRectMake(0, 0, 60, 30)];
    [searchNavButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchNavButton setBackgroundImage:[UIImage imageNamed:@"NavSearchBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchNavButton];
    self.navigationItem.rightBarButtonItem = searchButton;*/
    
    
    //Create add location button
    UIButton *plusButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [plusButton setFrame:CGRectMake(0, 0, 31, 31)];
    [plusButton setBackgroundImage:[UIImage imageNamed:@"navBarButtonBlank"] forState:UIControlStateNormal];
    [plusButton addTarget:self action:@selector(addLocationBarButtonTapped:)
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
    
    addLocationBarButton = [[UIBarButtonItem alloc] initWithCustomView:plusButton];
    
    //Create Cancel button
    //cancel nav button
    UIButton *cancelNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelNavButton  setFrame:CGRectMake(0, 0, 50, 31)];
    [cancelNavButton setBackgroundImage:[UIImage imageNamed:@"navBarButtonBlank"] forState:UIControlStateNormal];
    [cancelNavButton addTarget:self action:@selector(cancelBarButtonTapped:)
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
    
    cancelBarButton = [[UIBarButtonItem alloc]initWithCustomView:cancelNavButton];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self.navigationController action:@selector(popViewControllerAnimated:) forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    mapTapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    
    [_mapView showsUserLocation];
    prefs = [NSUserDefaults standardUserDefaults];
    _mapRadius = 10000; //set a default radius in case user doesnt select anything;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
    
    self.selectingLocation = NO;
    
    /*if (_address) {
        CLLocationCoordinate2D addressCoordinate = [self getLocationFromAddressString:_address];
        MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc]initWithName:nil address:_address coordinate:addressCoordinate];
        
        MKCoordinateRegion region;
        MKCoordinateSpan span;
        
        span.latitudeDelta = 0.025;
        span.longitudeDelta  = 0.025;
        
        region.span = span;
        region.center = addressCoordinate;
        NSLog(@"Latitude:%f, Longitude:%f", addressCoordinate.latitude, addressCoordinate.longitude);
     
        [_mapView addAnnotation:(id)annotation];
        
        [_mapView setRegion:region animated:YES];
        [_mapView regionThatFits:region];
    }*/
    
    //DEMO CODE. REMOVE ME
    [addLocationButton setHidden:YES];
    [radiusButton setHidden:YES];
}



- (void)viewDidUnload
{
    [self setMapView:nil];
    [self setSearchBar:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [SVProgressHUD dismiss];
    [self toggleBarButtons];
    //add nav bar view and button
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void)toggleBarButtons {
    
    if(self.isSelectingLocation){
        self.navigationItem.rightBarButtonItem = cancelBarButton;
    }else{
        self.navigationItem.rightBarButtonItem = addLocationBarButton;
    }
    
}
#pragma mark - Nav Bar Button Action Methods
- (void)searchButtonClicked:(id)sender {
    [self.searchBar resignFirstResponder];
}

- (void)cancelButtonClicked:(id)sender {
    if (_address) {
        [self.navigationController popViewControllerAnimated:YES];
    }
    else {
        [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    }
}


#pragma mark - IBAction Methods
- (IBAction)radiusButtonClicked:(id)sender {
    radiusActionSheet = [[UIActionSheet alloc] init];
    [radiusActionSheet setActionSheetStyle:UIActionSheetStyleBlackTranslucent];
    UISegmentedControl *closeButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Choose"]];
    closeButton.momentary = YES; 
    closeButton.frame = CGRectMake(260, 7.0f, 50.0f, 30.0f);
    closeButton.segmentedControlStyle = UISegmentedControlStyleBar;
    closeButton.tintColor = [UIColor blackColor];
    closeButton.tag = 1;
    [closeButton addTarget:self action:@selector(chooseButtonClicked:) forControlEvents:UIControlEventValueChanged];
    [radiusActionSheet addSubview:closeButton];
    
    UISegmentedControl *cancelButton = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObject:@"Cancel"]];
    cancelButton.momentary = YES; 
    cancelButton.frame = CGRectMake(10.0f, 7.0f, 50.0f, 30.0f);
    cancelButton.segmentedControlStyle = UISegmentedControlStyleBar;
    cancelButton.tintColor = [UIColor blackColor];
    cancelButton.tag = 1;
    [cancelButton addTarget:self action:@selector(cancelActionSheet:) forControlEvents:UIControlEventValueChanged];
    [radiusActionSheet addSubview:cancelButton];
    
    CGRect pickerFrame = CGRectMake(0, 40, 0, 0);
    radiusPicker = [[UIPickerView alloc]initWithFrame:pickerFrame];
    [radiusPicker setShowsSelectionIndicator:YES];
    radiusPicker.delegate = self;
    radiusPicker.dataSource = self;
    
    [radiusActionSheet addSubview:radiusPicker];
    [radiusActionSheet showInView:self.view];        
    [radiusActionSheet setBounds:CGRectMake(0,0,320, 500)];
    
    [radiusPicker selectRow:0 inComponent:0 animated:NO];
}

- (IBAction)addLocationButtonClicked:(id)sender {
    
}


#pragma mark - Radius Action Sheet Button Action Methods
- (void)chooseButtonClicked:(id)sender {
    [radiusActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

- (void)cancelActionSheet:(id)sender {
    [radiusActionSheet dismissWithClickedButtonIndex:0 animated:YES];
}

-(void)cancelBarButtonTapped:(id)sender {
    self.selectingLocation = NO;
    [self toggleBarButtons];
    [self.mapView removeGestureRecognizer:mapTapGestureRecognizer];
    [self.mapView setScrollEnabled:YES];
    [self.mapView setZoomEnabled:YES];
    [overlayImageView setHidden:YES];
}
-(void)addLocationBarButtonTapped:(id)sender {
    self.selectingLocation = YES;
    [self toggleBarButtons];
    [self.mapView addGestureRecognizer:mapTapGestureRecognizer];
    [SVProgressHUD showSuccessWithStatus:@"Tap on the location you'd like to add on the map"];
    [overlayImageView setHidden:NO];
    [self.mapView setScrollEnabled:NO];
    [self.mapView setZoomEnabled:NO];
}

#pragma mark UIPickerView Delegate Methods
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView;
{
    return 1;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    switch (row) {
        case 0:
            _mapRadius = 10.0;
            break;
        case 1:
            _mapRadius = 1609.0;
            break;
        case 2:
            _mapRadius = 8046.0;
            break;
        case 3:
            _mapRadius = 16093.0;
            break;
        default:
            break;
    }
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component;
{
    return [radiusPickerItemsArray count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component;
{
    return [radiusPickerItemsArray objectAtIndex:row];
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

- (void)handleLongPress:(UIGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state != UIGestureRecognizerStateBegan)
        return;
    
    //Clear existing annotations
    for (id<MKAnnotation> annotation in self.mapView.annotations) {
        [self.mapView removeAnnotation:annotation];
    }
    
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];   
    CLLocationCoordinate2D touchMapCoordinate = 
    [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc] init];
    annotation.coordinate = touchMapCoordinate;
    [self.mapView addAnnotation:(id)annotation];
}
- (void)mapTapped:(UIGestureRecognizer *)gestureRecognizer
{
    // TODO / FIXME - DRY this (duplicated in MMMapFilterViewController)
    CGPoint touchPoint = [gestureRecognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
    addLocationViewController.title =@"Add Location";
    //addLocationViewController.category = self.category; // case in point for DRY - wasted almost an hour before realizing this is here and not in the MMAddLocationViewController..
    addLocationViewController.delegate = self;
    UINavigationController *navc = [[UINavigationController alloc]initWithRootViewController:addLocationViewController];
    [self.navigationController presentViewController:navc animated:YES completion:nil];
}
- (void)infoButtonTapped:(id)sender {
    [[MMClientSDK sharedSDK]locationScreen:self locationDetail:[_contentList objectAtIndex:[sender tag]]];
}

#pragma mark - UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}

#pragma mark - Helper Methods
-(CLLocationCoordinate2D) getLocationFromAddressString:(NSString*) addressStr {
    NSString *urlStr = [NSString stringWithFormat:@"http://maps.google.com/maps/geo?q=%@&output=csv",
                        [addressStr stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSString *locationStr =  [NSString stringWithContentsOfURL:[NSURL URLWithString:urlStr] encoding:NSUTF8StringEncoding error:nil];
    NSArray *items = [locationStr componentsSeparatedByString:@","];
    
    double lat = 0.0;
    double longitude = 0.0;
    
    if([items count] >= 4 && [[items objectAtIndex:0] isEqualToString:@"200"]) {
        lat = [[items objectAtIndex:2] doubleValue];
        longitude = [[items objectAtIndex:3] doubleValue];
    }
    else {
        NSLog(@"Address, %@ not found: Error %@",addressStr, [items objectAtIndex:0]);
    }
    CLLocationCoordinate2D location;
    location.latitude = lat;
    location.longitude = longitude;
    
    return location;
}

#pragma mark - AddLocationViewController Delegate
-(void)locationAddedViaAddLocationViewWithLocationId:(NSString *)locationId providerId:(NSString *)providerId{
    
    UINavigationController *nav = self.navigationController;
    
    [nav popToRootViewControllerAnimated:NO];
    
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    locationViewController.locationID = locationId;
    locationViewController.providerID = providerId;
    locationViewController.title = @"Loading...";
    
    [nav pushViewController:locationViewController animated:YES];

    
}
@end
