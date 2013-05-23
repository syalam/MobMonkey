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
#import "MMLocationSearch.h"
#import "UIBarButtonItem+NoBorder.h"


@interface MMLocationsViewController ()

@property (nonatomic, strong) UIBarButtonItem * radius5mileButton;
@property (nonatomic, strong) UIBarButtonItem * radius10mileButton;
@property (nonatomic, strong) UIBarButtonItem * radius20mileButton;

@property (nonatomic, strong) UIColor *itemNormalTint;
@property (nonatomic, strong) UIColor *itemSelectedTint;




- (void)flipView:(id)sender;
- (void)reloadMapView;
- (void)infoButtonTapped:(id)sender;

@end

@implementation MMLocationsViewController
@synthesize mapView;
@synthesize category;
@synthesize radius5mileButton, radius10mileButton, radius20mileButton, itemNormalTint, itemSelectedTint, radiusToolbar;

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.itemSelectedTint = [UIColor colorWithRed:0.934 green:0.480 blue:0.200 alpha:1.000];
    self.itemNormalTint = [UIColor colorWithRed:1.000 green:0.558 blue:0.286 alpha:1.000];
    
    
    
    [[NSUserDefaults standardUserDefaults] setObject:@8800 forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //Set up radius Toolbar
    
    radiusToolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
        
    radiusToolbar.tintColor = self.itemNormalTint;
    
    UILabel *radiusLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 80, 20)];
    radiusLabel.backgroundColor = [UIColor clearColor];
    radiusLabel.textColor = [UIColor whiteColor];
    radiusLabel.text = @"Radius:";
    
    UIBarButtonItem *radiusText = [[UIBarButtonItem alloc] initWithCustomView:radiusLabel];
    
    radius5mileButton = [[UIBarButtonItem alloc] initWithTitle:@"5" style:UIBarButtonItemStyleBordered target:self action:@selector(radiusButtonPressed:)];
    radius5mileButton.width = 44;
    radius5mileButton.tag = 5;
    radius5mileButton.tintColor = self.itemSelectedTint;
    
    radius10mileButton = [[UIBarButtonItem alloc] initWithTitle:@"10" style:UIBarButtonItemStyleBordered target:self action:@selector(radiusButtonPressed:)];
    radius10mileButton.tag = 10;
    radius10mileButton.width = 44;
    radius10mileButton.tintColor = self.itemNormalTint;
    
    radius20mileButton = [[UIBarButtonItem alloc] initWithTitle:@"20" style:UIBarButtonItemStyleBordered target:self action:@selector(radiusButtonPressed:)];
    radius20mileButton.tag = 20;
    radius20mileButton.width = 44;
    radius20mileButton.tintColor = self.itemNormalTint;
    
    UIBarButtonItem *flexibleSpace = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    
    radiusToolbar.items = @[radiusText,radius5mileButton,flexibleSpace, radius10mileButton, flexibleSpace ,radius20mileButton, flexibleSpace, flexibleSpace];
    
    

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    
    globeButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"globe"] selectedImage:nil target:self action:@selector(flipView:)];
    
       
        
    addLocationButton = [UIBarButtonItem barItemWithImage:[UIImage imageNamed:@"plus"] selectedImage:nil target:self action:@selector(addLocationButtonTapped:)];
    
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
    if (!self.locationsInformationCollection) {
        self.locationsInformationCollection = [NSMutableArray array];
    }
    
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
    
    [overlayImageView setHidden:YES];
    [mapView setScrollEnabled:YES];
    [mapView setZoomEnabled:YES];
    [mapView removeGestureRecognizer:tapGestureRecognizer];
    
    [radiusToolbar removeFromSuperview];
    if([self.title isEqualToString:@"All Nearby"]){
        [self.view addSubview:radiusToolbar];
    }

    
    if (!_isHistory) {
        self.navigationItem.rightBarButtonItem = nil;
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addLocationButton, globeButton, nil];
    }
    else {
        self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:nil, nil, nil];
        self.navigationItem.rightBarButtonItem = clearBarButton;
        if (_locationsInformationCollection.count == 0) {
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
    
    

    [self.tableView reloadData];
}

#pragma mark - IBAction Methods
- (void)backButtonTapped:(id)sender {
    [SVProgressHUD dismiss];
    [self.navigationController popViewControllerAnimated:YES];
}
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

-(void)addLocationFromMap:(BOOL)fromMap{
    
    if (!fromMap) {
        MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithNibName:@"MMAddLocationViewController" bundle:nil];
        addLocationViewController.title = @"Add Location";
        addLocationViewController.category = self.category;
        addLocationViewController.delegate = self;
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
- (void)addLocationButtonTapped:(id)sender {
    BOOL fromMap = self.mapView.hidden ? NO : YES;
    
    [self addLocationFromMap:fromMap];
    
}

- (void)cancelButtonTapped:(id)sender {
    self.navigationItem.rightBarButtonItems = [NSArray arrayWithObjects:addLocationButton, globeButton, nil];
    [overlayImageView setHidden:YES];
    [mapView setScrollEnabled:YES];
    [mapView setZoomEnabled:YES];
    [mapView removeGestureRecognizer:tapGestureRecognizer];
}

-(void)setLocationsInformationCollection:(NSMutableArray *)locationsInformationCollection{
    _locationsInformationCollection = locationsInformationCollection;
    [self.tableView reloadData];
    [self reloadMapView];
}
/*- (void)setLocations:(NSMutableArray *)locations
{
    _locations = locations;
    [self.tableView reloadData];
    [self reloadMapView];
}*/

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
    return self.locationsInformationCollection.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    
    static NSString *CellIdentifier = @"Cell";
    
    MMLocationListCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[MMLocationListCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    [cell setLocationInformation:[self.locationsInformationCollection objectAtIndex:indexPath.row]];
    
    return cell;
    
    
    //cell.location = [self.locations objectAtIndex:indexPath.row];
    
    
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    MMLocationInformation *locationInformation = [self.locationsInformationCollection objectAtIndex:indexPath.row];
    
    if (![locationInformation.locationID isKindOfClass:[NSNull class]] && ![locationInformation.providerID isKindOfClass:[NSNull class]]) {
        NSString *historyKey = [NSString stringWithFormat:@"%@ history", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
        if (!self.isHistory) {
            NSMutableArray *searchHistory;
            if ([[NSUserDefaults standardUserDefaults]valueForKey:historyKey]) {
                searchHistory = [[NSUserDefaults standardUserDefaults] mutableArrayValueForKey:historyKey];
            }
            else {
                searchHistory = [[NSMutableArray alloc]init];
            }
            //NSMutableDictionary *locationDictionary = [[_locations objectAtIndex:indexPath.row] mutableCopy];
            NSString *locationId = locationInformation.locationID;
            NSString *providerId = locationInformation.providerID;
            NSPredicate *locationPredicate = [NSPredicate predicateWithFormat:@"(locationId MATCHES %@) AND (providerId MATCHES %@)", locationId, providerId];
            NSArray *matchingLocations = [searchHistory filteredArrayUsingPredicate:locationPredicate];
            if (matchingLocations.count == 0) {
                id const nul = [NSNull null];
                NSMutableDictionary *locationDictionary = [MMAPI locationDictionaryForLocationInformation:locationInformation].mutableCopy;
                NSMutableDictionary *dictionaryToCleanUp = [locationDictionary mutableCopy];
                
                for (NSString *key in dictionaryToCleanUp) {
                    id const obj = [locationDictionary valueForKey:key];
                    if (nul == obj) {
                        [locationDictionary setValue:@"" forKey:key];
                    }
                }
                [searchHistory addObject:locationDictionary];
                [[NSUserDefaults standardUserDefaults]setValue:searchHistory forKey:historyKey];
                [[NSUserDefaults standardUserDefaults] synchronize];
                
                NSLog(@"%@", [[NSUserDefaults standardUserDefaults]valueForKey:historyKey]);
            }
            
        }
        NSString *locationId = locationInformation.locationID;
        NSString *providerId = locationInformation.providerID;
        
        MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithStyle:UITableViewStyleGrouped];
        locationViewController.locationInformation = locationInformation;
        //[locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
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
    for (MMLocationInformation *locationInformation in self.locationsInformationCollection) {
        if (![locationInformation.latitude isKindOfClass:[NSNull class]] && ![locationInformation.longitude isKindOfClass:[NSNull class]]) {
            CLLocationCoordinate2D coordinate;
            coordinate.latitude = [locationInformation.latitude floatValue];
            coordinate.longitude = [locationInformation.longitude floatValue];
            MMLocationAnnotation *annotation = [[MMLocationAnnotation alloc] initWithName:locationInformation.name address:
                                                [locationInformation formattedAddressString] coordinate:coordinate arrayIndex:[self.locationsInformationCollection indexOfObject:locationInformation]];
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
    
    //[[MMClientSDK sharedSDK] locationScreen:self locationDetail:[self.locations objectAtIndex:[sender tag]]];
    [[MMClientSDK sharedSDK] locationScreen:self locationInformation:[self.locationsInformationCollection objectAtIndex:[sender tag]]];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
    // TODO / FIXME - DRY this (duplicated in MMMapFilterViewController)
    CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
    CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
    
    MMAddLocationViewController *addLocationViewController = [[MMAddLocationViewController alloc] initWithLocation:touchMapCoordinate];
    addLocationViewController.title =@"Add Location";
    addLocationViewController.category = self.category; // case in point for DRY - wasted almost an hour before realizing this is here and not in the MMAddLocationViewController..
    addLocationViewController.delegate = self;
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
    NSString *historyKey = [NSString stringWithFormat:@"%@ history", [[NSUserDefaults standardUserDefaults]valueForKey:@"userName"]];
    switch (buttonIndex) {
        case 1:
            [[NSUserDefaults standardUserDefaults]removeObjectForKey:historyKey];
            [_locationsInformationCollection removeAllObjects];
            [_tableView reloadData];
            [clearBarButton setEnabled:NO];
            break;
            
        default:
            break;
    }
}

#pragma mark - MMAddLocation Delegate methods
- (void)locationAddedViaAddLocationViewWithLocationId:(NSString*)locationId providerId:(NSString*)providerId {
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithStyle:UITableViewStyleGrouped];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];
}

#pragma mark - UIToolbar Button
-(void)clearSelectionColors{
    radius5mileButton.tintColor = self.itemNormalTint;
    radius10mileButton.tintColor = self.itemNormalTint;
    radius20mileButton.tintColor = self.itemNormalTint;

}
-(void)radiusButtonPressed:(UIBarButtonItem *)sender{
    
    [self clearSelectionColors];
    NSUInteger tag = [sender tag];
    sender.tintColor = self.itemSelectedTint;
    
    NSNumber * radiusSelected;
    switch (tag) {
        case 5:
            radiusSelected = @8800;
            break;
        case 10:
            radiusSelected = @17600;
            break;
        case 20:
            radiusSelected = @35200;
            break;
        default:
            radiusSelected = @8800;
            break;
    }
    [[NSUserDefaults standardUserDefaults] setObject:radiusSelected forKey:@"savedSegmentValue"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [SVProgressHUD showWithStatus:@"Searching..."];
    [self reloadLocations];
    
    [self.tableView reloadData];

}
-(void)reloadLocations{
    MMLocationSearch *locationSearch = [[MMLocationSearch alloc] init];
    
    [locationSearch locationsInfoForCategory:self.category searchString:self.searchString success:^(NSArray *locationInformations) {
        self.locationsInformationCollection = locationInformations.mutableCopy;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"There was an error getting location data: %@", error);
        [SVProgressHUD dismiss];
    }];
    
    /*[locationSearch locationsForCategory:self.category searchString:self.searchString success:^(NSArray *locations) {
        self.locationsInformationCollection = locations.mutableCopy;
        [SVProgressHUD dismiss];
    } failure:^(NSError *error) {
        NSLog(@"There was an error getting location data: %@", error);
        [SVProgressHUD dismiss];
    }];*/
}
@end
