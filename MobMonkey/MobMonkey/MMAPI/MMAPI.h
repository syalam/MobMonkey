//
//  MMAPI.h
//  MobMonkey
//
//  Created by Sheehan Alam on 8/29/12.
//
//

#import <Foundation/Foundation.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AFJSONRequestOperation.h"


typedef enum apiCall {
    kAPICallOpenRequests,
    kAPICallAssignedRequests,
}apiCall;

@protocol MMAPIDelegate

@optional
- (void)MMAPICallSuccessful:(NSDictionary*)response;
- (void)MMAPICallFailed:(AFHTTPRequestOperation*)operation;


@end

@interface MMAPI : NSObject
///---------------------------------------------
/// @name Creating and Initializing API Clients
///---------------------------------------------

/**
 Creates and initializes an `MMAPI` object.
  
 @return The newly-initialized API client
 */

+(MMAPI *)sharedAPI;

///---------------------------------------------
/// @name Signing up a new user
///---------------------------------------------

/**
 Signs up a new user in the MobMonkey system
 
 @param params Dictionary object containing captured sign up information:
 first name
 last name
 e-mail address
 password
 birthday
 gender
 phone number (optional)
 latitude
 longitude
 city (optional)
 state (optional)
 tos - YES/NO
 */
-(void)signUpNewUser:(NSDictionary*)params;

///---------------------------------------------
/// @name Signing in an existing user
///---------------------------------------------
/**
 Signs in a user
 @param params Dictionary object containing captured sign in information:
 eMailAddress
 password
*/
-(void)signInUser:(NSDictionary*)params;

///---------------------------------------------
/// @name Sends a media request to the server
///---------------------------------------------
/**
 Sends media request
 @param media type is a string object to determine whether this is a video or photo request
 @param params dictionary object containing captured request information
 message
 duration
 scheduleMins
 providerId
 locationId
 scheduleDate
 recurring
 latitude
 longitude
 radiusInYards
*/
-(void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params;

///---------------------------------------------
/// @name Sign's a user in with Facebook
///---------------------------------------------
/**
 facebook sign in/sign up
*/
-(void)facebookSignIn;

///---------------------------------------------
/// @name Fetches a list of categories from the server
///---------------------------------------------
/**
 Retrieve list of categories from the server
 @return An array of categories
*/
-(NSMutableArray *)categories;

///---------------------------------------------
/// @name Fetches a list of open requests from the server
///---------------------------------------------
/**
 Retrieve list of open requests from the server
 */
-(void)openRequests;

///---------------------------------------------
/// @name Fetches a list of assigned requests from the server
///---------------------------------------------
/**
 Retrieve list of assigned requests from the server
 */
-(void)assignedRequests;

///---------------------------------------------
/// @name Adds a new location to the system
///---------------------------------------------
/**
 Adds a new location to the system
 */
-(void)addNewLocation:(NSDictionary*)params;


///---------------------------------------------
/// @name Send user's coordinates to the server to "check in"
///---------------------------------------------
/**
 Checks in a user
 */
-(void)checkUserIn:(NSDictionary*)params;


@property (nonatomic, assign)id<MMAPIDelegate> delegate;

@end
