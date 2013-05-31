//
//  UrlUtil.h
//  FactualSDK
//
//  Created by Brandon Yoshimoto on 7/27/12.
//  Copyright (c) 2012 Facutal Inc. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreLocation/CoreLocation.h>

@interface FactualUrlUtil : NSObject
+(void) appendParams:(NSMutableArray*)array to: (NSMutableString*)qryString;

+(NSString*) locationToJson: (CLLocationCoordinate2D) location;

@end
