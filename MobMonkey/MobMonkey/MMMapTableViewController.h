//
//  MMMapTableViewController.h
//  MobMonkey
//
//  Created by Michael Kral on 5/23/13.
//  Copyright (c) 2013 Reyaad Sidique. All rights reserved.
//

#import <UIKit/UIKit.h>
@class MMMapTableViewController;

@protocol MMMapTableViewControllerDelegate <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MKMapViewDelegate>

@optional
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOffMapView:(MKMapView*)mapView;
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController didScrollOnMapView:(MKMapView*)mapView;
-(void)mapTableViewController:(MMMapTableViewController *)mapTableViewController isScrollingOffScreen:(MKMapView*)mapView visibility:(CGFloat)visibility;
@end

@interface MMMapTableViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, MKMapViewDelegate, MMMapTableViewControllerDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, strong) UITableView *tableView;
@property (assign) id <MMMapTableViewControllerDelegate> delegate;
@property (nonatomic, strong) UIView *tableBackground;
@property (nonatomic, strong) UIView *closeMapView;

-(id)initWithTableViewStyle:(UITableViewCellStyle)tableViewStyle defaultMapHeight:(CGFloat)defaultMapHeight parallaxFactor:(CGFloat)parallaxFactor;

@end
