//
//  MMAddLocationViewController.h
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MMAddLocationViewController : UIViewController
{
  UITextField *nameTextField;
  NSDictionary *addressDictionary;
  UITextView *addressTextView;
  UITextField *phoneNumberTextField;
  CLLocation *location;
}

@property (strong, nonatomic) IBOutlet UITextField *nameTextField;
@property (strong, nonatomic) IBOutlet UITextView *addressTextView;
@property (strong, nonatomic) IBOutlet UITextField *phoneNumberTextField;

-(id)initWithLocation:(CLLocationCoordinate2D)location;
-(IBAction)addLocation:(id)sender;

@end
