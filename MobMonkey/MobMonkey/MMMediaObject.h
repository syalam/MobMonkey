//
//  MMMediaObject.h
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    
    MMMediaTypePhoto = 1 ,
    MMMediaTypeVideo = 2,
    MMMediaTypeLiveVideo = 3,
    MMMediaTypeText
    
} MMMediaType;

#import <Foundation/Foundation.h>
#import "MMRequestObject.h"

@class MMRequestObject;

@interface MMMediaObject : NSObject

@property (nonatomic, assign) BOOL accepted;
@property (nonatomic, assign) NSUInteger contentType;
@property (nonatomic, strong) NSDate *expiryDate;
@property (nonatomic, strong) NSString * mediaID;
@property (nonatomic, strong) NSURL * mediaURL;
@property (nonatomic, strong) MMRequestObject * requestObject;
@property (nonatomic, strong) NSString * text;
@property (nonatomic, strong) NSURL * thumbURL;
@property (nonatomic, assign) MMMediaType mediaType;
@property (nonatomic, strong) NSDate *uploadDate;


+(MMMediaObject*)mediaObjectFromJSON:(NSDictionary *)jsonDictionary;

@end
