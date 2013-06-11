//
//  MMMediaObject.m
//  MobMonkey
//
//  Created by Michael Kral on 5/15/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMediaObject.h"
#import "MMJSONCommon.h"

@implementation MMMediaObject 


+(MMMediaObject *)mediaObjectFromJSON:(NSDictionary *)jsonDictionary {
    
    /*
     
     accepted = 0;
     contentType = "<null>";
     expiryDate = 1370818922593;
     mediaId = "c0e1150a-d15c-40a2-bb98-00db16407f3f";
     mediaURL = "http://vod-cdn.mobmonkey.com/vod-c0e1150a-d15c-40a2-bb98-00db16407f3f.mp4";
     requestId = "469ea058-c787-4cbe-8006-e57d92b7a280";
     text = "<null>";
     thumbURL = "http://vod-cdn.mobmonkey.com/thumb-c0e1150a-d15c-40a2-bb98-00db16407f3f00001.png";
     type = video;
     uploadedDate = "<null>";
     
     */
    
    MMMediaObject * mediaObject = [[MMMediaObject alloc] init];
    
    
    NSNumber * acceptedBool = [MMJSONCommon boolFromServerBool:[jsonDictionary valueForKey:@"accepted"]];
    mediaObject.accepted = acceptedBool ? acceptedBool.boolValue : NO;
    mediaObject.expiryDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"expiryDate"]];
    mediaObject.mediaID = [jsonDictionary objectForKey:@"mediaId"];
    mediaObject.mediaURL = [MMJSONCommon urlFromServerPath:[jsonDictionary objectForKey:@"mediaURL"]];
    mediaObject.text = [jsonDictionary objectForKey:@"text"];
    mediaObject.thumbURL = [MMJSONCommon urlFromServerPath:[jsonDictionary objectForKey:@"thumbURL"]];
    
    NSString * typeString = [jsonDictionary objectForKey:@"type"];
    MMMediaType mediaType;
    if([typeString isEqualToString:@"livestreaming"]){
        mediaType = MMMediaTypeLiveVideo;
    }else if([typeString isEqualToString:@"video"]){
        mediaType = MMMediaTypeVideo;
    }else if ([typeString isEqualToString:@"image"]) {
        mediaType = MMMediaTypePhoto;
    }else if([typeString isEqualToString:@"text"]){
        mediaType = MMMediaTypeText;
    }
    
    mediaObject.mediaType = mediaType;
    mediaObject.uploadDate = [MMJSONCommon dateFromServerTime:[jsonDictionary valueForKey:@"uploadedDate"]];                     
    
    return mediaObject;
    
}
@end
