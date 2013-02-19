//
//  MMUtilities.h
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/11/12.
//
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>

@interface MMUtilities : NSObject

+(MMUtilities *)sharedUtilities;

- (float)calculateDistance:(NSString*)latitude longitude:(NSString*)longitude;

@end
