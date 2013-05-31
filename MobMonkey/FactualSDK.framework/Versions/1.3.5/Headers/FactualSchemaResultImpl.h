//
//  FactualSchemaResultImpl.h
//  FactualSDK
//
//  Copyright 2010 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactualSchemaResult.h"

@interface FactualSchemaResultImpl : FactualSchemaResult {
  
@public  
  NSString* _tableId;
  NSString* _tableName;
  NSString* _tableDescription;
  NSString* _creator;
  NSString* _createDateAndTime;
  NSString* _updateDateAndTime;
  BOOL _isGeoEnabled;
  BOOL _isDownloadable;
  NSString* _source;
  NSUInteger _totalRowCount;
  NSArray*  _fieldMetadata;
}

// initialization ... 
-(id) initFromJSON:(NSDictionary*) jsonResponse
           tableId:(NSString*) tableId;

@end
