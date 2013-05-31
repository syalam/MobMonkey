//
//  FactualQueryResultImpl.h
//  FactualSDK
//
//  Copyright 2010 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactualQueryResult.h"


@interface FactualQueryResultImpl : FactualQueryResult {
    NSUInteger       _totalRows;
    NSMutableArray* _rows;
    NSArray* _columns;
    NSDictionary* _columnToIndex;
    NSString* _tableId;
    BOOL _deprecated;
}

+(FactualQueryResult *) queryResultFromJSON:(NSDictionary *)jsonResponse deprecated:(BOOL) deprecated;

-(id) initWithOnlyRows:(NSArray*) rows 
             totalRows:(NSUInteger) totalRows
               tableId:(NSString*) tableId
            deprecated:(BOOL) deprecated;


// get the row at the given index
-(FactualRow*) rowAtIndex:(NSInteger) index;  


@end
