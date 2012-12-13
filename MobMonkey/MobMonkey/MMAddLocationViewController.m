//
//  MMAddLocationViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAddLocationViewController.h"
#import "MMAPI.h"

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
                   zipTextField.text = placemark.postalCode;
                 }];

  UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
  [backNavbutton addTarget:self action:@selector(backButtonTapped:)
          forControlEvents:UIControlEventTouchUpInside];
  [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                           forState:UIControlStateNormal];
  
  UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
  self.navigationItem.leftBarButtonItem = backButton;
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
  NSString *key;
  
  if (textField == nameTextField) {
    key = @"Name";
    
  } else if (textField == streetTextField) {
    key = @"Street";
    
  } else if (textField == cityTextField) {
    key = @"City";
    
  } else if (textField == stateTextField) {
    key = @"State";
    
  } else if (textField == zipTextField) {
    key = @"ZIP";
    
  } else if (textField == phoneNumberTextField) {
    key = @"PhoneNumber";
  }
  
  [addressDictionary setValue:textField.text forKey:key];
}

-(IBAction)addLocation:(id)sender {
  // add the location to the MMAPI 
  NSMutableDictionary* locationDictionary = [[NSMutableDictionary alloc] init];
  
  [locationDictionary setValue:[addressDictionary objectForKey:@"Name"]
                        forKey:@"name"];

  [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
  [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];

  [locationDictionary setValue:@"25" forKey:@"radiusInYards"]; // 
  
  [[MMAPI sharedAPI] addNewLocation:locationDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSLog(@"responseObject: %@", responseObject);
    NSLog(@"TODO navigate to the Location screen populated with the location data just entered by the user");

  } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    NSLog(@"error: %@", error);
  }];
  
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
