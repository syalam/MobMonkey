//
//  MMLocationInformation.m
//  MobMonkey
//
//  Created by Michael Kral on 4/22/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMLocationInformation.h"

@interface MMLocationInformation ()

@property (nonatomic, strong) CLGeocoder *geocoder;

@end

@implementation MMLocationInformation
@synthesize geocoder;

-(void)geocodeLocationWithCompletionHandler:(void (^)(NSArray *, NSError *))completion {
    if(!geocoder){
        geocoder = [[CLGeocoder alloc] init];
    }
    
    NSMutableDictionary *addressDictionary = [NSMutableDictionary dictionaryWithCapacity:6];
    
    [addressDictionary setValue:self.name forKey:@"Name"];
    [addressDictionary setValue:self.street forKey:@"Street"];
    [addressDictionary setValue:self.city forKey:@"City"];
    [addressDictionary setValue:self.state forKey:@"State"];
    [addressDictionary setValue:self.zipCode forKey:@"ZIP"];
    [addressDictionary setValue:self.phoneNumber forKey:@"PhoneNumber"];
    
    [geocoder geocodeAddressDictionary:addressDictionary completionHandler:^(NSArray *placemarks, NSError *error) {
        if(completion){
            completion(placemarks, error);
        }
    }];
}
-(NSString *)formattedAddressString {
    
    NSMutableString * formattedString = [NSMutableString string];
    
    if(self.street && self.street != (id)[NSNull null]){
        [formattedString appendFormat:@"%@ ",self.street];
        
        if(self.unitNumber && self.unitNumber != (id)[NSNull null]){
            [formattedString appendString:self.unitNumber];
        }
        
        [formattedString appendString:@"\n"];
    }
    
    if(self.locality && self.locality != (id)[NSNull null]){
        [formattedString appendFormat:@"%@, ", self.locality];
    }
    
    if(self.region && self.region != (id)[NSNull null]) {
        [formattedString appendString:self.region];
    }
    
    if(self.zipCode && self.zipCode != (id)[NSNull null]){
        [formattedString appendString:self.zipCode];
    }
    
    return formattedString.length > 0 ? formattedString : nil;
}
-(NSString *)formattedAddressStringLine1{
    
    NSMutableString * formattedString = [NSMutableString string];
    
    if(self.street && self.street != (id)[NSNull null]){
        [formattedString appendFormat:@"%@ ",self.street];
        
        if(self.unitNumber && self.unitNumber != (id)[NSNull null]){
            [formattedString appendString:self.unitNumber];
        }
    }else{
        return nil;
    }
    
    return formattedString.length > 0 ? formattedString : nil;

    
}
-(NSString *)formattedAddressStringLine2 {
    
    NSMutableString * formattedString = [NSMutableString string];
    
    if(self.locality && self.locality != (id)[NSNull null]){
        [formattedString appendFormat:@"%@, ", self.locality];
    }
    
    if(self.region && self.region != (id)[NSNull null]) {
        [formattedString appendString:self.region];
    }
    
    if(self.zipCode && self.zipCode != (id)[NSNull null]){
        [formattedString appendString:self.zipCode];
    }
    
    return formattedString.length > 0 ? formattedString : nil;
}
@end
