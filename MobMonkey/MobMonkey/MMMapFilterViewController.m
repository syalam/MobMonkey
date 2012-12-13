//
//  MMMapFilterViewController.m
//  MobMonkey
//
//  Created by Scott Menor on 13/12/12.
//  Copyright (c) 2012 Reyaad Sidique. All rights reserved.
//

#import "MMMapFilterViewController.h"

@interface MMMapFilterViewController ()

@end

@implementation MMMapFilterViewController

- (id)init
{
  self = [super initWithNibName:@"MMMapFilterViewController" bundle:nil];
  return self;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
  self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
  if (self) {
    // Custom initialization
  }
  return self;
}

- (void)viewDidLoad
{
  [super viewDidLoad];
  
  NSLog(@"map filter view did load");
  // disable user interaction for map
  mapView.scrollEnabled = NO;
  mapView.zoomEnabled = NO;
  
  mapView.delegate = self;
  
  // add gesture recognizer
  UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc]
                                               initWithTarget:self
                                               action:@selector(handleTap:)];

  [mapView addGestureRecognizer:tapGestureRecognizer];
}

- (void)handleTap:(UIGestureRecognizer *)gestureRecognizer
{
  CGPoint touchPoint = [gestureRecognizer locationInView:mapView];
  CLLocationCoordinate2D touchMapCoordinate = [mapView convertPoint:touchPoint toCoordinateFromView:mapView];
  MKPointAnnotation *pointAnnotation = [[MKPointAnnotation alloc] init];
  pointAnnotation.coordinate = touchMapCoordinate;
  pointAnnotation.title = @"Hello";
  [mapView addAnnotation:pointAnnotation];
  
/*  UIActionSheet *actionSheet = [[UIActionSheet alloc] initWithTitle:@"title" delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"destructive" otherButtonTitles:@"other titles", nil];
  
  [actionSheet showInView:mapView];*/
}

- (void)didReceiveMemoryWarning
{
  [super didReceiveMemoryWarning];
  // Dispose of any resources that can be recreated.
}

@end
