//  FactualAPI.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//


/*!
 @header FactulAPI.h
 This is the primary header file for the Factual IPhone SDK
 */

#import <Foundation/Foundation.h>
#import "FactualAPIRequest.h"
#import "FactualQueryResult.h"
#import "FactualQuery.h"
#import "FactualRowMetadata.h"


// forward declare delegate ...
@protocol FactualAPIDelegate;


/*!@abstract Top level object than provides an entry point into the Factual API.
 @discussion
 You need to specify the Factual API during initialization.
 The init call is non-blocking and does not perform any network IO. This class
 performs all network IO in an asynchronous manner and all API requests
 take a FactualAPIDelegate reference and return a FactulAPIRequest
 object. You can hold on to (retain) the Request object for future request
 identification purposes. All results (success and failuers) come through the
 delegate methods, each of which tag the corresponding Request context object
 as their first parameter. You can also use the Request object to safely
 cancel outstanding API requests. Once a request has failed or completed and
 has notified of this state transition, you can release your reference to the
 Request object and it will automatically be garbage collected (autorelease).
 
 Each Request type in the Factual API has a corresponding return (Response)
 type. All information related to the query and resulting data is self
 contained in the response object and can be freely discarded or retained at
 the user's discretion.
 
 */
@interface FactualAPI : NSObject {
    
    // internal data members ...
@private
    NSString*              _apiKey;
    NSString*              _secret;
    BOOL*                  _debug;
    NSTimeInterval         _timeoutInterval;
}

typedef enum  {
    FactualFlagType_Duplicate,
    FactualFlagType_Inaccurate,
    FactualFlagType_Inappropriate,
    FactualFlagType_Nonexistent,
    FactualFlagType_Spam,
    FactualFlagType_Other
} FactualFlagType;


/*! @property
 @discussion Returns the read-only api-key used to authenticate a connection
 to Factual
 */
@property (nonatomic, readonly) NSString* apiKey;
/*! @property
 @discussion Returns the version number of the Factual API for
 debugging purposes.
 */
@property (nonatomic, readonly) NSInteger apiVersion;

/*! @property
 @discussion The base URL at which to contact Factual's API
 */
@property (nonatomic, retain) NSString* factualHome;

@property (nonatomic) BOOL* debug;

@property (nonatomic) NSTimeInterval timeoutInterval;

/*!
 @method
 @discussion Used to initialize the API. Pass in the API Key
 */
- (id) initWithAPIKey:(NSString*) apiKey secret:(NSString*) secret;

/*! @method
 
 @discussion Use this method to query a Factual table. You must
 specify the Factual table id. You can specify additional query
 parameters via the FactualQuery object, such as predicates (via
 FactualFilter), sort orders and row offsets and record limits. Upon
 successful execution you will recieve query results asynchronously via
 a call the requestComplete:receivedQueryResult: method on the
 delegate. Failures will result in a call to the
 requestComplete:failedWithError: method on the delegate. Please read
 the docs on FactualQueryResult for details about the data returned as
 a result of Query.
 
 @param tableId The name of the Factual table to query.
 
 @param queryParams (optional) And optional FactualQuery object to use
 to restrict the server query and the returned recordset.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)  queryTable:(NSString*) tableId
               optionalQueryParams:(FactualQuery*) queryParams
                      withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method submit a GET request against Factual. You
 can specify query parameters. Upon successful execution you will
 recieve a response asynchronously via a call the
 requestComplete:receivedRawResult: method on the delegate. Failures
 will result in a call to the requestComplete:failedWithError: method
 on the delegate.
 
 @param path The path the run the request against.
 
 @param params The parameters as key value pairs to send with this
 request.
 
 @param delegate This is a reference to the delegate on which
 callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   get:(NSString*) path
                      params:(NSDictionary*) params
                withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to perform a geopulse query at a
 specified point.  Upon successful execution you will recieve query
 results asynchronously via a call the
 requestComplete:receivedQueryResult: method on the delegate. Failures
 will result in a call to the requestComplete:failedWithError: method
 on the delegate. Please read the docs on FactualQueryResult for
 details about the data returned as a result of Query.
 
 @param point The longitude and latitude point at which to run the
 geopulse query.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   queryGeopulse:(CLLocationCoordinate2D) point
                          withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to perform a geopulse query at a
 specified point.  Upon successful execution you will recieve query
 results asynchronously via a call the
 requestComplete:receivedQueryResult: method on the delegate. Failures
 will result in a call to the requestComplete:failedWithError: method
 on the delegate. Please read the docs on FactualQueryResult for
 details about the data returned as a result of Query.
 
 @param point The longitude and latitude point at which to run the
 geopulse query.
 
 @param selectTerms The fields to select from the geopulse results.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   queryGeopulse:(CLLocationCoordinate2D) point
                           selectTerms: (NSMutableArray*) selectTerms
                          withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to perform a reverse geocode lookup at a
 specified point.  Upon successful execution you will recieve query
 results asynchronously via a call the
 requestComplete:receivedQueryResult: method on the delegate. Failures
 will result in a call to the requestComplete:failedWithError: method
 on the delegate. Please read the docs on FactualQueryResult for
 details about the data returned as a result of Query.
 
 @param point The longitude and latitude point at which to run the
 reverse geocode.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   reverseGeocode:(CLLocationCoordinate2D) geocode
                           withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to query Factual for monetize data. You
 can specify additional parameters via the FactualQuery object, such
 as predicates (via FactualFilter), sort orders and row offsets and
 record limits. Upon successful execution you will recieve query
 results asynchronously via a call the
 requestComplete:receivedQueryResult: method on the delegate. Failures
 will result in a call to the requestComplete:failedWithError: method
 on the delegate. Please read the docs on FactualQueryResult for
 details about the data returned as a result of Query.
 
 @param queryParams (optional) And optional FactualQuery object to use
 to restrict the server query and the returned recordset.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   monetize:(FactualQuery*) queryParams
                     withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to run resolve against a Factual
 table. You must specify the Factual table id and values to use in the
 resolve. Upon successful execution you will recieve query results
 asynchronously via a call the requestComplete:receivedQueryResult:
 method on the delegate. Failures will result in a call to the
 requestComplete:failedWithError: method on the delegate. Please read
 the docs on FactualQueryResult for details about the data returned as
 a result of Query.
 
 @param tableId The name of the Factual table to query.
 
 @param values The key-value pairs for use in resolving to a valid
 entity.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   resolveRow:(NSString*) tableId
                         withValues:(NSDictionary*) values
                       withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to run match request against a Factual
 table. You must specify the Factual table id and values to use in the
 match. Upon successful execution you will recieve a factual id result
 asynchronously via a call the requestComplete:receivedMatchResult:
 method on the delegate. Failures will result in a call to the
 requestComplete:failedWithError: method on the delegate. Please read
 the docs on FactualQueryResult for details about the data returned as
 a result of Query.
 
 @param tableId The name of the Factual table to query.
 
 @param values The key-value pairs for use in matching to a valid
 entity.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   matchRow:(NSString*) tableId
                       withValues:(NSDictionary*) values
                     withDelegate:(id<FactualAPIDelegate>) delegate;

/*! @method
 
 @discussion Use this method to perform a facet query against a
 Factual table. You must specify the Factual table id. You can specify
 additional query parameters via the FactualQuery object, such as
 predicates (via FactualFilter), sort orders and row offsets and
 record limits. You can also specify additional facet request
 parameters.  Upon successful execution you will recieve facet results
 asynchronously via a call the requestComplete:receivedQueryResult:
 method on the delegate. Failures will result in a call to the
 requestComplete:failedWithError: method on the delegate. Please read
 the docs on FactualQueryResult for details about the data returned as
 a result.
 
 @param tableId The name of the Factual table to query.
 
 @param queryParams (optional) And optional FactualQuery object to use
 to restrict the server query and the returned recordset.
 
 @param delegate (optional) This is a reference to the delegate on
 which callbacks will be invoked.
 
 @result the FactualAPIRequest object associated with this API
 request.
 
 */
- (FactualAPIRequest*)   facetTable:(NSString*) tableId
                optionalQueryParams:(FactualQuery*) queryParams
                       withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*) getTableSchema:(NSString*) tableId
                         withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*) submitRow:(NSString*) tableId
                      withValues: (NSMutableDictionary*) values
                    withMetadata:(FactualRowMetadata*) metadata
                    withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*) submitRowWithId:(NSString*) factualId
                               tableId: (NSString*) tableId
                            withValues: (NSMutableDictionary*) values
                          withMetadata:(FactualRowMetadata*) metadata
                          withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*)    clearRowWithId:(NSMutableString*) factualId
                                 tableId: (NSMutableString*) tableId
                              withFields: (NSArray*) fields
                            withMetadata:(FactualRowMetadata*) metadata
                            withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*) flagProblem: (FactualFlagType) problem
                           tableId: (NSString*) tableId
                         factualId: (NSString*) factualId
                          metadata:(FactualRowMetadata*) metadata
                      withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*)   fetchRow:(NSString*) tableId
                        factualId:(NSString*) factualId
                     withDelegate:(id<FactualAPIDelegate>) delegate;

- (FactualAPIRequest*)   fetchRow:(NSString*) tableId
                        factualId:(NSString*) factualId
                             only:(NSArray*) only
                     withDelegate:(id<FactualAPIDelegate>) delegate;

@end


/*!
 @protocol FactualAPIDelegate
 @abstract Protocol which defines FactualAPI callback methods
 
 @discussion
 The Factual API is uses an asyncrhonous IO model, so all request completion/
 failure notifications arrive via the delegate callback methods. You can
 implement this protocol in your main UIViewController or your AppDelegate
 implementation. All callbacks should arrive in the context of the main UI
 thread as long as the related API call was initiated in the UI Thread as well.
 Each method in the protocol takes a FactualAPIRequest object, which is used
 to establish context about the callback. You can either (retain) a reference
 to the Request object or the NSString request identifier property and use
 either attribute to associate requests with callback responses.
 
 */
@protocol FactualAPIDelegate<NSObject>

@optional

/*! @discussion This method gets called when an initial server response
 is received for a Factual API call
 
 @param request The request context object
 */
- (void)requestDidReceiveInitialResponse:(FactualAPIRequest *)request;

/*! @discussion This method gets called every some data is received from
 the server with respect to a Factual API call
 
 @param request The request context object
 */
- (void)requestDidReceiveData:(FactualAPIRequest *)request;


/*! @discussion This method gets called when a API request fails due to either
 local network issues or server related issues. A description of the error
 is returned in the NSError object. No more callbacks will be initiated for
 the Request object in question
 
 @param request The request context object
 
 @param error The NSError description of the error
 */
- (void)requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error;

/*! @discussion This method gets called when a table query request successfully
 completes on the server. The results of the request are passed to the caller
 in the FactualQueryResult object. Please see related FactualQueryResult
 docs for more details.
 
 @param request The request context object
 
 @param queryResult The FactualQueryResult result object
 */
- (void)requestComplete:(FactualAPIRequest*) request receivedQueryResult:(FactualQueryResult*) queryResult;

/*! @discussion This method gets called when a raw read request successfully
 completes on the server. The results of the request are passed to the caller
 in as a NSDictionary object, corresponding to the parsed json result.
 
 @param request The request context object
 
 @param result The NSDictionary result object
 */
-(void) requestComplete:(FactualAPIRequest *)request receivedRawResult:(NSDictionary *)
result;

/*! @discussion This method gets called when a match request successfully
 completes on the server. The results of the request are passed to the caller
 in as a valid factual id if a match was found.
 
 @param request The request context object
 
 @param factualId a factual id for the resolved entity if Factual successfully identified the entity with full confidence, or null if the entity was not resolved
 */
- (void)requestComplete:(FactualAPIRequest*) request receivedMatchResult:(NSString*) factualId;


@end
