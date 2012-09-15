//
//  MMAPI.h
//  MobMonkey
//
//  Created by Sheehan Alam on 8/29/12.
//
//

#import <Foundation/Foundation.h>
#import "AFJSONRequestOperation.h"

@protocol MMAPIDelegate

@optional
//sign up delegate method definitions
- (void)signUpSuccessful:(NSDictionary*)userDictionary;
- (void)signUpFailed:(AFHTTPRequestOperation*)operation;

//sign in delegate methods
- (void)signInSuccessful:(NSDictionary*)userDictionary;
- (void)signInFailed:(AFHTTPRequestOperation*)operation;

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
 
 
 @return The newly created user object
 */
-(void)signUpNewUser:(NSDictionary*)params;
-(void)signInUser:(NSDictionary*)params;

@property (nonatomic, assign)id<MMAPIDelegate> delegate;

@end
