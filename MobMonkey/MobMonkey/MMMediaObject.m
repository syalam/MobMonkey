//
//  MMMediaObject.m
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMediaObject.h"

@implementation MMMediaObject 


+(MMMediaObject *)getMediaObjectForMediaDictionary:(NSDictionary *)mediaDictionary{
   
    
    MMMediaObject *mediaObject = [[self alloc] init];
    
    
    // Media URL
    NSString *mediaURLPath = [mediaDictionary objectForKey:@"mediaURL"];

    if(mediaURLPath && ![mediaURLPath isEqual:[NSNull null]] && mediaURLPath.length > 0) {
        NSURL *mediaURL = [NSURL URLWithString:mediaURLPath];
        mediaObject.mediaURL = mediaURL;
    }
    
    
    // Media Type
    NSString *type = [mediaDictionary objectForKey:@"type"];
    
    if(type && ![type isEqual:[NSNull null]] && type.length > 0){
        
        if([type isEqualToString:@"image"]){
            mediaObject.mediaType = MMMediaTypePhoto;
        }else if ([type isEqualToString:@"livevideo"]){
            mediaObject.mediaType = MMMediaTypeLiveVideo;
        } else if([type isEqualToString:@"video"]){
            mediaObject.mediaType = MMMediaTypeVideo;
        } else if([type isEqualToString:@"text"]){
            mediaObject.mediaType = MMMediaTypeVideo;
        }
        
    }
    
    //Thumbnail URL
    NSString *thumbURLPath = [mediaDictionary objectForKey:@"thumbURL"];
    
    if(thumbURLPath && ![thumbURLPath isEqual:[NSNull null]] && thumbURLPath.length > 0) {
        NSURL *thumbURL = [NSURL URLWithString:thumbURLPath];
        mediaObject.highResImageURL = thumbURL;
    }
    
    //Expiry Date
    NSString *expiryDateString = [mediaDictionary objectForKey:@"expiryDate"];
    
    if(expiryDateString && ![expiryDateString isEqual:[NSNull null]]) {
        mediaObject.expiryDateString = expiryDateString;
    }
    
    return mediaObject;
}
@end
