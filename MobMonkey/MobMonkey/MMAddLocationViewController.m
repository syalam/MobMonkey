//
//  MMAddLocationViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAddLocationViewController.h"

@interface MMAddLocationViewController ()

@end

@implementation MMAddLocationViewController

@synthesize nameTextField;
@synthesize streetTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneNumberTextField;

- (id)initWithLocation:(CLLocationCoordinate2D)touchLocation
{
  self = [super initWithNibName:@"MMAddLocationViewController" bundle:nil];
  self->location = [[CLLocation alloc] initWithCoordinate:touchLocation altitude:0 horizontalAccuracy:0 verticalAccuracy:0 timestamp:[[NSDate alloc] init]];
  
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

- (void)viewDidLoad
{
  [super viewDidLoad];

  // pre-populate address text view
  CLGeocoder *geocoder = [[CLGeocoder alloc] init];
  [geocoder reverseGeocodeLocation:location
                 completionHandler:^(NSArray *placemarks, NSError *error) {
                   CLPlacemark *placemark = [placemarks lastObject];
                   addressDictionary = placemark.addressDictionary;
                   streetTextField.text = [addressDictionary valueForKey:@"Street"];
                   cityTextField.text = [addressDictionary valueForKey:@"City"];
                   stateTextField.text = [addressDictionary valueForKey:@"State"];
                 }];

  UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
  [backNavbutton addTarget:self action:@selector(backButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
  [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                           forState:UIControlStateNormal];
  
  UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
  self.navigationItem.leftBarButtonItem = backButton;
}

-(IBAction)addLocation:(id)sender {
  NSLog(@"TODO add it - require that the name and phone number are set");
  NSLog(@"TODO save the location to the server");
  NSLog(@"TODO save the location to the server");
  NSLog(@"TODO navigate to the Location screen populated with the location data just entered by the user");
}

#pragma mark - UIBarButtonItem Action Methods
- (void)backButtonTapped:(id)sender {
  //  [_delegate setFilters:[NSDictionary dictionaryWithObjectsAndKeys:selectedRadius, @"radius", nil]];
  NSLog(@"return with location set");
  [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
