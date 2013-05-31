//
//  MMFactualOperation.m
//  MobMonkey
//
//  Created by Michael Kral on 5/30/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMFactualOperation.h"
#import "MMFactualAPI.h"

@interface MMFactualOperation()

@property (copy, nonatomic) void (^successBlock)(FactualQueryResult * queryResult);
@property (copy, nonatomic) void (^failureBlock)(NSError *error);
@property (nonatomic, strong) FactualQuery *query;
@property (nonatomic, strong) NSString *tableName;
@property (nonatomic, strong) FactualAPIRequest *activeRequest;

@end

@implementation MMFactualOperation

+(id)factualOperationWithQuery:(FactualQuery *)query
                       onTable:(NSString *)tableName
               setSuccessBlock:(void (^)(FactualQueryResult *))successBlock
               setFailureBlock:(void (^)(NSError *))failureBlock {
    
    MMFactualOperation *operation = [[self alloc] init];
    
    operation.successBlock = successBlock;
    operation.failureBlock = failureBlock;
    operation.query = query;
    operation.tableName = tableName;
    
    return operation;
    
}

-(void)start {
    
    _activeRequest = [[MMFactualAPI sharedAPI] queryTable:_tableName optionalQueryParams:_query withDelegate:self];
    
}

-(void)cancelRequest {
    [_activeRequest cancel];
}

#pragma mark - factual api delegate
-(void)requestComplete:(FactualAPIRequest *)request failedWithError:(NSError *)error {
    if(self.failureBlock){
        self.failureBlock(error);
    }
}
-(void)requestComplete:(FactualAPIRequest *)request receivedQueryResult:(FactualQueryResult *)queryResult {
    if(self.successBlock){
        self.successBlock(queryResult);
    }
}

@end
