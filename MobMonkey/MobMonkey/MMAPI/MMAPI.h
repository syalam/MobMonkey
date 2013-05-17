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
#import "MMMyInfo.h"
#import "MMLocationInformation.h"
#import "MMSocialNetworkModel.h"

typedef enum apiCall {
    kAPICallOpenRequests,
    kAPICallAssignedRequests,
    kAPICallFulfilledRequests,
    kAPICallFulfillRequest,
    kAPICallGetCategoryList,
    kAPICallLocationSearch,
    kAPICallSignUp,
    kAPICallCheckin,
} apiCall;

typedef enum OAuthProvider {
    OAuthProviderNone,
    OAuthProviderFacebook,
    OAuthProviderTwitter
} OAuthProvider;

@interface MMOAuth : NSObject

@property (nonatomic, strong) NSString *token;
@property (nonatomic, assign) OAuthProvider provider;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSString *deviceID;
@property (nonatomic, strong) NSString *providerString;

@end
@protocol MMAPIDelegate

@optional
- (void)MMAPICallSuccessful:(id)response;
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
+ (void)signUpNewUser:(NSDictionary*)params
              success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)getUserOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

+ (void)updateUserOnSuccess:(NSDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Newer version without dictionary
+ (void) updateUserInfo:(MMMyInfo *)userInfo
                    newPassword:(NSString *)newPassword
                     success:(void (^)(AFHTTPRequestOperation *, id))success
                     failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;

+(void)updateUserInfo:(MMMyInfo *)userInfo
            withOauth:(MMOAuth *)oauth
          newPassword:(NSString *)newPassword
              success:(void (^)(AFHTTPRequestOperation * operation, id responseObject))success
              failure:(void (^)(AFHTTPRequestOperation * opertaion, NSError * error))failure;
///---------------------------------------------
/// @name Signing in an existing user
///---------------------------------------------
/**
 Signs in a user
 @param params Dictionary object containing captured sign in information:
 eMailAddress
 password
*/
+ (void)signInWithEmail:(NSString *)email
               password:(NSString *)password
               params:(NSDictionary*)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

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
+ (void)requestMedia:(NSString*)mediaType params:(NSMutableDictionary*)params
             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Sign's a user in with Facebook
///---------------------------------------------
/**
 facebook sign in/sign up
 @param facebook session id
*/

+ (void)oauthSignIn:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//This is a non-dictionary dependant version of the oauthSignIn method

+(void)oauthSignIn:(MMOAuth *)oauth
          userInfo:(MMMyInfo *)userInfo
        forService:(SocialNetwork)socialNetwork
           success:(void (^)(AFHTTPRequestOperation *, id))success
           failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;



///---------------------------------------------
/// @name Register email address for twitter user
///---------------------------------------------
/**
 Register email address for twitter user
 @param facebook session id
 */

+ (void)registerTwitterUserDetails:(NSDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//NEW MTHOD -- NO Dictionaries

+ (void) registerTwitterWithOauth:(MMOAuth*)oauth userInfo:(MMMyInfo *)userInfo
                          success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                          failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Sign's a user in with Twitter
///---------------------------------------------
/**
 Twitter sign in/sign up
 @param twitter o auth token
 */

+ (void)TwitterSignIn:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Sign user out of app
///---------------------------------------------
/**
 sign user out of app
 @param Type
 */
+ (void)signOut:(NSDictionary*)params
        success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
        failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Fetches a list of top level categories from the server
///---------------------------------------------
/**
 Retrieve list of top level categories from the server
 @return An array of categories
*/
+ (void)getCategoriesOnSuccess:(void (^)(AFHTTPRequestOperation *, id))success failure:(void (^)(AFHTTPRequestOperation *, NSError *))failure;


///---------------------------------------------
/// @name Fetches a list of all categories from the server
///---------------------------------------------
/**
 Retrieve list of all categories from the server
 @return An array of categories
 */
+ (void)getAllCategories:(NSMutableDictionary*)params
                 success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                 failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;



///---------------------------------------------
/// @name Fetches a count of how many items are in each of the inbox categories
///---------------------------------------------
/**
 Fetches a count of how many items are in each of the inbox categories
 */
+ (void)getInboxCounts:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Fetches a list of open requests from the server
///---------------------------------------------
/**
 Retrieve list of open requests from the server
 */
+ (void)getOpenRequests:(NSMutableDictionary*)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Fetches a list of assigned requests from the server
///---------------------------------------------
/**
 Retrieve list of assigned requests from the server
 */
+ (void)getAssignedRequests:(NSMutableDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name deletes and open media request
///---------------------------------------------
/**
 deletes and open media request
 params:
 requestId
 isRecurring
 */
+ (void)deleteMediaRequest:(NSDictionary *)params
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// Delete a location
///---------------------------------------------
/**
 @param locationInformation The MMLocationInformation Object to be deleted from server
 @param success Successful Deletion Block
 @param failure Failed Deletion Block
 */
+ (void)deleteLocation:(MMLocationInformation *)locationInformation
                   success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                   failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Fetches a list of fulfilled requests from the server
///---------------------------------------------
/**
 Retrieve list of fulfilled requests from the server
 */


+ (void)getFulfilledRequests:(NSMutableDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure; 

///---------------------------------------------
/// @name Adds a new location to the system
///---------------------------------------------
/**
 Adds a new location to the system
 */
+ (void)addNewLocation:(NSDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Send user's coordinates to the server to "check in"
///---------------------------------------------
/**
 Checks in a user
 */
+ (void)checkUserIn:(NSDictionary*)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name fulfills a request for a video or image
///---------------------------------------------
/**
 Fulfills a request
 */
+ (void)fulfillRequest:(NSString*)mediaType params:(NSMutableDictionary*)params
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name search for a location
///---------------------------------------------
/**
 search for a location
 */
+ (void)searchForLocation:(NSMutableDictionary*)params mediaType:(NSString*)mediaType
               success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
               failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//NEW METHOD
+ (void)searchForLocations:(NSMutableDictionary*)params mediaType:(NSString*)mediaType
                  success:(void (^)(AFHTTPRequestOperation *operation, NSArray *locationInformations))success
                  failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


@property (nonatomic, assign)id<MMAPIDelegate> delegate;

///---------------------------------------------
/// @name Fetches livestreaming URLs for a location
///---------------------------------------------
/**
Fetches livestreaming URLs for a location
 */
+ (void)getMediaForLocationID:(NSString *)locationID
                   providerID:(NSString *)providerID
                      success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Fetches Bookmarks
///---------------------------------------------
/**
 Fetches Bookmarks
 */
+ (void)getBookmarksOnSuccess:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


//NEW METHOD

+ (void)getBookmarkLocationInformationOnSuccess:(void (^)(AFHTTPRequestOperation *operation, NSArray *locationInformations ))success
                      failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Creates a Bookmark
///---------------------------------------------
/**
 Creates a Bookmark
 */
+ (void)createBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Delete a Bookmark
///---------------------------------------------
/**
 Delete a Bookmark
 */
+ (void)deleteBookmarkWithLocationID:(NSString *)locationID
                          providerID:(NSString *)providerID
                             success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                             failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Get Trending Type
///---------------------------------------------
/**
 Get Trending Type
 */
+ (void)getTrendingType:(NSString *)type params:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

///---------------------------------------------
/// @name Get Location Info
///---------------------------------------------
/**
 Get Location Info
 */
+ (void)getLocationInfo:(NSDictionary *)param
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;

//Newer Method
+(void)getLocationWithID:(NSString *)locationID
              providerID:(NSString *)providerID
                 success:(void(^)(AFHTTPRequestOperation *operation , MMLocationInformation *locationInformation))success
                 failure:(void(^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Reject Media
///---------------------------------------------
/**
 Reject media
 Query parameters need to be passed in the URL:
 RequestId = The unique identifier for a submitted request Example (0f2f91b3-43e0-43a2-a201-f0b5e16c1500)
 mediaId = The unique identifier for for a media uploaded for the request. Example (222e736f-c7fa-4c40-b78e-d99243441fae is factual's provider ID).
 */
+ (void)rejectMedia:(NSDictionary *)params
                success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Accept Media
///---------------------------------------------
/**
 Accept media
 Query parameters need to be passed in the URL:
 RequestId = The unique identifier for a submitted request Example (0f2f91b3-43e0-43a2-a201-f0b5e16c1500)
 mediaId = The unique identifier for for a media uploaded for the request. Example (222e736f-c7fa-4c40-b78e-d99243441fae is factual's provider ID).
 */
+ (void)acceptMedia:(NSDictionary *)params
            success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
            failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


///---------------------------------------------
/// @name Subscribe User
///---------------------------------------------
/**
    Subscribe User
 
 @param userEmail This is the user's id email
 @param partnerId This is the user's partner ID
 @param Returns success block if subscription was successful
 @param Returns failure block if subscription was unsucceful
 
 */
+(void)subscribeUserEmail:(NSString *)userEmail partnerId:(NSString *)partnerId success:(void(^)(void))success failure:(void(^)(NSError * error))failure;

+(void)createSubLocationWithLocationInformation:(MMLocationInformation*)locationInformation success:(void(^)(void))success failure:(void(^)(NSError * error))failure;


+(MMLocationInformation *)locationInformationForLocationDictionary:(NSDictionary *)locationDictionary;
+(NSDictionary *)locationDictionaryForLocationInformation:(MMLocationInformation *)locationInformation;

@end
