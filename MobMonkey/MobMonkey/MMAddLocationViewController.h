//
//  MMAddLocationViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <MapKit/MapKit.h>
#import "MMCategoryViewController.h"
#import "MMLocationInformation.h"



@protocol MMAddLocationDelegate <NSObject>

@optional
- (void)locationAddedViaAddLocationViewWithLocationId:(NSString*)locationId providerId:(NSString*)providerId;

@end

@interface MMAddLocationViewController : UITableViewController <UITextFieldDelegate, MMCategoryDelegate>
{
    MMLocationInformation *locationInformation;
    
    CLLocation *location;
    
    NSDictionary *categories;
    
    CLGeocoder *geocoder;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextField *streetTextField;
@property (strong, nonatomic) IBOutlet UITextField *cityTextField;
@property (strong, nonatomic) IBOutlet UITextField *stateTextField;
@property (strong, nonatomic) IBOutlet UITextField *zipTextField;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;
@property (strong, nonatomic) NSDictionary *category;
@property (nonatomic, assign) id<MMAddLocationDelegate>delegate;
@property (nonatomic, assign) BOOL hasAddress;
@property (nonatomic, strong) UISwitch * addressSwitch;

-(id)initWithLocation:(CLLocationCoordinate2D)location;
-(IBAction)addLocation:(id)sender;

@end
