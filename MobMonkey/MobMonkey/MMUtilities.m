//
//  MMUtilities.m
//  MobMonkey
//
//  Created by Reyaad Sidique on 8/11/12.
//
//

#import "MMUtilities.h"

@implementation MMUtilities

#pragma mark - Singleton Method
+ (MMUtilities *)sharedUtilities {
    static MMUtilities *_sharedUtilities = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedUtilities = [[MMUtilities alloc] init];
    });
    
    return _sharedUtilities;
}

//Method used to find the distance between two locations
- (float)calculateDistance:(NSString*)latitude longitude:(NSString*)longitude {
    CLLocation *restaurantLocation = [[CLLocation alloc]initWithLatitude:[latitude floatValue] longitude:[longitude floatValue]];
    CLLocation *myLocation = [[CLLocation alloc]initWithLatitude:[[[NSUserDefaults standardUserDefaults]valueForKey:@"latitude"]floatValue] longitude:[[[NSUserDefaults standardUserDefaults]valueForKey:@"longitude"]floatValue]];
    CLLocationDistance distance = [restaurantLocation distanceFromLocation:myLocation];
    
    //convert meters to miles
    return distance * 0.000621371192237334;
}

@end
