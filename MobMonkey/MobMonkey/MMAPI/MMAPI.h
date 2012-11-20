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
               provider:(OAuthProvider)provider
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
*/
+ (void)facebookSignIn;

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
/// @name Fetches a list of open requests from the server
///---------------------------------------------
/**
 Retrieve list of open requests from the server
 */
+ (void)getOpenRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)getLocationsInOpenRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

///---------------------------------------------
/// @name Fetches a list of assigned requests from the server
///---------------------------------------------
/**
 Retrieve list of assigned requests from the server
 */
+ (void)getAssignedRequests:(NSMutableDictionary*)params
                    success:(void (^)(AFHTTPRequestOperation *operation, id responseObject))success
                    failure:(void (^)(AFHTTPRequestOperation *operation, NSError *error))failure;


+ (void)getAssignedRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
+ (void)getLocationsInAssignedRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;
///---------------------------------------------
/// @name Fetches a list of fulfilled requests from the server
///---------------------------------------------
/**
 Retrieve list of fulfilled requests from the server
 */

+ (void)getFulfilledRequestsOnSuccess:(void (^)(id responseObject))success failure:(void (^)(NSError *error))failure;

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
+ (void)searchForLocation:(NSDictionary*)params
                  success:(void (^)(id responseObject))success
                  failure:(void (^)( NSError *error))failure;


@property (nonatomic, assign)id<MMAPIDelegate> delegate;


///---------------------------------------------
/// @name Fetches media counts for a location
///---------------------------------------------
/**
Fetches media counts for a location
 */
- (void)fetchMediaCountsForLocation:(NSDictionary*)params;

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
                             success:(void (^)(id responseObject))success
                             failure:(void (^)(NSError *error))failure;

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

@end
