//
//  FactualQuery.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

typedef enum  {
    FactualSortOrder_Ascending,
    FactualSortOrder_Descending
    
} FactualSortOrder;

/*! @abstract Encapsulates sort criteria, including field name and sort order 
 @discussion
 Factual currently supports a two level sort. Use this data structure in the 
 Query object (see below) to specify the primary or secondary sort criteria.
 */
@interface FactualSortCriteria : NSObject {
    NSString* _fieldName;
    FactualSortOrder _sortOrder;
}
/*! @property 
 @discussion the field, within the factual table, to sort by
 */ 
@property (nonatomic, copy) NSString* fieldName;
/*! @property 
 @discussion the sort direction (ascending or descending)
 */ 
@property (nonatomic) FactualSortOrder sortOrder;

/*! @method 
 @discussion initializer used to create sort criteria  
 */ 
-(id) initWithFieldName:(NSString*) fieldName sortOrder:(FactualSortOrder) order;

@end

/*!@abstract Represents single or groups of  filter predicates. 
 @discussion
 
 You can associate an arbitrary number for row filters to Factual Query. Row filters 
 can either be a simple field name predicate value triple, or an AND or OR 
 predicate than contains one or more row filters. All top level row filters 
 are ANDed together during query execution time (including the full text and 
 geo filters - see Query). 
 
 A simple filter can be constructed as follows: 
 FactualRowFilter* simpleFilter = [FactualRowFilter fieldName:\@"name" 
 equalTo:\@"John Bolton"];
 An AND might be constructed as follows: 
 FactualRowFilter* andFilter = [FactualRowFilter andFilter: 
 [FactualRowFilter fieldName:\@"name" equalTo:\@"John Bolton"],
 [FactualRowFilter orFilter:
 [FactualRowFilter fieldName:\@"profession" equalTo:\@"Singer"],
 [FactualRowFilter fieldName:\@"profession" equalTo:\@"SongWriter"]]];
 
 which basically bolis down to: 
 name="JohnBolton" AND (profession="Singer" OR profession="SongWriter")
 
 */
@interface FactualRowFilter : NSObject 

/*! @method 
 @discussion construct an equalTo filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*)  fieldName equalTo:(id) value;
/*! @method 
 @discussion construct a notEqualTo filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*)  fieldName notEqualTo:(id) value;

/*! @method 
 @discussion construct a greater than filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName greaterThan:(id) value;
/*! @method 
 @discussion construct a less than filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName lessThan:(id) value;
/*! @method 
 @discussion construct a greater than or equal to filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName greaterThanOrEqualTo:(id) value;
/*! @method 
 @discussion construct a less than or equal to filter
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName lessThanOrEqualTo:(id) value;
/*! @method 
 @discussion construct an OR filter using the IN predicate
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName In:(id) value,... NS_REQUIRES_NIL_TERMINATION;
/*! @method 
 @discussion construct an OR filter using the IN predicate with an array of values 
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName InArray:(NSArray*) values;

/*! @method 
 @discussion construct a prefix match text filter (on a particular field)
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName beginsWith:(NSString*) value;

/*! @method 
 @discussion construct a full text search filter (on a particular field)
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName search:(NSString*) value;

/*! @method 
 @discussion construct a filter where the field does not begin with a value
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName notBeginsWith:(NSString*) value;

/*! @method 
 @discussion construct a filter where the field is blank
 */ 
+(FactualRowFilter*) fieldBlank:(NSString*) fieldName;

/*! @method 
 @discussion construct a filter where the field is not blank
 */ 
+(FactualRowFilter*) fieldNotBlank:(NSString*) fieldName;

/*! @method 
 @discussion construct a filter where the field does not equal any of the specified values
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName notInArray:(NSArray*) values;

/*! @method 
 @discussion construct a filter where the field begins with any of the specified values
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName beginsWithAnyArray:(NSArray*) values;

/*! @method 
 @discussion construct a filter where the field does not begin with any of the specified values
 */ 
+(FactualRowFilter*) fieldName:(NSString*) fieldName notBeginsWithAnyArray:(NSArray*) values;


+(FactualRowFilter*) fieldName:(NSString*) fieldName includes:(NSString*) value;

+(FactualRowFilter*) fieldName:(NSString*) fieldName includesAnyArray:(NSArray*) values;

/*! @method 
 @discussion construct an OR filter consisting of one or more nested filters
 followed by a nil
 */ 
+(FactualRowFilter*) orFilter:(FactualRowFilter*)rowFilter,... NS_REQUIRES_NIL_TERMINATION;
/*! @method 
 @discussion construct an OR filter consisting of an array of nested filters 
 followed by a nil
 @throws NSException if NSArray value is nil or not of type FactualRowFilter
 */ 
+(FactualRowFilter*) orFilterWithArray:(NSArray*)rowFilters;

/*! @method 
 @discussion construct an AND filter consisting of one or more nested filters
 followed by a nil
 */ 
+(FactualRowFilter*) andFilter:(FactualRowFilter*)rowFilter,... NS_REQUIRES_NIL_TERMINATION;
/*! @method 
 @discussion construct an AND filter consisting of an array of nested filters 
 followed by a nil
 @throws NSException if NSArray value is nil or not of type FactualRowFilter
 */ 
+(FactualRowFilter*) andFilterWithArray:(NSArray*)rowFilters;

@end

/*!@abstract Encapsulates all the parameters supported by the Factual Query API
 @discussion
 
 To query a Factual table, you must first construct a Query object and specify 
 some basic row selection criteria. You can optionally construct an empty Query 
 object, which will return to you the first (limit) number of rows using a table's
 default sort order. There are some restrictions on what combinations of filters are 
 valid in certain circumstances. Read the property / method descriptions for more 
 details
 */
@interface FactualQuery : NSObject 

/*! @property 
 @discussion used to specify the offset (number of records to skip) when
 paginating a large record set.
 */ 
@property (nonatomic, assign) NSUInteger offset;
/*! @property 
 @discussion used to limit the number of returned records in a single response.
 This system will return the lessor of either the limit value or the max limit 
 value associated with the user's API Key.
 paginating a large record set.
 */ 
@property (nonatomic, assign) NSUInteger limit;

/*! @property 
 @discussion set the primary sort criteria for the query in context. This 
 parameter is ignored in the case of full-text (see below) or geo (see below 
 queries).
 */
@property (nonatomic,retain) FactualSortCriteria* primarySortCriteria;
/*! @property 
 @discussion set the secondary sort criteria for the query in context. Same
 restrictions as the pimrary sort criteria
 */
@property (nonatomic,retain) FactualSortCriteria* secondarySortCriteria;
/*! @property 
 @discussion row filter that are going to be applied to this query 
 */
@property (nonatomic,readonly) NSMutableArray* rowFilters;
/*! @property 
 @discussion text query terms used to perform a full-text query 
 */
@property(nonatomic,readonly) NSMutableArray* fullTextTerms;
/*! @property 
 @discussion when true, the response will include a count of the total number of rows in the table that conform to the request based on included filters.  Requesting the row count will increase the time required to return a response. The default behavior is to NOT include a row count 
 */
@property (nonatomic, assign) BOOL includeRowCount;

/*! @property 
 @discussion Sets the fields to select. This is optional.
 */
@property (nonatomic,readonly) NSMutableArray* selectTerms;

/*! @property 
 @discussion For each facet value count, the minimum number of results it must have in order to be returned in the response. Must be zero or greater. The default is 1.
 */ 
@property (nonatomic, assign) NSUInteger minCountPerFacetValue;

/*! @property 
 @discussion The maximum number of unique facet values that can be returned for a single field. Range is 1-250. The default is 25.
 */ 
@property (nonatomic, assign) NSUInteger maxValuesPerFacet;

@end

/*!@abstract methods supported by FactualQuery
 */

@interface FactualQuery(FactualQueryMethods)

+(FactualQuery*) query;

/*! @method 
 @discussion add a text term to the full-text filter associated with the  
 query. Full-text queries are only valid if support for them has been enabled
 in the target Factual table. Follow the last term by a nil. 
 */
-(void) addFullTextQueryTerm:(NSString*) textTerm;

/*! @method 
 @discussion add one or more text terms to the full-text filter associated with the 
 query. Full-text queries are only valid if support for them has been enabled
 in the target Factual table. Follow the last term by a nil. 
 */
-(void) addFullTextQueryTerms:(NSString*) textTerm,... NS_REQUIRES_NIL_TERMINATION;

/*! @method 
 @discussion add one or more text terms, contained within the passed in NSArray,
 to the full-text filter associated with the query. Full-text queries are only valid
 if support for them has been enabled in the target Factual table. Follow the last
 term by a nil. 
 */
-(void) addFullTextQueryTermsFromArray:(NSArray*) terms;

/*! @method 
 @discussion clear all text terms previosuly associated with this query object
 */
-(void) clearFullTextFilter;

/*! @method 
 @discussion search records by location and radius. This filter type is only 
 valid for geo-enabled tables and if specified, the returned record set is 
 sorted by distance from the specified point, so the primary and secondary 
 sort criteria query fields are ignored if a geo filter has been specified.
 */
-(void) setGeoFilter:(CLLocationCoordinate2D)location radiusInMeters:(double)radius;
/*! @method 
 @discussion clear the previously set geo filter state
 */
-(void) clearGeoFilter;

/*! @method 
 @discussion add one or more row filters to the query. Row filters further limit
 the query results by applying the specified filters against any records returned
 as a result of any other query filter operations (full-text / geo). 
 */
-(void) addRowFilter:(FactualRowFilter*) rowFilter;
/*! @method 
 @discussion clear all previously set row filters 
 */
-(void) clearRowFilters;

/*! @method 
 @discussion add a field to select
 */
-(void) addSelectTerm:(NSString*) selectTerm;

@end
