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
  UITextView *addressTextView;
  UITextField *phoneNumberTextField;
}

@property (strong, nonatomic) UITextField *nameTextField;
@property (strong, nonatomic) UITextView *addressTextView;
@property (strong, nonatomic) UITextField *phoneNumberTextField;

-(id)initWithLocation:(CLLocationCoordinate2D)location;
-(IBAction)addIt:(id)sender;
-(IBAction)cancel:(id)sender;

@end
