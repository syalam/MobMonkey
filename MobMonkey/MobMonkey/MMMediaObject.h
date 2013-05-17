//
//  MMMediaObject.h
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

typedef enum {
    
    MMMediaTypePhoto = 1 ,
    MMMediaTypeVideo,
    MMMediaTypeLiveVideo,
    MMMediaTypeText
    
} MMMediaType;

#import <Foundation/Foundation.h>

@interface MMMediaObject : NSObject

@property (nonatomic, strong) UIImage *lowResImage;
@property (nonatomic, strong) UIImage *highResImage;
@property (nonatomic, strong) NSURL *lowResImageURL;
@property (nonatomic, strong) NSURL *highResImageURL;
@property (nonatomic, strong) NSURL *mediaURL;
@property (nonatomic, strong) NSString *locationID;
@property (nonatomic, strong) NSString *providerID;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) MMMediaType mediaType;
@property (nonatomic, strong) NSString *expiryDateString;

+(MMMediaObject*)getMediaObjectForMediaDictionary:(NSDictionary *)mediaDictionary;

@end
