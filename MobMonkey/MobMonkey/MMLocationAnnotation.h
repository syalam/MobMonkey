//
//  MMLocationAnnotation.h
//  MobMonkey
//
//  Created by Sheehan Alam on 7/19/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <MapKit/MapKit.h>

@interface MMLocationAnnotation : MKAnnotationView
{
    NSString *_name;
    NSString *_address;
    CLLocationCoordinate2D _coordinate;
}

@property (copy) NSString *name;
@property (copy) NSString *address;
@property (nonatomic) int arrayIndex;
@property (nonatomic) CLLocationCoordinate2D coordinate;

- (id)initWithName:(NSString*)name address:(NSString*)address coordinate:(CLLocationCoordinate2D)coordinate arrayIndex:(int)arrayIndex;

@end
