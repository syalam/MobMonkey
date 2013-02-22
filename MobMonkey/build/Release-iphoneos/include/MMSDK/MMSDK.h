//
//  MMSDK.h
//  MMSDK
//
//  Created by Reyaad Sidique on 2/13/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MMSDK : NSObject

///---------------------------------------------
/// @name displayMMSignInScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Sign in Screen from a specified view controller
 */
+ (void)displayMMSignInScreenFromPresentingViewController:(UIViewController*)presentingViewController;


///---------------------------------------------
/// @name displayMMSignUpScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Sign Up Screen from a specified view controller
 */
+ (void)displayMMSignUpScreenFromPresentingViewController:(UIViewController*)presentingViewController;


///---------------------------------------------
/// @name displayMMInboxScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey inbox Screen from a specified view controller
 */
+ (void)displayMMInboxScreenFromPresentingViewController:(UIViewController*)presentingViewController;

///---------------------------------------------
/// @name displayMMOpenRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Open Requests Screen from a specified view controller
 */
+ (void)displayMMOpenRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController;

///---------------------------------------------
/// @name displayMMAnsweredRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller
 */
+ (void)displayMMAnsweredRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController;

///---------------------------------------------
/// @name displayMMAssignedRequestsScreenFromPresentingViewController
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller
 */

+ (void)displayMMAssignedRequestsScreenFromPresentingViewController:(UIViewController*)presentingViewController;


///---------------------------------------------
/// @name displayMMLocationDetailScreenFromPresentingViewController:withLocationParams
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller.
 
 @param locationId
 @param providerId
 */
+ (void)displayMMLocationDetailScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params;


///---------------------------------------------
/// @name displayMMMakeARequestScreenFromPresentingViewController:withLocationParams
///---------------------------------------------
/**
 Displays the MobMonkey Answered Requests Screen from a specified view controller.
 
 @param locationId
 @param providerId
 */
+ (void)displayMMMakeARequestScreenFromPresentingViewController:(UIViewController*)presentingViewController withLocationParams:(NSDictionary*)params;

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
 @param searchBarTintColor (UIColor)
 */
+ (void)displayMMSearchScreenFromPresentingViewController:(UIViewController*)presentingViewController withThemeOptions:(NSDictionary*)themeOptionsDictionary;


@end
