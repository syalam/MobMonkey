//
//  MMAddLocationViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMAddLocationViewController.h"
#import "MMAPI.h"
#import "MMLocationViewController.h"

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
                   [addressDictionary setValue:placemark.country forKey:@"Country"];
                   [addressDictionary setValue:placemark.locality forKey:@"Locality"];
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
  NSLog(@"// TODO / FIXME - geocode the new address to refine the coordinates");
  NSLog(@"TODO / FIXME - use a CLPlacemark or similar rather than a MutableDictionary");
}

-(NSString*)country {
  return [addressDictionary valueForKey:@"Country"];
}

-(NSString*)address {
  return [addressDictionary valueForKey:@"Street"];
}

-(NSString*)phoneNumber {
  return [addressDictionary valueForKey:@"PhoneNumber"];
}

-(NSString*)postcode {
  return [addressDictionary valueForKey:@"ZIP"];
}

-(NSString*)region {
  return [addressDictionary valueForKey:@"State"];
}

-(NSString*)locality {
  return [addressDictionary objectForKey:@"Locality"];
}

-(IBAction)addLocation:(id)sender {
  // add the location to the MMAPI 
  NSMutableDictionary* locationDictionary = [[NSMutableDictionary alloc] init];
  
  [locationDictionary setValue:[addressDictionary objectForKey:@"Name"]
                        forKey:@"name"];

  [locationDictionary setValue: [self phoneNumber] forKey:@"phoneNumber"];
  [locationDictionary setValue: [self postcode] forKey:@"postcode"];
  [locationDictionary setValue: [self locality] forKey:@"locality"];
  [locationDictionary setValue: [self region] forKey:@"region"];
  [locationDictionary setValue: [self country] forKey:@"countryCode"];
  
  [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
  [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
  // TODO / FIXME - hard coded constant (this should probably go in info.plist or wherever appropriate)
  NSString *providerId = @"e048acf0-9e61-4794-b901-6a4bb49c3181"; 
  [locationDictionary setValue:providerId forKey:@"providerId"];
  [locationDictionary setValue:[self address] forKey:@"address"];
  
  [locationDictionary setValue:[self country] forKey:@"countryCode"];
  
  [locationDictionary setValue:@"25" forKey:@"radiusInYards"]; // 
  
  [[MMAPI sharedAPI] addNewLocation:locationDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
    NSString *locationId = [responseObject objectForKey:@"locationId"];
    NSLog(@"TODO navigate to the Location screen populated with the location data just entered by the user");
    MMLocationViewController *locationViewController = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    [locationViewController loadLocationDataWithLocationId:locationId providerId:providerId];
    [self.navigationController pushViewController:locationViewController animated:YES];

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
