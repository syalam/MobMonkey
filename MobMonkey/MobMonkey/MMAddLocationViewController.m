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
#import "MMTextFieldCell.h"
#import "UIAlertView+Blocks.h"

@interface MMAddLocationViewController ()

@end

@implementation MMAddLocationViewController

@synthesize hasAddress, addressSwitch;

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
        locationManager = [[CLLocationManager alloc] init];
        locationManager.delegate = self;
        locationManager.desiredAccuracy = kCLLocationAccuracyBest;
        locationManager.distanceFilter = kCLDistanceFilterNone;
        [locationManager startUpdatingLocation];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // pre-populate address text view
    if (geocoder == nil) {
        geocoder = [[CLGeocoder alloc] init];
    }
    
    locationInformation = [[MMLocationInformation alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
                       locationInformation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
                       locationInformation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
                       
                       if(!error){
                           locationInformation.street = [placemark.addressDictionary objectForKey:@"Street"];
                           locationInformation.city = [placemark.addressDictionary objectForKey:@"City"];
                           locationInformation.state = [placemark.addressDictionary objectForKey:@"State"];
                           locationInformation.zipCode = placemark.postalCode;
                           locationInformation.country = placemark.country;
                           locationInformation.locality = placemark.locality;
                        
                           if(locationInformation.street){
                               self.hasAddress = YES;
                           }
                       }
                       
                       
                                              
                   }];
    
    UIButton *backNavbutton = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 39, 30)];
    [backNavbutton addTarget:self action:@selector(backButtonTapped:)
            forControlEvents:UIControlEventTouchUpInside];
    [backNavbutton setBackgroundImage:[UIImage imageNamed:@"BackBtn~iphone"]
                             forState:UIControlStateNormal];
    
    UIBarButtonItem* backButton = [[UIBarButtonItem alloc]initWithCustomView:backNavbutton];
    self.navigationItem.leftBarButtonItem = backButton;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return hasAddress ? 8 : 4;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
        cell.textField.delegate = self;
    }
    
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    if (self.hasAddress) {
        switch (indexPath.row) {
            case 0:
                cell.textField.placeholder = @"Name";
                cell.textField.tag = LocationCellTypeName;
                break;
            case 1:
                [cell.textField setHidden:YES];
                cell.textLabel.textColor = [UIColor MMMainTextColor];
                
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                if (categories && categories.count > 0) {
                    cell.textLabel.text = [[categories allKeys] componentsJoinedByString:@",\n"];
                }
                else {
                    cell.textLabel.text = @"Categories";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                [cell.textLabel sizeToFit];
                break;
            case 2:
                cell.textField.hidden = YES;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.text = @"Add Address";
                addressSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                addressSwitch.on = YES;
                [addressSwitch addTarget:self action:@selector(addressSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = addressSwitch;
                break;
            case 3:
                cell.textField.tag = LocationCellTypeStreet;
                cell.textField.placeholder = @"Street";
                cell.textField.text = locationInformation.street;
                break;
            case 4:
                cell.textField.tag = LocationCellTypeCity;
                cell.textField.placeholder = @"City";
                cell.textField.text = locationInformation.city;
                break;
            case 5:
                cell.textField.tag = LocationCellTypeState;
                cell.textField.placeholder = @"State";
                cell.textField.text = locationInformation.state;
                break;
            case 6:
                cell.textField.tag = LocationCellTypeZip;
                cell.textField.placeholder = @"Zip";
                cell.textField.text = locationInformation.zipCode;
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                break;
            case 7:
                cell.textField.tag = LocationCellTypePhoneNumber;
                cell.textField.placeholder = @"Phone Number (optional)";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = locationInformation.phoneNumber;
            break;
            default:
                break;
        }
    }else {
        switch (indexPath.row) {
            case 0:
                cell.textField.tag = LocationCellTypeName;
                cell.textField.placeholder = @"Name";
                break;
            case 1:
                [cell.textField setHidden:YES];
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.numberOfLines = 0;
                cell.textLabel.lineBreakMode = NSLineBreakByWordWrapping;
                if (categories && categories.count > 0) {
                    cell.textLabel.text = [[categories allKeys] componentsJoinedByString:@",\n"];
                }
                else {
                    cell.textLabel.text = @"Categories";
                    cell.textLabel.textColor = [UIColor lightGrayColor];
                }
                [cell.textLabel sizeToFit];
                break;
            case 2:
                cell.textField.hidden = YES;
                cell.textLabel.textColor = [UIColor blackColor];
                cell.textLabel.text = @"Add Address";
                addressSwitch = [[UISwitch alloc] initWithFrame:CGRectZero];
                addressSwitch.on = NO;
                [addressSwitch addTarget:self action:@selector(addressSwitchChanged:) forControlEvents:UIControlEventValueChanged];
                cell.accessoryView = addressSwitch;
                break;
            case 3:
                cell.textField.tag = LocationCellTypePhoneNumber;
                cell.textField.placeholder = @"Phone Number (optional)";
                cell.textField.keyboardType = UIKeyboardTypeNumberPad;
                cell.textField.text = locationInformation.phoneNumber;
                break;
            default:
                break;
        }
    }
    
    
    return cell;
}

-(void)addressSwitchChanged:(UISwitch *)sender{

    if(sender.on && [self.tableView numberOfRowsInSection:0] == 4){
        
        
        self.hasAddress = YES;
        [self.tableView beginUpdates];
        
        NSIndexPath *streetIndex = [NSIndexPath indexPathForItem:3 inSection:0];
        NSIndexPath *cityIndex = [NSIndexPath indexPathForItem:4 inSection:0];
        NSIndexPath *stateIndex = [NSIndexPath indexPathForItem:5 inSection:0];
        NSIndexPath *zipIndex = [NSIndexPath indexPathForItem:6 inSection:0];
        
        [self.tableView insertRowsAtIndexPaths:@[streetIndex, cityIndex, stateIndex, zipIndex] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        
    }else if(!sender.on && [self.tableView numberOfRowsInSection:0] == 8){
        self.hasAddress = NO;
        
        
        [self.tableView beginUpdates];
        
        NSIndexPath *streetIndex = [NSIndexPath indexPathForItem:3 inSection:0];
        NSIndexPath *cityIndex = [NSIndexPath indexPathForItem:4 inSection:0];
        NSIndexPath *stateIndex = [NSIndexPath indexPathForItem:5 inSection:0];
        NSIndexPath *zipIndex = [NSIndexPath indexPathForItem:6 inSection:0];
        
        [self.tableView deleteRowsAtIndexPaths:@[streetIndex, cityIndex, stateIndex, zipIndex] withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
    }
    
}
#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    switch (indexPath.row) {
        case 1:
            [self showCategoryScreen];
            break;
            
        default:
            break;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 44;
    if (indexPath.row == 1) {
        NSArray *categoryArray = [categories allKeys];
        if (categoryArray.count > 2) {
            height = 22 * categoryArray.count;
        }
    }
    return height;
}

-(NSString*)radiusInYards {
    NSString *radiusInYards = [[[NSNumber alloc]
                                initWithDouble:(1.0936133 * location.horizontalAccuracy)] // location.horizontalAccuracy is in meters
                               stringValue];
    return radiusInYards;
}

-(IBAction)addLocation:(id)sender {
    NSString *name = locationInformation.name;
    if ([name length] == 0 && locationInformation.street.length > 0) {
        name = locationInformation.street;
    }else{
        name = @"Unnamed Location";
    }
    
    if(!locationInformation.latitude || locationInformation.longitude){
     
        locationInformation.latitude = [NSNumber numberWithDouble:location.coordinate.latitude];
        locationInformation.longitude = [NSNumber numberWithDouble:location.coordinate.longitude];
    }
    
    if(self.hasAddress){
        [locationInformation geocodeLocationWithCompletionHandler:^(NSArray *placemarks, NSError *error) {
            if ([placemarks count] > 0) {
                CLPlacemark *placemark = [placemarks objectAtIndex:0];
                [locationManager stopUpdatingLocation];
                [self addAndJumpToLocation:placemark.location];
            }else{
                UIAlertView *addressNotFoundAlert = [[ UIAlertView alloc] initWithTitle:@"No Location Found" message:@"Could not geocode this address, please fix the address" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles: nil];
                [addressNotFoundAlert show];
            }
        }];
    }else{
        RIButtonItem * cancelItem = [RIButtonItem itemWithLabel:@"Cancel"];
        RIButtonItem * currentLocationItem = [RIButtonItem itemWithLabel:@"Current Location"];
        
        [currentLocationItem setAction:^{
            [self addAndJumpToLocation:location];
        }];
        
        UIAlertView *currentLocationAlert = [[UIAlertView alloc] initWithTitle:@"No Address" message:@"You didn't enter an address for this location, would you like to use your current position?" cancelButtonItem:cancelItem otherButtonItems:currentLocationItem, nil];
        
        [currentLocationAlert show];
    }
    
    
    
}

-(void)addAndJumpToLocation:(CLLocation*)location
{
    // add the location to the MMAPI
    
    NSString *errorMessage;
    
    if (!locationInformation.name) {
        errorMessage = @"Please enter a name";
    } else if (!categories) {
        errorMessage = @"Please select the categories to which this location belong";
    }

    
    if(self.hasAddress && !errorMessage){
        
        if(!locationInformation.street){
             errorMessage = @"Please enter street";
        } else if (!locationInformation.city) {
            errorMessage = @"Please enter a city";
        }
        else if (!locationInformation.state) {
            errorMessage = @"Please enter a state";
        }
        else if (!locationInformation.state) {
            errorMessage = @"Please enter a zip code";
        }

        
    }
    
    if (errorMessage) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSMutableDictionary* locationDictionary = [[NSMutableDictionary alloc] init];
        
        [locationDictionary setValue:locationInformation.name forKey:@"name"];
        [locationDictionary setValue: locationInformation.phoneNumber forKey:@"phoneNumber"];
        
        [locationDictionary setValue: [[categories allValues] componentsJoinedByString:@","] forKey:@"categoryIds"];
        [locationDictionary setValue:locationInformation.latitude.stringValue forKey:@"latitude"];
        [locationDictionary setValue:locationInformation.longitude.stringValue forKey:@"longitude"];
        
        if(self.hasAddress){
            
            [locationDictionary setValue:locationInformation.street forKey:@"address"];
            [locationDictionary setValue: locationInformation.zipCode forKey:@"postcode"];
            [locationDictionary setValue: locationInformation.locality forKey:@"locality"];
            [locationDictionary setValue: locationInformation.state forKey:@"region"];
            [locationDictionary setValue: locationInformation.country forKey:@"countryCode"];
            
        }
        
        
        NSString *providerId = @"e048acf0-9e61-4794-b901-6a4bb49c3181";
        [locationDictionary setValue:providerId forKey:@"providerId"];
        
        
        [MMAPI addNewLocation:locationDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *locationId = [responseObject valueForKey:@"locationId"];
            NSString *responseProviderId = [responseObject valueForKey:@"providerId"];
            if([_delegate respondsToSelector:@selector(locationAddedViaAddLocationViewWithLocationId:providerId:)]){
                [_delegate locationAddedViaAddLocationViewWithLocationId:locationId providerId:responseProviderId];
            }
            
            
            [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", operation.responseString);
            NSLog(@"error: %@", error);
        }];
    }
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

#pragma mark - Helper Methods
- (void)showCategoryScreen {
    MMCategoryViewController *categoryViewController = [[MMCategoryViewController alloc]initWithNibName:@"MMCategoryViewController" bundle:nil];
    categoryViewController.addingLocation = YES;
    categoryViewController.delegate = self;
    categoryViewController.title = @"Categories";
    if (categories) {
        categoryViewController.selectedItems = [categories mutableCopy];
    }
    [self.navigationController pushViewController:categoryViewController animated:YES];
}

#pragma mark - MMCategory delegate
- (void)categoriesSelected:(NSMutableDictionary*)selectedCategories {
    categories = selectedCategories;
    [self.tableView reloadData];
}

#pragma mark - UITextField Delegate
-(void)textFieldDidEndEditing:(UITextField *)textField {
    
    if(textField.text.length <= 0){
        textField.text = nil;
    }
    
    switch (textField.tag) {
        case LocationCellTypeName:
            if(![locationInformation.name isEqualToString:textField.text]){
                locationInformation.name = textField.text;
            }
            break;
        case LocationCellTypeStreet:
            if(![locationInformation.street isEqualToString:textField.text]){
                locationInformation.street = textField.text;
            }
            break;
        case LocationCellTypeCity:
            if(![locationInformation.city isEqualToString:textField.text]){
                locationInformation.city = textField.text;
            }
            break;
        case LocationCellTypeState:
            if(![locationInformation.state isEqualToString:textField.text]){
                locationInformation.state = textField.text;
            }
            break;
        case LocationCellTypeZip:
            if(![locationInformation.zipCode isEqualToString:textField.text]){
                locationInformation.zipCode = textField.text;
            }
            break;
        case LocationCellTypePhoneNumber:
            if(![locationInformation.phoneNumber isEqualToString:textField.text]){
                locationInformation.phoneNumber = textField.text;
            }
            break;
            
            
        default:
            break;
    }
}

-(void)locationManager:(CLLocationManager *)manager didUpdateToLocation:(CLLocation *)newLocation fromLocation:(CLLocation *)oldLocation {
    
    location = newLocation;
    
}
@end
