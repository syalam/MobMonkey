//
//  FactualTableRow.h
//  FactualSDK
//
//  Version 1.0
//  Copyright 2011 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>


/*!@abstract Object that encapsulates one row worth of data.
 @discussion
 This object cotains a collection of values, one for each field in the 
 associated Factual table. Rows are returned as a result of initiating a 
 FactualQuery. 
 
 Values can be accessed by their index position (using the FactualSchemaResult
 object for fieldName to index position resolution) or by their field name. In
 the latter case, the row will use an internal field name to index map for 
 index resolution. 
 
 Values can objects of the types: NSNumber (for numeric values),NSString,
 NSArray (for scalar results), or NSDictionary (for JSON objects). There are also
 two convenience methods, stringValueForName and stringValueAtIndex that coerce
 the source object type into a string before returning. 
 
 You can update a row's value by using the setValue methods, although any
 modifications to the row are strictly local; there is no way to update a 
 Factual Table directly via the manipulation of a FactualRow object. You have 
 to use the submitRowData method in FactualAPI to accomplish this task. You may
 however use the valuesAsDictionary method to return a collection of key/value
 pairs contained in the FactualRow object. This, however, involves an expensive 
 copy operation and should only be used in special circumstances. 
 
 Lastly, each row is identified in the Factual system by a special Row 
 Identifier. This Row Id is an opaque string and can be retrieved via the 
 rowId property of the row object. You can use this rowId to associate updates
 with a specific Factual Row. 
 
 */

@interface FactualRow : NSObject


/*! @property 
 @discussion The opaque row identifier associated with this particular row object.  nil if no row id exists.
 */ 
@property (nonatomic,readonly) NSString* rowId;

/*! @property 
 @discussion The name of the facet for this row object.  nil if no facet name exists.
 */ 
@property (nonatomic,readonly) NSString* facetName;

/*! @property 
 @discussion A dictionary of name value pairs.
 Each tuple consists of a column name (NSString) and associated value object
 ( NSNull,NSString,NSNumber,or NSArray).
 NOTE: The returned dictionary is sparse,so a each row in a set might contain 
 a different number of columns.
 */ 
@property (nonatomic,readonly)    NSDictionary* namesAndValues;

@end

/*!@abstract Convenince methods available to a row object
 */
@interface FactualRow(FactualRowImplementation)

/*! @method
 @discussion Get a field value given a field name. 
 Note: Null values are returned as NSNull objects
 */
-(id) valueForName:(NSString*) fieldName;

/*! @method
 @discussion Get a string value (potentially coerced from native type) 
 given a field name. 
 Note: Null values are returned as empty strings
 */
-(NSString*) stringValueForName:(NSString*) fieldName;


@end
