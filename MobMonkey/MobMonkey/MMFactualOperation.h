//
//  MMFactualOperation.h
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <FactualSDK/FactualAPI.h>

@interface MMFactualOperation : NSObject <FactualAPIDelegate>

+(id)factualOperationWithQuery:(FactualQuery *)query onTable:(NSString *)tableName setSuccessBlock:(void(^)(FactualQueryResult * queryResult))successBlock setFailureBlock:(void(^)(NSError *error))failureBlock;

-(void)start;
-(void)cancelRequest;

@end
