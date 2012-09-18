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

@protocol MMAPIDelegate

@optional
- (void)mmAPICallSuccessful:(NSDictionary*)response;
- (void)mmAPICallFailed:(AFHTTPRequestOperation*)operation;


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

/**
 Signs in a user
 @param params Dictionary object containing captured sign in information:
 eMailAddress
 password

*/
-(void)signInUser:(NSDictionary*)params;

/**
 sends media request
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

/**
 facebook sign in/sign up
*/
-(void)facebookSignIn;


@property (nonatomic, assign)id<MMAPIDelegate> delegate;

@end
