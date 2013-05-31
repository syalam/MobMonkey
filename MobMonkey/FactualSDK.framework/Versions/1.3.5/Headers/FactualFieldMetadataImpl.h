//
//  FactualFieldMetadataImpl.h
//  FactualSDK
//
//  Copyright 2010 Factual Inc. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FactualFieldMetadata.h"

@interface FactualFieldMetadataImpl : FactualFieldMetadata {
  NSDictionary* _fieldData;
}

// initialization 
-(id) initFromJSON:(NSDictionary*) jsonResponse;

@end
