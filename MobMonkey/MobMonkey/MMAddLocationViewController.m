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

@interface MMAddLocationViewController ()

@end

@implementation MMAddLocationViewController

@synthesize nameTextField;
@synthesize streetTextField;
@synthesize cityTextField;
@synthesize stateTextField;
@synthesize zipTextField;
@synthesize phoneNumberTextField;
@synthesize category;

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
    if (geocoder == nil)
        geocoder = [[CLGeocoder alloc] init];
    
    [geocoder reverseGeocodeLocation:location
                   completionHandler:^(NSArray *placemarks, NSError *error) {
                       CLPlacemark *placemark = [placemarks objectAtIndex:0];
                       
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

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 7;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    MMTextFieldCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[MMTextFieldCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.font = [UIFont systemFontOfSize:17];
    }
    
    cell.textField.keyboardType = UIKeyboardTypeDefault;
    
    switch (indexPath.row) {
        case 0:
            cell.textField.placeholder = @"Name";
            nameTextField = cell.textField;
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
            cell.textField.placeholder = @"Street";
            cell.textField.text = [addressDictionary valueForKey:@"Street"];
            streetTextField = cell.textField;
            break;
        case 3:
            cell.textField.placeholder = @"City";
            cell.textField.text = [addressDictionary valueForKey:@"City"];
            cityTextField = cell.textField;
            break;
        case 4:
            cell.textField.placeholder = @"State";
            cell.textField.text = [addressDictionary valueForKey:@"State"];
            stateTextField = cell.textField;
            break;
        case 5:
            cell.textField.placeholder = @"Zip";
            cell.textField.text = [addressDictionary valueForKey:@"Zip"];
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            zipTextField = cell.textField;
            break;
        case 6:
            cell.textField.placeholder = @"Phone Number (optional)";
            cell.textField.keyboardType = UIKeyboardTypeNumberPad;
            cell.textField.text = [addressDictionary valueForKey:@"PhoneNumber"];
            phoneNumberTextField = cell.textField;
            break;
        default:
            break;
    }
    
    return cell;
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

-(NSString*)name {
    return [addressDictionary valueForKey:@"Name"];
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

-(NSString*)radiusInYards {
    NSString *radiusInYards = [[[NSNumber alloc]
                                initWithDouble:(1.0936133 * location.horizontalAccuracy)] // location.horizontalAccuracy is in meters
                               stringValue];
    return radiusInYards;
}

-(IBAction)addLocation:(id)sender {
    NSString *name = nameTextField.text;
    if ([name length] == 0) {
        name = streetTextField.text;
    }
    
    if ([name length] == 0) {
        name = @"Unnamed Location";
    }
    
    if (!addressDictionary) {
        addressDictionary = [[NSMutableDictionary alloc]init];
    }
    
    [addressDictionary setValue:nameTextField.text forKey:@"Name"];
    [addressDictionary setValue:streetTextField.text forKey:@"Street"];
    [addressDictionary setValue:cityTextField.text forKey:@"City"];
    [addressDictionary setValue:stateTextField.text forKey:@"State"];
    [addressDictionary setValue:zipTextField.text forKey:@"ZIP"];
    [addressDictionary setValue:phoneNumberTextField.text forKey:@"PhoneNumber"];

    NSLog(@"%@", addressDictionary);
    
    [geocoder geocodeAddressDictionary:addressDictionary
                     completionHandler:^(NSArray *placemarks, NSError *error) {
                         if ([placemarks count] > 0) {
                             CLPlacemark *placemark = [placemarks objectAtIndex:0];
                             location = placemark.location;
                             [self addAndJumpToLocation];
                         }
                     }];
}

-(void)addAndJumpToLocation
{
    // add the location to the MMAPI
    
    NSLog(@"%@", addressDictionary);
    
    NSString *errorMessage;
    if ([nameTextField.text isEqualToString:@""] || !nameTextField.text) {
        errorMessage = @"Please enter a name";
    }
    else if (!categories) {
        errorMessage = @"Please select the categories to which this location belong";
    }
    else if ([streetTextField.text isEqualToString:@""] || !streetTextField.text) {
        errorMessage = @"Please enter street";
    }
    else if ([cityTextField.text isEqualToString:@""] || !cityTextField.text) {
        errorMessage = @"Please enter a city";
    }
    else if ([stateTextField.text isEqualToString:@""] || !stateTextField.text) {
        errorMessage = @"Please enter a state";
    }
    else if ([zipTextField.text isEqualToString:@""] || !zipTextField.text) {
        errorMessage = @"Please enter a zip code";
    }
    else if ([cityTextField.text isEqualToString:@""] || !cityTextField.text) {
        errorMessage = @"Please enter a city";
    }
    if (errorMessage) {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:errorMessage delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
    else {
        NSMutableDictionary* locationDictionary = [[NSMutableDictionary alloc] init];
        
        [locationDictionary setValue:[self name] forKey:@"name"];
        [locationDictionary setValue: [self phoneNumber] forKey:@"phoneNumber"];
        [locationDictionary setValue: [self postcode] forKey:@"postcode"];
        [locationDictionary setValue: [self locality] forKey:@"locality"];
        [locationDictionary setValue: [self region] forKey:@"region"];
        [locationDictionary setValue: [self country] forKey:@"countryCode"];
        [locationDictionary setValue: [[categories allValues] componentsJoinedByString:@","] forKey:@"categoryIds"];
        [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.latitude] forKey:@"latitude"];
        [locationDictionary setValue:[NSString stringWithFormat:@"%f",location.coordinate.longitude] forKey:@"longitude"];
        [locationDictionary setValue:[self country] forKey:@"countryCode"];
        [locationDictionary setValue:[self address] forKey:@"ai donddress"];
        
        NSString *providerId = @"e048acf0-9e61-4794-b901-6a4bb49c3181";
        [locationDictionary setValue:providerId forKey:@"providerId"];
        
        
        [MMAPI addNewLocation:locationDictionary success:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSString *locationId = [responseObject valueForKey:@"locationId"];
            NSString *responseProviderId = [responseObject valueForKey:@"providerId"];
            
            [_delegate locationAddedViaAddLocationViewWithLocationId:locationId providerId:responseProviderId];
            
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

@end
