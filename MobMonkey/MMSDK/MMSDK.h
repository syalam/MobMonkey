//
//  MMSDK.h
//  MMSDK
//
//  Created by Reyaad Sidique on 2/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MMSDK : NSObject <CLLocationManagerDelegate>

@property (nonatomic, retain)CLLocationManager *locationManager;

///---------------------------------------------
/// @name MMActivateLocationServices
///---------------------------------------------
/**
 Activates location services. Should be called from appDidLaunch method in app delegate
 */
+(void)MMActivateLocationServices;


///---------------------------------------------
/// @name displayMMSignInScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Sign in Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMSignInScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;


///---------------------------------------------
/// @name displayMMSignUpScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Sign Up Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMSignUpScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;


///---------------------------------------------
/// @name displayMMInboxScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey inbox Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMInboxScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;

///---------------------------------------------
/// @name displayMMOpenRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Open Requests Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMOpenRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;

///---------------------------------------------
/// @name displayMMAnsweredRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMAnsweredRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;

///---------------------------------------------
/// @name displayMMAssignedRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */

+ (void)displayMMAssignedRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;


///---------------------------------------------
/// @name displayMMLocationDetailScreenFromPresentingViewController:withLocationParams
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller.
 
 Params params
 @param locationId
 @param providerId
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMLocationDetailScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params withThemeOptions:(NSDictionary*)themeOptionsDictionary;


///---------------------------------------------
/// @name displayMMMakeARequestScreenFromPresentingViewController:withLocationParams
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller.
 Params Dictionary params:
 @param locationId
 @param providerId

 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMMakeARequestScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params withThemeOptions:(NSDictionary*)themeOptionsDictionary;

///---------------------------------------------
/// @name displayMMSearchScreenFromPresentingViewController:presentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Search Screen from a specified view controller
 
 themeOptionDictionary params:
 @param backgroundColor (UIColor)
 @param buttonBackgoundImage (UIImage)
 @param navigationBarTintColor (UIColor)
 @param navigationBarTitleImage (UIImage)
 */
+ (void)displayMMSearchScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;

+ (void)displayMMSubscriptionViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;


@end
