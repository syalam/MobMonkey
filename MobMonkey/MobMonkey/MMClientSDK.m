//
//  MMClientSDK.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 10/1/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMClientSDK.h"
#import "MMLoginViewController.h"
#import "MMSignUpViewController.h"
#import "MMTrendingViewController.h"
#import "MMInboxViewController.h"
#import "MMLocationViewController.h"
#import "MMLocationMediaViewController.h"
#import "MMInboxFullScreenImageViewController.h"
#import "MMAnsweredRequestsViewController.h"
#import "MMFullScreenImageViewController.h"

#import "MMRequestViewController.h"

@implementation MMClientSDK

#pragma mark - Singleton Method
+ (MMClientSDK *)sharedSDK {
    static MMClientSDK *_sharedSDK = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedSDK = [[MMClientSDK alloc] init];
    });
    
    return _sharedSDK;
}


- (void)signInScreen:(UIViewController*)presentingViewController {
    MMLoginViewController *signInVc = [[MMLoginViewController alloc]initWithNibName:@"MMLoginViewController" bundle:nil];
    signInVc.title = @"Sign In";
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:signInVc];
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)signUpScreen:(UIViewController*)presentingViewController {
    MMSignUpViewController *myInfoVc = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
    myInfoVc.title = @"Sign Up";
    [presentingViewController.navigationController pushViewController:myInfoVc animated:YES];
}

- (void)inboxScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory currentAPICall:(int)currentAPICall {
    MMInboxViewController *inboxVC = [[MMInboxViewController alloc]initWithNibName:@"MMInboxViewController" bundle:nil];
    inboxVC.title = selectedCategory;
    inboxVC.categorySelected = YES;
    inboxVC.currentAPICall = currentAPICall;
    [presentingViewController.navigationController pushViewController:inboxVC animated:YES];
}

- (void)answeredRequestsScreen:(UIViewController*)presentingViewController answeredItemsToDisplay:(NSArray*)answeredItemsToDisplay {
    MMAnsweredRequestsViewController *answeredVc = [[MMAnsweredRequestsViewController alloc]initWithNibName:@"MMAnsweredRequestsViewController" bundle:nil];
    answeredVc.contentList = answeredItemsToDisplay;
    answeredVc.thumbnailCache = [[NSMutableDictionary alloc]init];
    answeredVc.title = @"Answered Requests";
    [presentingViewController.navigationController pushViewController:answeredVc animated:YES];
}

- (void)inboxFullScreenImageScreen:(UIViewController*)presentingViewController imageToDisplay:(UIImage*)imageToDisplay locationName:(NSString*)locationName {
    MMFullScreenImageViewController *fsvc = [[MMFullScreenImageViewController alloc]initWithNibName:@"MMFullScreenImageViewController" bundle:nil];
    fsvc.title = locationName;
    fsvc.imageToDisplay = imageToDisplay;
    
    UINavigationController *navC = [[UINavigationController alloc]initWithRootViewController:fsvc];
    navC.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    
    [presentingViewController.navigationController presentViewController:navC animated:YES completion:NULL];
}

- (void)trendingScreen:(UIViewController*)presentingViewController selectedCategory:(NSString*)selectedCategory {
    MMTrendingViewController *trendingVC = [[MMTrendingViewController alloc]initWithNibName:@"MMTrendingViewController" bundle:nil];
    trendingVC.sectionSelected = YES;
    trendingVC.title = selectedCategory;
    [presentingViewController.navigationController pushViewController:trendingVC animated:YES];
}

- (void)locationScreen:(UIViewController*)presentingViewController locationDetail:(NSMutableDictionary*)locationDetail {
    MMLocationViewController *locationVC = [[MMLocationViewController alloc]initWithNibName:@"MMLocationViewController" bundle:nil];
    locationVC.contentList = locationDetail;
    [presentingViewController.navigationController pushViewController:locationVC animated:YES];
}

//- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail {
//    MMMakeRequestViewController *requestVC = [[MMMakeRequestViewController alloc]initWithNibName:@"MMMakeRequestViewController" bundle:nil];
//    requestVC.title = @"Make a Request";
//    requestVC.contentList = locationDetail;
//    UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
//    [presentingViewController.navigationController presentViewController:requestNavC animated:YES completion:NULL];
//}

- (void)makeARequestScreen:(UIViewController*)presentingViewController locationDetail:(NSDictionary*)locationDetail {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Request" bundle:nil];
    UINavigationController *navVC = [storyboard instantiateInitialViewController];
    MMRequestViewController *requestVC = navVC.viewControllers[0];
    requestVC.title = @"Make Request";
    requestVC.contentList = locationDetail;
    //UINavigationController *requestNavC = [[UINavigationController alloc]initWithRootViewController:requestVC];
    [presentingViewController presentViewController:navVC animated:YES completion:NULL];
}

- (void)locationMediaScreen:(UIViewController*)presentingViewController locationMediaContent:(NSArray*)locationMediaContent locationName:(NSString*)locationName {
    MMLocationMediaViewController *lmvc = [[MMLocationMediaViewController alloc]initWithNibName:@"MMLocationMediaViewController" bundle:nil];
    //lmvc.contentList = locationMediaContent;
    lmvc.title = locationName;
    UINavigationController *locationMediaNavC = [[UINavigationController alloc]initWithRootViewController:lmvc];
    [presentingViewController.navigationController presentViewController:locationMediaNavC animated:YES completion:NULL];
}

- (void)shareViaTwitter:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController {
    SLComposeViewController *tweetSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeTwitter];
    if (([SLComposeViewController isAvailableForServiceType:SLServiceTypeTwitter])) {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            [tweetSheet dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }
        };
        [tweetSheet addImage:[params valueForKey:@"image"]];
        [tweetSheet setInitialText:[params valueForKey:@"initialText"]];
        [tweetSheet addURL:[NSURL URLWithString:[params valueForKey:@"url"]]];
        [tweetSheet setCompletionHandler:completionHandler];
        [presentingViewController presentViewController:tweetSheet animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to access your Twitter account. Please ensure that you are logged in to Twitter in your iPhone's settings menu and that you have given MobMonkey permission to access your Twitter account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)shareViaFacebook:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController {
    SLComposeViewController *fbSheet = [SLComposeViewController composeViewControllerForServiceType:SLServiceTypeFacebook];
    if (([SLComposeViewController isAvailableForServiceType:SLServiceTypeFacebook])) {
        SLComposeViewControllerCompletionHandler __block completionHandler=^(SLComposeViewControllerResult result){
            [fbSheet dismissViewControllerAnimated:YES completion:nil];
            
            switch(result){
                case SLComposeViewControllerResultCancelled:
                default:
                {
                    NSLog(@"Cancelled.....");
                    
                }
                    break;
                case SLComposeViewControllerResultDone:
                {
                    NSLog(@"Posted....");
                }
                    break;
            }
        };
        [fbSheet addImage:[params valueForKey:@"image"]];
        [fbSheet setInitialText:[params valueForKey:@"initialText"]];
        [fbSheet addURL:[NSURL URLWithString:[params valueForKey:@"url"]]];
        [fbSheet setCompletionHandler:completionHandler];
        [presentingViewController presentViewController:fbSheet animated:YES completion:NULL];
    }
    else {
        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to access your Facebook account. Please ensure that you are logged in to Facebook in your iPhone's settings menu and that you have given MobMonkey permission to access your Facebook account" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
        [alert show];
    }
}

- (void)signInViaFacebook:(NSDictionary*)params presentingViewController:(UIViewController*)presentingViewController {
    NSArray *permissions = [NSArray arrayWithObjects:@"email", @"user_birthday", nil];
    
    [SVProgressHUD showWithStatus:@"Signing in with Facebook"];
    [FBSession openActiveSessionWithReadPermissions:permissions allowLoginUI:YES completionHandler:^(FBSession *session, FBSessionState status, NSError *error) {
        if (session.isOpen) {
            FBRequest *me = [FBRequest requestForMe];
            [me startWithCompletionHandler: ^(FBRequestConnection *connection,
                                              NSDictionary<FBGraphUser> *my,
                                              NSError *error) {
                if (!error) {
                    NSString* firstName = my.first_name;
                    NSString* lastName = my.last_name;
                    NSString* birthdayString = my.birthday;
                    
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    [dateFormatter setDateFormat:@"MM/dd/yyyy"];
                    NSDate *birthday = [[NSDate alloc] init];
                    birthday = [dateFormatter dateFromString:birthdayString];
                    NSTimeInterval birthdayUnixTime = birthday.timeIntervalSince1970*1000;
                    
                    NSNumber *gender;
                    if([[my valueForKey:@"gender"] isEqualToString:@"male"])
                        gender = [NSNumber numberWithInt:1];
                    else if([[my valueForKey:@"gender"] isEqualToString:@"female"])
                        gender = [NSNumber numberWithInt:0];
                                        
                    NSString* accessToken = me.session.accessToken;
                    NSDictionary *params = [NSDictionary dictionaryWithObjectsAndKeys:
                                            [my valueForKey:@"email"], @"providerUserName",
                                            @"true", @"useOAuth",
                                            accessToken, @"oauthToken",
                                            @"facebook", @"provider",
                                            @"iOS", @"deviceType",
                                            firstName, @"firstName",
                                            lastName, @"lastName",
                                            gender, @"gender",
                                            [NSNumber numberWithDouble:birthdayUnixTime], @"birthday",
                                            [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"], @"deviceId", nil];
                    [MMAPI oauthSignIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
                        [[NSUserDefaults standardUserDefaults]setValue:[my valueForKey:@"email"] forKey:@"userName"];
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"oauthUser"];
                        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"facebookEnabled"];
                        [[NSUserDefaults standardUserDefaults]setValue:@"facebook" forKey:@"oauthProvider"];
                        [[NSUserDefaults standardUserDefaults]setValue:accessToken forKey:@"oauthToken"];
                        [[NSUserDefaults standardUserDefaults]synchronize];
                        
                        [self checkInUser];
                        [self getAllCategories];
                        [SVProgressHUD showSuccessWithStatus:@"Signed in with Facebook"];
                        [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
                        [presentingViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
                    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
                        
                        if (operation.responseData) {
                            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
                            if ([response valueForKey:@"description"]) {
                                NSString *responseString = [response valueForKey:@"description"];
                                
                                [SVProgressHUD showErrorWithStatus:responseString];
                            }
                            else {
                                [SVProgressHUD showErrorWithStatus:@"Unable to login"];
                            }
                        }
                    }];
                }
                else {
                    UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"MobMonkey" message:@"Unable to log you in. Please try again." delegate:nil cancelButtonTitle:@"Cancel" otherButtonTitles:nil];
                    [alert show];
                }
            }];
        }
        else {
            [SVProgressHUD dismiss];
            NSLog(@"%@", error);
        }
    }];
}
- (void)signInViaTwitter:(ACAccount*)account presentingViewController:(UIViewController*)presentingViewController {
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithObjectsAndKeys:
                            account.username, @"providerUserName",
                            account.identifier, @"oauthToken",
                            @"twitter", @"provider",
                            @"true", @"useOAuth",
                            @"iOS", @"deviceType",
                            [[NSUserDefaults standardUserDefaults]valueForKey:@"apnsToken"], @"deviceId", nil];
    
    [MMAPI oauthSignIn:params success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [[NSUserDefaults standardUserDefaults]setValue:account.username forKey:@"userName"];
        [[NSUserDefaults standardUserDefaults]setValue:account.identifier forKey:@"oauthToken"];
        [[NSUserDefaults standardUserDefaults]setValue:@"twitter" forKey:@"oauthProvider"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"oauthUser"];
        [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"twitterEnabled"];
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [SVProgressHUD showSuccessWithStatus:@"Signed in with Twitter"];
        
        [[NSUserDefaults standardUserDefaults]synchronize];
        
        [self checkInUser];
        [self getAllCategories];
        [[NSNotificationCenter defaultCenter]postNotificationName:@"checkForUpdatedCounts" object:nil];
        [presentingViewController.navigationController dismissViewControllerAnimated:YES completion:NULL];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        //twitter auth passed, but user is new and needs to enter additional info to become a valid user
        if ([operation.response statusCode] == 404) {
            [[NSUserDefaults standardUserDefaults]setValue:account.username forKey:@"userName"];
            [[NSUserDefaults standardUserDefaults]setValue:account.identifier forKey:@"oauthToken"];            
            [[NSUserDefaults standardUserDefaults]setBool:YES forKey:@"oauthUser"];
            [[NSUserDefaults standardUserDefaults] setBool:YES forKey:@"twitterEnabled"];
            
            MMSignUpViewController *signUpViewController = [[MMSignUpViewController alloc]initWithNibName:@"MMSignUpViewController" bundle:nil];
            signUpViewController.twitterSignIn = YES;
            [signUpViewController.navigationItem setHidesBackButton:YES];
            signUpViewController.title = [NSString stringWithFormat:@"@%@ user info", account.username];
            [presentingViewController.navigationController pushViewController:signUpViewController animated:YES];
        }
        //if its not a 404 status code being returned, there is a legitimate error
        else if (operation.responseData) {
            NSDictionary *response = [NSJSONSerialization JSONObjectWithData:operation.responseData options:0 error:nil];
            if ([response valueForKey:@"description"]) {
                NSString *responseString = [response valueForKey:@"description"];
                
                [SVProgressHUD showErrorWithStatus:responseString];
            }
            else {
                [SVProgressHUD showErrorWithStatus:@"Unable to login"];
            }
        }
        else {
            [SVProgressHUD showErrorWithStatus:@"Unable to login"];
        }
    }];
}

- (void)checkInUser {
    NSMutableDictionary *checkinParams = [[NSMutableDictionary alloc]init];
    [checkinParams setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults] objectForKey:@"latitude"]doubleValue]] forKey:@"latitude"];
    [checkinParams setObject:[NSNumber numberWithDouble:[[[NSUserDefaults standardUserDefaults] objectForKey:@"longitude"]doubleValue]]forKey:@"longitude"];
    [MMAPI checkUserIn:checkinParams success:^(AFHTTPRequestOperation *operation, id responseObject) {
        NSLog(@"%@", @"Checked In");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}

- (void)getAllCategories {
    [MMAPI getAllCategories:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //NSLog(@"%@", responseObject);
        NSMutableArray *arrayToCleanUp = [responseObject mutableCopy];
        NSMutableArray *cleanArray = [[NSMutableArray alloc]init];
        for (NSDictionary *dictionaryToCleanUp in arrayToCleanUp) {
            NSMutableDictionary *cleanDictionary = [[NSMutableDictionary alloc]init];
            id const nul = [NSNull null];
            for (NSString *key in dictionaryToCleanUp) {
                id const obj = [dictionaryToCleanUp valueForKey:key];
                if (nul == obj) {
                    [cleanDictionary setValue:@"" forKey:key];
                }
                else {
                    [cleanDictionary setValue:[dictionaryToCleanUp valueForKey:key] forKey:key];
                }
            }
            [cleanArray addObject:cleanDictionary];
        }
        
        [[NSUserDefaults standardUserDefaults]setObject:cleanArray forKey:@"allCategories"];
        [[NSUserDefaults standardUserDefaults]synchronize];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"%@", operation.responseString);
    }];
}

- (void)showMoreActionSheet:(UIViewController*)presentingViewController showFromTabBar:(BOOL)showFromTabBar paramsForPublishingToSocialNetwork:(NSDictionary*)paramsForPublishingToSocialNetwork {
    presentingVC = presentingViewController;
    storyToPublishToSocialNetworkDictionary = paramsForPublishingToSocialNetwork;
    
    UIActionSheet *actionSheet = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:nil destructiveButtonTitle:nil otherButtonTitles:nil];
    [actionSheet addButtonWithTitle:@"Save to Camera Roll"];
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    if ([prefs boolForKey:@"facebookEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Facebook"];
    }
    if ([prefs boolForKey:@"twitterEnabled"]) {
        [actionSheet addButtonWithTitle:@"Share on Twitter"];
    }
    [actionSheet addButtonWithTitle:@"Flag for Review"];
    actionSheet.cancelButtonIndex = [actionSheet addButtonWithTitle:@"Cancel"];
    if (showFromTabBar) {
        [actionSheet showFromTabBar:presentingViewController.tabBarController.tabBar];
    }
    else {
        [actionSheet showInView:presentingViewController.view];
    }
}

#pragma mark - Action Sheet Delegate Methods
-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    NSString *buttonTitle = [actionSheet buttonTitleAtIndex:buttonIndex];
    if ([buttonTitle isEqualToString:@"Save to Camera Roll"]) {
        if ([storyToPublishToSocialNetworkDictionary valueForKey:@"image"]) {
            UIImageWriteToSavedPhotosAlbum([storyToPublishToSocialNetworkDictionary valueForKey:@"image"], self, @selector(image:didFinishSavingWithError:contextInfo:), nil);
        }
        else {
            [self saveVideoToCameraRoll];
        }
    }
    if ([buttonTitle isEqualToString:@"Share on Facebook"]) {
        [self shareViaFacebook:storyToPublishToSocialNetworkDictionary presentingViewController:presentingVC];
    }
    else if ([buttonTitle isEqualToString:@"Share on Twitter"]) {
        [self shareViaTwitter:storyToPublishToSocialNetworkDictionary presentingViewController:presentingVC];
    }
    else if ([buttonTitle isEqualToString:@"Flag for Review"]) {
        
    }
    
}

#pragma mark - Helper Methods
- (void)saveVideoToCameraRoll {
    dispatch_queue_t backgroundQueue = dispatch_queue_create("com.MobMonkey.SaveVideo", NULL);
    dispatch_async(backgroundQueue, ^(void) {
        NSString *stringURL = [storyToPublishToSocialNetworkDictionary valueForKey:@"url"];
        NSURL  *url = [NSURL URLWithString:stringURL];
        NSData *urlData = [NSData dataWithContentsOfURL:url];
        if ( urlData )
        {
            NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [paths objectAtIndex:0];
            
            NSString  *filePath = [NSString stringWithFormat:@"%@/%@", documentsDirectory,@"filename.mp4"];
            [urlData writeToFile:filePath atomically:YES];
            
            UISaveVideoAtPathToSavedPhotosAlbum(filePath, self, @selector(video:didFinishSavingWithError:contextInfo:), nil);
        }
    });
}

#pragma mark - Save To Camera Roll Completion Methods
- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    // Was there an error?
    if (error != NULL)
    {
        [SVProgressHUD showErrorWithStatus:@"Unable to save. Please try again"];
        
    }
    else  // No errors
    {
        // Show message image successfully saved
        [SVProgressHUD showSuccessWithStatus:@"Saved"];
    }
}

- (void)video: (NSString *) videoPath didFinishSavingWithError: (NSError *) error contextInfo: (void *) contextInfo {
    dispatch_async(dispatch_get_main_queue(), ^(void) {
        if (error != NULL)
        {
            [SVProgressHUD showErrorWithStatus:@"Unable to save. Please try again"];
            
        }
        else  // No errors
        {
            // Show message image successfully saved
            [SVProgressHUD showSuccessWithStatus:@"Saved"];
        }
    });
}

@end
