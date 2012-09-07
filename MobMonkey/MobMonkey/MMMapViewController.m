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

@interface MMMapViewController ()

@end

@implementation MMMapViewController
@synthesize mapView;
@synthesize searchBar;

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
    
    UIButton *searchNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchNavButton setFrame:CGRectMake(0, 0, 60, 30)];
    [searchNavButton addTarget:self action:@selector(searchButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [searchNavButton setBackgroundImage:[UIImage imageNamed:@"NavSearchBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem *searchButton = [[UIBarButtonItem alloc]initWithCustomView:searchNavButton];
    self.navigationItem.rightBarButtonItem = searchButton;
    
    UIButton *cancelNavButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelNavButton setFrame:CGRectMake(0, 0, 60, 30)];
    [cancelNavButton addTarget:self action:@selector(cancelButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [cancelNavButton setImage:[UIImage imageNamed:@"NavCancelBtn~iphone"] forState:UIControlStateNormal];
    
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithCustomView:cancelNavButton];
    self.navigationItem.leftBarButtonItem = cancelButton;
    
    [self.mapView setUserTrackingMode:MKUserTrackingModeFollowWithHeading animated:YES];
    prefs = [NSUserDefaults standardUserDefaults];
    _mapRadius = 10000; //set a default radius in case user doesnt select anything;
    
    UILongPressGestureRecognizer *lpgr = [[UILongPressGestureRecognizer alloc] 
                                          initWithTarget:self action:@selector(handleLongPress:)];
    lpgr.minimumPressDuration = 2.0; //user needs to press for 2 seconds
    [self.mapView addGestureRecognizer:lpgr];
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
    
    //add nav bar view and button
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Nav Bar Button Action Methods
- (void)searchButtonClicked:(id)sender {
    [self.searchBar resignFirstResponder];
}

- (void)cancelButtonClicked:(id)sender {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
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
        
        MKPinAnnotationView *annotationView = (MKPinAnnotationView *) [self.mapView dequeueReusableAnnotationViewWithIdentifier:identifier];
        if (annotationView == nil) {
            annotationView = [[MKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:identifier];
            annotationView.animatesDrop = YES; 

        } else {
            annotationView.annotation = annotation;
        }
        
        annotationView.enabled = YES;
        annotationView.canShowCallout = YES;
        
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

#pragma mark - UISearchBar Delegate Methods
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [self.searchBar resignFirstResponder];
}
@end