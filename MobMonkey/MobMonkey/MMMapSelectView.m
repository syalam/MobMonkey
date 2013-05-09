//
//  MMMapSelectView.m
//  MobMonkey
//
//  Created by Michael Kral on 5/3/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import "MMMapSelectView.h"
#import "AFNetworking.h"
#import <QuartzCore/QuartzCore.h>
#import "MMLocationAnnotation.h"

@implementation MMMapSelectView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, frame.size.width, 30)];
        label.text = @"Touch the Hot Spot Location on the map";
        label.textAlignment = NSTextAlignmentCenter;
        label.backgroundColor = [UIColor clearColor];
        [self addSubview:label];
        
        
        CGRect newFrame = frame;
        newFrame.size.width *= 0.94;
        newFrame.size.height *= 0.94;
        newFrame.size.height -= 30;
        self.mapView = [[MKMapView alloc] initWithFrame:CGRectMake((frame.size.width - newFrame.size.width)/2, (frame.size.height - newFrame.size.height)/2 + 5, newFrame.size.width, newFrame.size.height)];
        self.mapView.delegate = self;
        self.mapView.layer.cornerRadius = 8.0;
        self.mapView.layer.borderColor = [UIColor grayColor].CGColor;
        self.mapView.layer.borderWidth = 1.0;
        
        
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(mapTapped:)];
        tapGesture.numberOfTapsRequired = 1;
        
        [self.mapView addGestureRecognizer:tapGesture];
        
        [self addSubview:self.mapView];
    }
    return self;
}
-(void)setParentLocation:(MMLocationInformation *)parentLocation{
    
    CLLocationCoordinate2D parentLocationCoord = CLLocationCoordinate2DMake(parentLocation.latitude.floatValue, parentLocation.longitude.floatValue);
    [self setCenterPointCoordinates:parentLocationCoord];
    
    MMLocationAnnotation *parentPin = [[MMLocationAnnotation alloc] initWithName:parentLocation.name address:parentLocation.formattedAddressString coordinate:parentLocationCoord arrayIndex:0];
    parentPin.pinColor = MKPinAnnotationColorGreen;
    [self.mapView addAnnotation:(id)parentPin];

    
    _parentLocation = parentLocation;
}
-(void)setCenterPointCoordinates:(CLLocationCoordinate2D)centerPointCoordinates {
    
    
        [self centerMapAtCoordinates:centerPointCoordinates];
    _centerPointCoordinates = centerPointCoordinates;
    
    
    
}

-(void)centerMapAtCoordinates:(CLLocationCoordinate2D)coordinates {
    
    MKCoordinateRegion __block region;
    
    region = MKCoordinateRegionMake(coordinates, MKCoordinateSpanMake(0.001, 0.001));
    
    [self.mapView setRegion:region animated:YES];
    
    [SVProgressHUD showWithStatus:@"Calculating Geometry"];
    
    [self getSpanFromGoogleForCoordinates:coordinates completion:^(MKCoordinateSpan span, NSError *error) {
    
        [SVProgressHUD dismiss];
        
        if(!error){
            region = MKCoordinateRegionMake(coordinates, span);
            [self.mapView setRegion:region animated:YES];
        
        }else{
            [SVProgressHUD showErrorWithStatus:@"Couldn't Calculate Geometry"];
        }
    
    }];
}



-(void)getSpanFromGoogleForCoordinates:(CLLocationCoordinate2D)coordinates completion:(void(^)(MKCoordinateSpan span, NSError *error))completion {
    
    AFHTTPClient *httpClient = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:@"http://maps.googleapis.com/maps/api/"]];
    
    NSDictionary *parameters = @{@"latlng": [NSString stringWithFormat:@"%f,%f", coordinates.latitude, coordinates.longitude],
                                 @"sensor":@"true"
                                 };
    
    NSMutableURLRequest *request = [httpClient requestWithMethod:@"GET" path:@"geocode/json" parameters:parameters];
    
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
        
        MKCoordinateSpan span;
        float largestSpan = 0;
        
        if([[JSON objectForKey:@"status"] isEqualToString:@"OK"]){
            NSDictionary *results = [[JSON objectForKey:@"results"] objectAtIndex:0];
            NSDictionary *geometry = [results objectForKey:@"geometry"];
            NSDictionary *bounds = [geometry objectForKey:@"bounds"];
            if(bounds){
                NSDictionary *northEast = [bounds objectForKey:@"northeast"];
                NSDictionary *southWest = [bounds objectForKey:@"southwest"];
                self.northEastBound = CLLocationCoordinate2DMake([[northEast objectForKey:@"lat"] floatValue], [[northEast objectForKey:@"lng"] floatValue]);
                
                self.southWestBound = CLLocationCoordinate2DMake([[southWest objectForKey:@"lat"] floatValue], [[southWest objectForKey:@"lng"] floatValue]);
                
                float latSpan = abs(self.northEastBound.latitude - self.southWestBound.latitude);
                float lngSpan = abs(self.northEastBound.longitude - self.southWestBound.longitude);
                largestSpan = latSpan > lngSpan ? latSpan : lngSpan;
                
                
                
            }
        }
        
        if(largestSpan == 0){
            largestSpan = 0.001;
        }
        
        span = MKCoordinateSpanMake(largestSpan, largestSpan);
        
        completion(span, nil);
        
        
    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        
        completion(MKCoordinateSpanMake(0, 0), error);
    }];
    
    [operation start];
    
}
-(void)mapTapped:(UITapGestureRecognizer*)recognizer{
    CGPoint touchPoint = [recognizer locationInView:self.mapView];
    CLLocationCoordinate2D touchMapCoordinate = [self.mapView convertPoint:touchPoint toCoordinateFromView:self.mapView];
    
    if([self.delegate respondsToSelector:@selector(mapSelectView:didSelectLocation:)]){
        [self.delegate mapSelectView:self didSelectLocation:touchMapCoordinate];
    }
    
    if(selectedLocation)
        [self.mapView removeAnnotation:(id)selectedLocation];
    
    selectedLocation = [[MMLocationAnnotation alloc] initWithName:@"NEW HOT SPOT" address:nil coordinate:touchMapCoordinate arrayIndex:1];
    selectedLocation.pinColor = MKPinAnnotationColorRed;
    [self.mapView addAnnotation:(id)selectedLocation];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(MKAnnotationView *)mapView:(MKMapView *)mapView viewForAnnotation:(id<MKAnnotation>)annotation {
    
    static NSString *AnnotationIdentifier = @"Pin";
    
    MKPinAnnotationColor pinColor = ((MMLocationAnnotation*)annotation).pinColor;
    
    MKPinAnnotationView *pv = (MKPinAnnotationView *)[mapView
                                                      dequeueReusableAnnotationViewWithIdentifier:AnnotationIdentifier];
    if (!pv)
    {
        pv = [[MKPinAnnotationView alloc] initWithAnnotation:annotation
                                             reuseIdentifier:AnnotationIdentifier];
        
        [pv setCanShowCallout:YES];
        [pv setRightCalloutAccessoryView:[UIButton buttonWithType:UIButtonTypeDetailDisclosure]];
    }
    else
    {
        //we're re-using an annotation view
        //update annotation property in case re-used view was for another
        pv.annotation = annotation;
    }
    [pv setPinColor:pinColor];
    
    return pv;
}
@end
