//
//  MMCreateHotSpotMapViewController.m
//  MobMonkey
//
//  Created by Michael Kral on 6/5/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMCreateHotSpotMapViewController.h"

@interface MMCreateHotSpotMapViewController ()

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
    
    self.navigationController.navigationBar.translucent = YES;
    
    _mapView = [[MKMapView alloc] initWithFrame:self.view.bounds];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    _mapView.centerCoordinate = _mapView.userLocation.coordinate;
    
    [self.view addSubview:_mapView];
    
    _hotSpotActionButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    _hotSpotActionButton.frame = CGRectMake((self.view.frame.size.width - 280)/2, self.view.frame.size.height - 50 - 25, 280, 50);
    [self.view addSubview:_hotSpotActionButton];
    
    hotSpotAnnotation = [[MKPointAnnotation alloc] init];
    [self.mapView addAnnotation:hotSpotAnnotation];
    
    MKAnnotationView *view = [_mapView viewForAnnotation:hotSpotAnnotation];
    
    view.image = [UIImage imageNamed:@"pinFlame"];
    view.centerOffset = CGPointMake(-8, 6);
    
    
    UITapGestureRecognizer * tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
    
    [_mapView addGestureRecognizer:tapGesture];
	// Do any additional setup after loading the view.
}
-(void)mapTapped:(UITapGestureRecognizer*)sender{
    
    CGPoint touchPoint = [sender locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
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
