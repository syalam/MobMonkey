//
//  FactualQueryPrivate.h
//  FactualSDK
//
//  Copyright 2010 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactualQuery.h"

typedef enum {
    Eq,
    NEq,
    Gt,
    Lt,
    GtEq,
    LtEq,
    BeginsWith,
    Search,
    NotBeginsWith,
    Blank,
    Includes
} SimplePredicateType;

typedef enum {
    In,
    NotIn,
    BeginsWithAny,
    NotBeginsWithAny,
    IncludesAny
} CompoundValuePredicateType;

typedef enum {
    And,
    Or
} CompoundFilterPredicateType;

/* -----------------------------------------------------------------------------
 FactualRowFilter(Private) 
 ------------------------------------------------------------------------------*/
@interface FactualRowFilter(Private)

-(void) appendToDictionary:(NSMutableDictionary*) dictionary;

@end


/* -----------------------------------------------------------------------------
 FactualSimpleValueFilterPredicate 
 ------------------------------------------------------------------------------*/

@interface FactualSimpleValueFilterPredicate : FactualRowFilter {
    NSString* _fieldName;
    SimplePredicateType _type;
    id _value;
}

@property (nonatomic,copy)   NSString* fieldName;
@property (nonatomic,assign) SimplePredicateType type;
@property (nonatomic,retain) id value;


-(id) initWithPredicateType:(SimplePredicateType) type fieldName:(NSString*) fieldName value:(id)value;

@end


/* -----------------------------------------------------------------------------
 FactualCompoundRowFilterPredicate 
 ------------------------------------------------------------------------------*/

@interface FactualCompoundRowFilterPredicate : FactualRowFilter {
    CompoundFilterPredicateType _type;
    NSMutableArray* _filters;
}

@property (nonatomic,assign) CompoundFilterPredicateType type;
@property (nonatomic,readonly) NSMutableArray* filterValues;

-(id) initWithPredicateType:(CompoundFilterPredicateType) type filterValues:(NSArray*) filterValues;

@end

/* -----------------------------------------------------------------------------
 FactualCompoundValueFilterPredicate 
 ------------------------------------------------------------------------------*/

@interface FactualCompoundValueFilterPredicate : FactualRowFilter
{
    CompoundValuePredicateType _type;
    NSArray* _values;
    NSString* _fieldName;
}
@property (nonatomic,assign) CompoundValuePredicateType type;
@property (nonatomic,retain) NSArray* values;
@property (nonatomic,copy) NSString* fieldName;

-(id) initWithPredicateType:(CompoundValuePredicateType) type fieldName:(NSString*) fieldName  values:(NSArray*) values;


@end

/* -----------------------------------------------------------------------------
 FactualGeoFilter 
 ------------------------------------------------------------------------------*/

@interface FactualGeoFilter : FactualRowFilter

+(FactualGeoFilter*) createDistanceFromPointGeoFilter:(CLLocationCoordinate2D) location distance:(double)distance;

@end

/* -----------------------------------------------------------------------------
 FactualDistanceFromPointGeoFilter 
 ------------------------------------------------------------------------------*/

@interface FactualDistanceFromPointGeoFilter : FactualGeoFilter
{
    CLLocationCoordinate2D _location;
    double                 _radiusInMeters;
}

@property (nonatomic,assign) CLLocationCoordinate2D location;
@property (nonatomic,assign) double radius;

-(id) initWithLocation:(CLLocationCoordinate2D) location distance:(double)distance;

@end

/* -----------------------------------------------------------------------------
 FactualQueryImplementation 
 ------------------------------------------------------------------------------*/

@interface FactualQueryImplementation : FactualQuery {
    NSString*   _rowId;
    NSUInteger  _offset;
    NSUInteger  _limit;
    FactualSortCriteria* _primarySortCriteria;
    FactualSortCriteria* _secondarySortCriteria;
    NSMutableArray*    _rowFilters;
    NSMutableArray*    _textTerms;
    FactualGeoFilter* _geoFilter;
    NSMutableArray*    _selectTerms;
    NSUInteger  _minCountPerFacetValue;
    NSUInteger  _maxValuesPerFacet;
}
@property(nonatomic,retain)   FactualGeoFilter* geoFilter;

-(void) generateQueryString:(NSMutableString*)intoString;

@end

/* -----------------------------------------------------------------------------
 FactualSortCriteria 
 ------------------------------------------------------------------------------*/

@interface FactualSortCriteria(PrivateMethods)

-(void) generateQueryString:(NSMutableString*) intoString;

@end
